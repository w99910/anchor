import 'package:flutter/material.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/responsive.dart';
import '../../services/web3_service.dart';
import '../../config/web3_config.dart';
import '../../main.dart'
    show savePendingPayment, clearPendingPayment, appointmentService;

class PaymentPage extends StatefulWidget {
  final int amount;
  final String therapistName;
  final DateTime? date;
  final String? time;

  const PaymentPage({
    super.key,
    required this.amount,
    required this.therapistName,
    this.date,
    this.time,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _method = 'card';
  bool _processing = false;
  bool _complete = false;
  String? _transactionHash;

  // Web3 service
  final Web3Service _web3Service = Web3Service();

  // Web3 wallet state
  bool _walletConnected = false;
  String? _walletAddress;

  @override
  void initState() {
    super.initState();
    // Initialize Web3 after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeWeb3();
    });
  }

  Future<void> _initializeWeb3() async {
    try {
      await _web3Service.initialize(context);

      // Listen to connection changes
      _web3Service.addListener(_onWeb3StateChange);

      // Check if already connected
      _onWeb3StateChange();
    } catch (e) {
      // Handle initialization error
      debugPrint('Web3 initialization error: $e');
    }
  }

  void _onWeb3StateChange() {
    if (!mounted) return;
    setState(() {
      _walletConnected = _web3Service.isConnected;
      _walletAddress = _web3Service.walletAddress;
    });
  }

