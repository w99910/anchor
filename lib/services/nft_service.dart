import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'web3_service.dart';

/// NFT Milestone definitions for streak rewards
enum StreakMilestone {
  firstStep(1, 'First Step', 'Completed your first journal entry'),
  weekWarrior(7, 'Week Warrior', 'Completed 7 consecutive days of journaling'),
  monthlyMaster(
    30,
    'Monthly Master',
    'Completed 30 consecutive days of journaling',
  ),
  centuryChampion(
    100,
    'Century Champion',
    'Completed 100 consecutive days of journaling',
  ),
  yearLegend(
    365,
    'Year Legend',
    'Completed 365 consecutive days of journaling',
  );

  final int requiredStreak;
  final String name;
  final String description;

  const StreakMilestone(this.requiredStreak, this.name, this.description);

  /// Get emoji for display
  String get emoji {
    switch (this) {
      case StreakMilestone.firstStep:
        return '🌱';
      case StreakMilestone.weekWarrior:
        return '🥉';
      case StreakMilestone.monthlyMaster:
        return '🥈';
      case StreakMilestone.centuryChampion:
        return '🥇';
      case StreakMilestone.yearLegend:
        return '🏆';
    }
  }

  /// Get rarity tier
  String get rarity {
    switch (this) {
      case StreakMilestone.firstStep:
        return 'Starter';
      case StreakMilestone.weekWarrior:
        return 'Common';
      case StreakMilestone.monthlyMaster:
        return 'Rare';
      case StreakMilestone.centuryChampion:
        return 'Epic';
      case StreakMilestone.yearLegend:
        return 'Legendary';
    }
  }
}

/// Represents an earned or available NFT reward
class NFTReward {
  final StreakMilestone milestone;
  final bool isEarned;
  final bool isMinted;
  final String? tokenId;
  final String? transactionHash;
  final DateTime? mintedAt;

  NFTReward({
    required this.milestone,
    required this.isEarned,
    this.isMinted = false,
    this.tokenId,
    this.transactionHash,
    this.mintedAt,
  });
}

/// NFT Service for minting streak reward NFTs
///
/// Uses ERC-721 contract on Sepolia testnet for testing
class NFTService extends ChangeNotifier {
  static final NFTService _instance = NFTService._internal();
  factory NFTService() => _instance;
  NFTService._internal();

  final Web3Service _web3Service = Web3Service();

  // Contract deployed on Sepolia testnet
  static const String _contractAddress =
      '0x67c6A729D373E6772c35298bca91393274490F44';

  // Claimed milestones (stored locally, should sync with contract)
  final Set<StreakMilestone> _claimedMilestones = {};

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Initialize the NFT service
  Future<void> initialize() async {
    if (_initialized) return;

    // TODO: Load claimed milestones from local storage or contract
    _initialized = true;
    notifyListeners();
  }

  /// Get all available rewards based on current streak
  List<NFTReward> getAvailableRewards(int currentStreak) {
    return StreakMilestone.values.map((milestone) {
      final isEarned = currentStreak >= milestone.requiredStreak;
      final isMinted = _claimedMilestones.contains(milestone);

      return NFTReward(
        milestone: milestone,
        isEarned: isEarned,
        isMinted: isMinted,
      );
    }).toList();
  }

  /// Get newly unlocked milestones (earned but not yet minted)
  List<StreakMilestone> getUnlockedMilestones(int currentStreak) {
    return StreakMilestone.values
        .where(
          (m) =>
              currentStreak >= m.requiredStreak &&
              !_claimedMilestones.contains(m),
        )
        .toList();
  }

  /// Check if a specific milestone is unlocked
  bool isMilestoneUnlocked(StreakMilestone milestone, int currentStreak) {
    return currentStreak >= milestone.requiredStreak;
  }

  /// Check if a milestone NFT has been minted
  bool isMilestoneMinted(StreakMilestone milestone) {
    return _claimedMilestones.contains(milestone);
  }

