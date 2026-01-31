import 'package:flutter/material.dart';
import '../../config/web3_config.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../utils/responsive.dart';
import 'payment_page.dart';

class CheckoutPage extends StatelessWidget {
  final String therapistName;
  final DateTime date;
  final String time;
  final int price;
  final String urgency;

  const CheckoutPage({
    super.key,
    required this.therapistName,
    required this.date,
    required this.time,
    required this.price,
    required this.urgency,
  });

  int get _urgencyFee => urgency == 'urgent' ? 20 : 0;
  // Use $1 for testnet to save test ETH, real amount for mainnet
  int get _total => Web3Config.useTestnet ? 1 : (price + _urgencyFee);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(l10n.checkout),
      ),
      body: SingleChildScrollView(
        padding: Responsive.pagePadding(context),
        child: ResponsiveCenter(
          maxWidth: 500,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.summary,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _SummaryRow(label: l10n.therapist, value: therapistName),
                    _SummaryRow(
                      label: l10n.date,
                      value: '${date.day}/${date.month}/${date.year}',
                    ),
                    _SummaryRow(label: l10n.time, value: time),
                    _SummaryRow(
                      label: l10n.type,
                      value: urgency == 'urgent' ? l10n.urgent : l10n.normal,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text(
                l10n.price,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _PriceRow(label: l10n.session, amount: price),
                    if (_urgencyFee > 0)
                      _PriceRow(label: l10n.urgencyFee, amount: _urgencyFee),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.total,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '\$$_total',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Test mode indicator
              if (Web3Config.useTestnet)
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.science_rounded,
                        size: 18,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          l10n.testModeMessage,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        l10n.freeCancellation,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentPage(
                        amount: _total,
                        therapistName: therapistName,
                        date: date,
                        time: time,
                      ),
                    ),
                  );
                },
                child: Text(l10n.payAmount(_total)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final int amount;

  const _PriceRow({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text('\$$amount')],
      ),
    );
  }
}
