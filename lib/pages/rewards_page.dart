import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/nft_service.dart';
import '../services/web3_service.dart';
import '../services/database_service.dart';
import '../utils/confetti_overlay.dart';

/// Page displaying streak NFT rewards
class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final NFTService _nftService = NFTService();
  final Web3Service _web3Service = Web3Service();
  final DatabaseService _databaseService = DatabaseService();
  late final ConfettiController _confettiController;

  int _currentStreak = 0;
  bool _isLoading = true;
  bool _isMinting = false;
  StreakMilestone? _mintingMilestone;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _loadData();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await _nftService.initialize();
    await _calculateStreak();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _calculateStreak() async {
    final journalEntries = await _databaseService.getJournalEntries();
    if (journalEntries.isEmpty) {
      _currentStreak = 0;
      return;
    }

    final now = DateTime.now();
    int streak = 0;
    DateTime checkDate = DateTime(now.year, now.month, now.day);

    // Group entries by date
    final entriesByDate = <String, bool>{};
    for (final entry in journalEntries) {
      final dateKey =
          '${entry.createdAt.year}-${entry.createdAt.month}-${entry.createdAt.day}';
      entriesByDate[dateKey] = true;
    }

    // Check today first, if no entry today, start from yesterday
    final todayKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
    if (!entriesByDate.containsKey(todayKey)) {
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    // Count consecutive days
    while (true) {
      final dateKey = '${checkDate.year}-${checkDate.month}-${checkDate.day}';
      if (entriesByDate.containsKey(dateKey)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    _currentStreak = streak;
  }

  Future<void> _disconnectWallet() async {
    try {
      await _web3Service.disconnect();
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Wallet disconnected. Please reconnect while on Sepolia testnet.',
            ),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to disconnect: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _mintNFT(StreakMilestone milestone) async {
    setState(() {
      _isMinting = true;
      _mintingMilestone = milestone;
    });

    // Initialize web3 service if needed
    if (!_web3Service.isInitialized) {
      try {
        await _web3Service.initialize(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to initialize wallet service: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          setState(() {
            _isMinting = false;
            _mintingMilestone = null;
          });
        }
        return;
      }
    }

    // Auto-connect wallet if not connected
    if (!_web3Service.isConnected) {
      try {
        final address = await _web3Service.connectWallet();

        if (address == null || !_web3Service.isConnected) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Wallet connection required to mint NFT'),
              ),
            );
            setState(() {
              _isMinting = false;
              _mintingMilestone = null;
            });
          }
          return;
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to connect wallet: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          setState(() {
            _isMinting = false;
            _mintingMilestone = null;
          });
        }
        return;
      }
    }

    try {
      final txHash = await _nftService.mintStreakNFT(milestone);
      if (txHash != null && mounted) {
        _confettiController.play();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${milestone.name} NFT minted successfully!'),
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                launchUrl(Uri.parse(_nftService.getEtherscanUrl(txHash)));
              },
            ),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to mint NFT: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isMinting = false;
          _mintingMilestone = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rewards = _nftService.getAvailableRewards(_currentStreak);
    final unlockedCount = rewards.where((r) => r.isEarned).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Streak Rewards'), centerTitle: true),
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: CustomScrollView(
                    slivers: [
                      // Header with current streak
                      SliverToBoxAdapter(child: _buildStreakHeader(context)),

                      // Progress indicator
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NFT Rewards',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$unlockedCount of ${rewards.length} unlocked',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // NFT reward cards
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildRewardCard(context, rewards[index]),
                            ),
                            childCount: rewards.length,
                          ),
                        ),
                      ),

                      // Wallet status section
                      SliverToBoxAdapter(
                        child: _buildWalletStatusSection(context),
                      ),

                      // Info section
                      SliverToBoxAdapter(child: _buildInfoSection(context)),

                      const SliverToBoxAdapter(child: SizedBox(height: 32)),
                    ],
                  ),
                ),
          CelebrationConfetti(controller: _confettiController),
        ],
      ),
    );
  }

  Widget _buildStreakHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          Text(
            '$_currentStreak',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Day Streak',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          _buildNextMilestoneProgress(context),
        ],
      ),
    );
  }

  Widget _buildNextMilestoneProgress(BuildContext context) {
    // Find next milestone
    StreakMilestone? nextMilestone;
    for (final milestone in StreakMilestone.values) {
      if (_currentStreak < milestone.requiredStreak) {
        nextMilestone = milestone;
        break;
      }
    }

    if (nextMilestone == null) {
      return Text(
        '🏆 All milestones achieved!',
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: Colors.white),
      );
    }

    final progress = _currentStreak / nextMilestone.requiredStreak;
    final daysRemaining = nextMilestone.requiredStreak - _currentStreak;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$daysRemaining days until ${nextMilestone.name}',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.9)),
        ),
      ],
    );
  }

  Widget _buildRewardCard(BuildContext context, NFTReward reward) {
    final isLocked = !reward.isEarned;
    final canMint = reward.isEarned && !reward.isMinted;
    final isMinting = _isMinting && _mintingMilestone == reward.milestone;

    return Card(
      elevation: isLocked ? 0 : 2,
      color: isLocked
          ? Theme.of(context).colorScheme.surfaceContainerHighest
          : null,
      child: InkWell(
        onTap: canMint ? () => _mintNFT(reward.milestone) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // NFT Image/Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.grey.withOpacity(0.3)
                      : _getRarityColor(
                          reward.milestone.rarity,
                        ).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isLocked
                        ? Colors.grey.withOpacity(0.5)
                        : _getRarityColor(reward.milestone.rarity),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    isLocked ? '🔒' : reward.milestone.emoji,
                    style: TextStyle(
                      fontSize: 28,
                      color: isLocked ? Colors.grey : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          reward.milestone.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isLocked ? Colors.grey : null,
                              ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isLocked
                                ? Colors.grey.withOpacity(0.3)
                                : _getRarityColor(
                                    reward.milestone.rarity,
                                  ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            reward.milestone.rarity,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: isLocked
                                      ? Colors.grey
                                      : _getRarityColor(
                                          reward.milestone.rarity,
                                        ),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${reward.milestone.requiredStreak} day streak',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant
                            .withOpacity(isLocked ? 0.5 : 1),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reward.milestone.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant
                            .withOpacity(isLocked ? 0.5 : 1),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Action button
              if (canMint)
                isMinting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : SizedBox(
                        width: 70,
                        child: FilledButton(
                          onPressed: () => _mintNFT(reward.milestone),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text('Mint'),
                        ),
                      )
              else if (reward.isMinted)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                )
              else if (isLocked)
                Text(
                  '${reward.milestone.requiredStreak - _currentStreak}d',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletStatusSection(BuildContext context) {
    final isConnected = _web3Service.isConnected;
    final address = _web3Service.walletAddress;
    final chainId = _web3Service.chainId;
    final isSepoliaNetwork =
        chainId == 'eip155:11155111' || chainId == '11155111';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isConnected
              ? (isSepoliaNetwork
                    ? Colors.green.withOpacity(0.3)
                    : Colors.orange.withOpacity(0.3))
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isConnected
                    ? Icons.account_balance_wallet
                    : Icons.account_balance_wallet_outlined,
                size: 20,
                color: isConnected
                    ? (isSepoliaNetwork ? Colors.green : Colors.orange)
                    : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(
                'Wallet Status',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isConnected
                      ? (isSepoliaNetwork
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1))
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isConnected
                      ? (isSepoliaNetwork ? 'Sepolia' : 'Wrong Network')
                      : 'Not Connected',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isConnected
                        ? (isSepoliaNetwork ? Colors.green : Colors.orange)
                        : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          if (isConnected) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${address?.substring(0, 6)}...${address?.substring(address.length - 4)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: _disconnectWallet,
                  icon: const Icon(Icons.logout, size: 16),
                  label: const Text('Disconnect'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
            if (!isSepoliaNetwork) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please disconnect and reconnect while MetaMask is on Sepolia testnet',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.orange.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ] else ...[
            const SizedBox(height: 8),
            Text(
              'Connect your wallet to mint NFT rewards',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'How it works',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '• Maintain your journal streak to unlock NFT rewards\n'
            '• Connect your wallet in Settings to mint NFTs\n'
            '• NFTs are minted on Sepolia testnet (free, no real ETH needed)\n'
            '• Each milestone can only be claimed once\n'
            '• View your NFTs on OpenSea testnets',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'Starter':
        return Colors.green;
      case 'Common':
        return Colors.grey.shade600;
      case 'Rare':
        return Colors.blue;
      case 'Epic':
        return Colors.purple;
      case 'Legendary':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