  /// Ensure the wallet is connected to Sepolia testnet
  Future<void> _ensureSepoliaNetwork() async {
    // Poll for up to 10 seconds to allow the user to switch networks
    const maxAttempts = 20;
    const pollInterval = Duration(milliseconds: 500);

    for (int attempt = 0; attempt < maxAttempts; attempt++) {
      final currentChainId = _web3Service.appKitModal?.selectedChain?.chainId;
      final isOnSepolia =
          currentChainId == '11155111' || currentChainId == 'eip155:11155111';

      if (kDebugMode) {
        print(
          'NFTService: Attempt ${attempt + 1}/$maxAttempts - Current chain: $currentChainId, isOnSepolia: $isOnSepolia',
        );
      }

      if (isOnSepolia) {
        if (kDebugMode) {
          print('NFTService: Already on Sepolia, proceeding with mint');
        }
        return;
      }

      // On first attempt, try to request a network switch
      if (attempt == 0) {
        if (kDebugMode) {
          print('NFTService: Not on Sepolia, attempting to switch...');
        }
        // Don't await - let the switch happen asynchronously while we poll
        _web3Service
            .switchToSepolia()
            .then((switched) {
              if (kDebugMode) {
                print('NFTService: switchToSepolia returned: $switched');
              }
            })
            .catchError((e) {
              if (kDebugMode) {
                print('NFTService: switchToSepolia error: $e');
              }
            });
      }

      // Wait before checking again
      await Future.delayed(pollInterval);
    }

    // If we get here, the network switch didn't happen in time
    throw Exception(
      'Please switch to Sepolia testnet in your wallet to mint NFTs. '
      'The NFT contract is deployed on Sepolia.',
    );
  }

  /// Check if a milestone has already been claimed on-chain for the connected wallet
  Future<bool> isMilestoneClaimedOnChain(StreakMilestone milestone) async {
    if (!_web3Service.isConnected || _web3Service.walletAddress == null) {
      return false;
    }

    try {
      // ABI for hasClaimedMilestone view function
      final contractAbi = ContractAbi.fromJson('''[
          {
            "inputs": [
              {"internalType": "address", "name": "user", "type": "address"},
              {"internalType": "uint256", "name": "milestoneId", "type": "uint256"}
            ],
            "name": "hasClaimedMilestone",
            "outputs": [{"internalType": "bool", "name": "", "type": "bool"}],
            "stateMutability": "view",
            "type": "function"
          }
        ]''', 'AnchorStreakNFT');

      final contract = DeployedContract(
        contractAbi,
        EthereumAddress.fromHex(_contractAddress),
      );

      final hasClaimedFunction = contract.function('hasClaimedMilestone');

      // Encode the call data
      final data = hasClaimedFunction.encodeCall([
        EthereumAddress.fromHex(_web3Service.walletAddress!),
        BigInt.from(milestone.index),
      ]);

      // Call eth_call via the RPC
      final result = await _web3Service.callContract(
        contractAddress: _contractAddress,
        data:
            '0x${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
      );

      if (result != null && result.isNotEmpty) {
        // Decode the boolean result (last byte, 1 = true, 0 = false)
        final resultBytes = result.startsWith('0x')
            ? result.substring(2)
            : result;
        if (resultBytes.isNotEmpty) {
          final lastByte = int.parse(
            resultBytes.substring(resultBytes.length - 2),
            radix: 16,
          );
          return lastByte == 1;
        }
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('NFTService: Error checking claimed status: $e');
      }
      return false;
    }
  }

  /// Mint a streak reward NFT
  ///
  /// Returns the transaction hash if successful.
  /// Automatically connects wallet if not already connected.
  Future<String?> mintStreakNFT(StreakMilestone milestone) async {
    // Auto-connect wallet if not connected
    if (!_web3Service.isConnected) {
      if (kDebugMode) {
        print('NFTService: Wallet not connected, opening connection modal...');
      }
      await _web3Service.connectWallet();

      // Check if connection was successful
      if (!_web3Service.isConnected) {
        throw Exception('Wallet connection required to mint NFT');
      }
    }

    // Ensure we're on Sepolia testnet before minting
    await _ensureSepoliaNetwork();

    // Check local cache first
    if (_claimedMilestones.contains(milestone)) {
      throw Exception(
        'You have already minted the "${milestone.name}" NFT with this wallet.',
      );
    }

    // Check on-chain if this milestone was already claimed
    final alreadyClaimedOnChain = await isMilestoneClaimedOnChain(milestone);
    if (alreadyClaimedOnChain) {
      // Update local cache
      _claimedMilestones.add(milestone);
      notifyListeners();
      throw Exception(
        'You have already minted the "${milestone.name}" NFT with this wallet. '
        'Each milestone can only be claimed once per wallet.',
      );
    }

    try {
      // Contract ABI for mintStreakReward function
      // function mintStreakReward(address to, uint256 milestoneId)
      final contractAbi = ContractAbi.fromJson('''[
          {
            "inputs": [
              {"internalType": "address", "name": "to", "type": "address"},
              {"internalType": "uint256", "name": "milestoneId", "type": "uint256"}
            ],
            "name": "mintStreakReward",
            "outputs": [],
            "stateMutability": "nonpayable",
            "type": "function"
          }
        ]''', 'AnchorStreakNFT');

      final contract = DeployedContract(
        contractAbi,
        EthereumAddress.fromHex(_contractAddress),
      );

      final mintFunction = contract.function('mintStreakReward');

      // Encode function call
      final data = mintFunction.encodeCall([
        EthereumAddress.fromHex(_web3Service.walletAddress!),
        BigInt.from(milestone.index),
      ]);

      // Send transaction via Web3Service
      // Note: This uses the AppKit modal's transaction signing
      final txHash = await _web3Service.sendTransaction(
        toAddress: _contractAddress,
        data:
            '0x${data.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}',
      );

      if (txHash != null) {
        _claimedMilestones.add(milestone);
        notifyListeners();

        if (kDebugMode) {
          print('NFTService: Minted ${milestone.name} NFT - TX: $txHash');
        }

        return txHash;
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('NFTService: Failed to mint NFT: $e');
      }
      rethrow;
    }
  }