  void _pay() async {
    if (_method == 'crypto' && !_walletConnected) {
      _connectWallet();
      return;
    }

    setState(() {
      _processing = true;
    });

    try {
      String? txHash;

      if (_method == 'crypto') {
        // Real crypto payment
        txHash = await _web3Service.sendPayment(
          recipientAddress: Web3Config.recipientWalletAddress,
          amountInUsd: widget.amount.toDouble(),
        );
        debugPrint('Transaction hash: $txHash');
      } else {
        // Mock payment for card/PayPal
        await Future.delayed(const Duration(seconds: 2));
      }

      // Save appointment on successful payment
      await appointmentService.addAppointment(
        therapistName: widget.therapistName,
        date: widget.date ?? DateTime.now().add(const Duration(days: 1)),
        time: widget.time ?? '10:00 AM',
        amount: widget.amount,
        paymentMethod: _method,
        transactionHash: txHash,
      );

      // Clear pending payment on success
      await clearPendingPayment();

      setState(() {
        _transactionHash = txHash;
        _processing = false;
        _complete = true;
      });
    } catch (e) {
      debugPrint('Payment error: $e');
      setState(() {
        _processing = false;
      });

      if (mounted) {
        final errorMessage = e.toString();
        final isNetworkError =
            errorMessage.contains('Sepolia') ||
            errorMessage.contains('switch') ||
            errorMessage.contains('network') ||
            errorMessage.contains('Chain');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isNetworkError
                  ? AppLocalizations.of(context)!.pleaseSelectSepoliaNetwork
                  : AppLocalizations.of(context)!.paymentFailed(errorMessage),
            ),
            backgroundColor: Colors.red,
            action: isNetworkError
                ? SnackBarAction(
                    label: AppLocalizations.of(context)!.switchNetwork,
                    textColor: Colors.white,
                    onPressed: _switchNetwork,
                  )
                : null,
            duration: isNetworkError
                ? const Duration(seconds: 6)
                : const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _switchNetwork() async {
    try {
      await _web3Service.switchChain();
    } catch (e) {
      debugPrint('Switch network error: $e');
    }
  }

  void _connectWallet() async {
    try {
      // Save payment state before opening wallet (in case app gets killed)
      await savePendingPayment(
        amount: widget.amount,
        therapistName: widget.therapistName,
        date: widget.date ?? DateTime.now().add(const Duration(days: 1)),
        time: widget.time ?? '10:00 AM',
      );

      // Open the AppKit modal - this shows a beautiful wallet selection UI
      await _web3Service.openModal();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.failedToConnectWallet(e.toString()),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _disconnectWallet() async {
    try {
      await _web3Service.disconnect();
      await clearPendingPayment();
    } catch (e) {
      debugPrint('Error disconnecting wallet: $e');
    }
  }

  @override
  void dispose() {
    _web3Service.removeListener(_onWeb3StateChange);
    // Don't clear pending payment here - it might be needed if app restarts
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_complete) {
      return _SuccessScreen(
        therapistName: widget.therapistName,
        paymentMethod: _method,
        transactionHash: _transactionHash,
        date: widget.date,
        time: widget.time,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () async {
            await clearPendingPayment();
            if (context.mounted) Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(AppLocalizations.of(context)!.payment),
      ),
      body: SingleChildScrollView(
        padding: Responsive.pagePadding(context),
        child: ResponsiveCenter(
          maxWidth: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.total,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '\$${widget.amount}',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (_method == 'crypto')
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '≈ ${(widget.amount / 2500).toStringAsFixed(4)} ETH',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                    .withOpacity(0.7),
                              ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.paymentMethod,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              // Card payment
              _PaymentOption(
                icon: Icons.credit_card_rounded,
                title: AppLocalizations.of(context)!.creditDebitCard,
                subtitle: AppLocalizations.of(context)!.visaMastercardAmex,
                isSelected: _method == 'card',
                onTap: () => setState(() => _method = 'card'),
              ),

              // PayPal
              _PaymentOption(
                icon: Icons.account_balance_wallet_rounded,
                title: 'PayPal',
                subtitle: AppLocalizations.of(context)!.payWithPaypal,
                isSelected: _method == 'paypal',
                onTap: () => setState(() => _method = 'paypal'),
              ),

              // Crypto/Web3 payment - user friendly
              _CryptoPaymentOption(
                isSelected: _method == 'crypto',
                walletConnected: _walletConnected,
                walletAddress: _walletAddress,
                onTap: () => setState(() => _method = 'crypto'),
                onConnect: _connectWallet,
                onDisconnect: _disconnectWallet,
              ),

              // Card form
              if (_method == 'card') ...[
                const SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.cardNumber,
                    prefixIcon: const Icon(Icons.credit_card_rounded),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'MM/YY'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(labelText: 'CVV'),
                        keyboardType: TextInputType.number,
                        obscureText: true,
                      ),
                    ),
                  ],
                ),
              ],

              // Crypto info
              if (_method == 'crypto' &&
                  _walletConnected &&
                  _walletAddress != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.walletConnected,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                            ),
                            Text(
                              '${_walletAddress!.substring(0, 6)}...${_walletAddress!.substring(_walletAddress!.length - 4)}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Security badge
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_rounded,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _method == 'crypto'
                        ? AppLocalizations.of(context)!.securedByBlockchain
                        : AppLocalizations.of(context)!.securePayment,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              FilledButton(
                onPressed: _processing ? null : _pay,
                child: _processing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _method == 'crypto' && !_walletConnected
                            ? AppLocalizations.of(context)!.connectWalletToPay
                            : AppLocalizations.of(
                                context,
                              )!.payAmount(widget.amount),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CryptoPaymentOption extends StatelessWidget {
  final bool isSelected;
  final bool walletConnected;
  final String? walletAddress;
  final VoidCallback onTap;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const _CryptoPaymentOption({
    required this.isSelected,
    required this.walletConnected,
    required this.walletAddress,
    required this.onTap,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Crypto icon
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF627EEA), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.diamond_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Digital Wallet',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'No fees',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'MetaMask, Trust Wallet, Coinbase & more',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<bool>(
                  value: true,
                  groupValue: isSelected,
                  onChanged: (_) => onTap(),
                ),
              ],
            ),

            // Wallet connection button when selected
            if (isSelected) ...[
              const SizedBox(height: 12),
              if (!walletConnected || walletAddress == null)
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onConnect,
                    icon: const Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 18,
                    ),
                    label: Text(AppLocalizations.of(context)!.connectWallet),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 40),
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${walletAddress!.substring(0, 6)}...${walletAddress!.substring(walletAddress!.length - 4)}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: onDisconnect,
                      child: Text(AppLocalizations.of(context)!.disconnect),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SuccessScreen extends StatelessWidget {
  final String therapistName;
  final String paymentMethod;
  final String? transactionHash;
  final DateTime? date;
  final String? time;

  const _SuccessScreen({
    required this.therapistName,
    required this.paymentMethod,
    this.transactionHash,
    this.date,
    this.time,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'TBD';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 48,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppLocalizations.of(context)!.booked,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.sessionConfirmed(therapistName),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              // Appointment details
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.calendar_today_rounded,
                      label: AppLocalizations.of(context)!.date,
                      value: _formatDate(date),
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.access_time_rounded,
                      label: AppLocalizations.of(context)!.time,
                      value: time ?? AppLocalizations.of(context)!.tbd,
                    ),
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.person_rounded,
                      label: AppLocalizations.of(context)!.therapist,
                      value: therapistName,
                    ),
                  ],
                ),
              ),

              if (paymentMethod == 'crypto') ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF627EEA), Color(0xFF8B5CF6)],
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.diamond_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.paidWithDigitalWallet,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (transactionHash != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Tx: ${transactionHash!.substring(0, 10)}...${transactionHash!.substring(transactionHash!.length - 8)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],

              const SizedBox(height: 48),
              FilledButton(
                onPressed: () async {
                  await appointmentService.clearLastCompletedPayment();
                  if (context.mounted) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                child: Text(AppLocalizations.of(context)!.done),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () async {
                  await appointmentService.clearLastCompletedPayment();
                  if (context.mounted) {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                child: Text(AppLocalizations.of(context)!.viewMyAppointments),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

/// Standalone success page for showing after app restart
class PaymentSuccessPage extends StatelessWidget {
  final String therapistName;
  final String paymentMethod;
  final String? transactionHash;
  final DateTime? date;
  final String? time;

  const PaymentSuccessPage({
    super.key,
    required this.therapistName,
    required this.paymentMethod,
    this.transactionHash,
    this.date,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return _SuccessScreen(
      therapistName: therapistName,
      paymentMethod: paymentMethod,
      transactionHash: transactionHash,
      date: date,
      time: time,
    );
  }
}