  /// Get OpenSea URL for viewing NFT (Sepolia testnet)
  String getOpenSeaUrl(String tokenId) {
    return 'https://testnets.opensea.io/assets/sepolia/$_contractAddress/$tokenId';
  }

  /// Get Etherscan URL for transaction
  String getEtherscanUrl(String txHash) {
    return 'https://sepolia.etherscan.io/tx/$txHash';
  }
}

// Extension to Web3Service for transaction sending with data
extension Web3ServiceNFT on Web3Service {
  /// Send a transaction with custom data (for contract calls)
  Future<String?> sendTransaction({
    required String toAddress,
    String? data,
    BigInt? value,
  }) async {
    if (!isConnected || appKitModal == null) {
      throw Exception('Wallet not connected');
    }

    try {
      final session = appKitModal!.session;
      if (session == null) {
        throw Exception('No active session');
      }

      // Force Sepolia testnet chain ID for safety
      const sepoliaChainId = 'eip155:11155111';

      // Verify we're on Sepolia in testnet mode
      if (kDebugMode) {
        print('Web3Service: Sending transaction on chain: $sepoliaChainId');
      }

      // Launch wallet before making the request to ensure it opens
      // This is needed because the automatic redirect may not work on all devices
      _launchWalletForTransaction();

      // Use Sepolia chain ID explicitly
      final result = await appKitModal!.request(
        topic: session.topic ?? '',
        chainId: sepoliaChainId,
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [
            {
              'from': walletAddress!,
              'to': toAddress,
              'data': data ?? '0x',
              'value': value != null ? '0x${value.toRadixString(16)}' : '0x0',
            },
          ],
        ),
      );

      return result.toString();
    } catch (e) {
      if (kDebugMode) {
        print('Web3Service: Transaction failed: $e');
      }
      rethrow;
    }
  }

  /// Launch the connected wallet app for transaction signing
  void _launchWalletForTransaction() {
    try {
      // Get the redirect info from the connected wallet's session
      final session = appKitModal!.session;
      final peerRedirect = session?.peer?.metadata.redirect;

      if (kDebugMode) {
        print(
          'Web3Service: Peer redirect info: native=${peerRedirect?.native}, universal=${peerRedirect?.universal}',
        );
      }

      // Try to get the native deep link for the wallet
      String? walletScheme = peerRedirect?.native;

      // If no redirect info, try common wallet schemes
      if (walletScheme == null || walletScheme.isEmpty) {
        // Default to MetaMask deep link scheme
        walletScheme = 'metamask://';
      }

      // Ensure the scheme ends with :// or /
      if (!walletScheme.endsWith('://') && !walletScheme.endsWith('/')) {
        if (walletScheme.contains('://')) {
          // Already has scheme, add path separator if needed
          if (!walletScheme.endsWith('/')) {
            walletScheme = '$walletScheme/';
          }
        } else {
          walletScheme = '$walletScheme://';
        }
      }

      if (kDebugMode) {
        print('Web3Service: Launching wallet with scheme: $walletScheme');
      }

      // Launch the wallet app using url_launcher
      final uri = Uri.parse('${walletScheme}wc');
      launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (kDebugMode) {
        print('Web3Service: Failed to launch wallet: $e');
      }
      // Don't throw - the request might still work even if launch fails
    }
  }

  /// Call a contract read function (eth_call)
  Future<String?> callContract({
    required String contractAddress,
    required String data,
  }) async {
    if (!isConnected || appKitModal == null) {
      throw Exception('Wallet not connected');
    }

    try {
      final session = appKitModal!.session;
      if (session == null) {
        throw Exception('No active session');
      }

      // Force Sepolia testnet chain ID
      const sepoliaChainId = 'eip155:11155111';

      final result = await appKitModal!.request(
        topic: session.topic ?? '',
        chainId: sepoliaChainId,
        request: SessionRequestParams(
          method: 'eth_call',
          params: [
            {'to': contractAddress, 'data': data},
            'latest',
          ],
        ),
      );

      return result?.toString();
    } catch (e) {
      if (kDebugMode) {
        print('Web3Service: Contract call failed: $e');
      }
      rethrow;
    }
  }
}
