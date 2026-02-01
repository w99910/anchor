import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import '../config/web3_config.dart';
import 'deep_link_handler.dart';

/// Web3 Service using Reown AppKit
///
/// Provides wallet connection and transaction capabilities with
/// a beautiful built-in wallet selection modal.
class Web3Service extends ChangeNotifier {
  static final Web3Service _instance = Web3Service._internal();
  factory Web3Service() => _instance;
  Web3Service._internal();

  // AppKit Modal instance
  ReownAppKitModal? _appKitModal;

  // State
  bool _initialized = false;
  String? _walletAddress;
  String? _chainId;
  double? _balance;

  // Getters
  bool get isInitialized => _initialized;
  bool get isConnected => _appKitModal?.isConnected ?? false;
  String? get walletAddress => _walletAddress;
  String? get chainId => _chainId;
  double? get balance => _balance;
  ReownAppKitModal? get appKitModal => _appKitModal;

  /// Initialize AppKit - call this once during app startup
  Future<void> initialize(BuildContext context) async {
    if (_initialized && _appKitModal != null) {
      _updateState();
      return;
    }

    try {
      // Create AppKit Modal instance
      _appKitModal = ReownAppKitModal(
        context: context,
        projectId: Web3Config.projectId,
        metadata: PairingMetadata(
          name: Web3Config.appName,
          description: Web3Config.appDescription,
          url: Web3Config.appUrl,
          icons: [Web3Config.appIcon],
          redirect: Redirect(
            native: '${Web3Config.deepLinkScheme}://',
            universal: 'https://${Web3Config.deepLinkHost}',
            linkMode: true,
          ),
        ),
        // Configure supported chains - only Sepolia in testnet mode for safety
        // Using requiredNamespaces to FORCE the specific chain
        requiredNamespaces: {
          'eip155': RequiredNamespace(
            chains: Web3Config.useTestnet
                ? [
                    'eip155:11155111', // Sepolia Testnet only
                  ]
                : [
                    'eip155:1', // Ethereum Mainnet
                  ],
            methods: [
              'eth_sendTransaction',
              'personal_sign',
              'eth_signTypedData',
              'eth_signTypedData_v4',
              'eth_sign',
            ],
            events: ['chainChanged', 'accountsChanged'],
          ),
        },
        // Featured wallets (shown first in the list)
        featuredWalletIds: {
          'c57ca95b47569778a828d19178114f4db188b89b763c899ba0be274e97267d96', // MetaMask
          '4622a2b2d6af1c9844944291e5e7351a6aa24cd7b23099efac1b2fd875da31a0', // Trust Wallet
          'fd20dc426fb37566d803205b19bbc1d4096b248ac04548e3cfb6b3a38bd033aa', // Coinbase
          'e7c4d26541a7fd84dbdfa9922d3ad21e936e13a7a0e44f94e95f7d6eb8ab35f1', // Rainbow
        },
      );

      if (kDebugMode) {
        print('Web3Service: Created ReownAppKitModal, initializing...');
      }

      // Initialize the modal with timeout
      await _appKitModal!.init().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (kDebugMode) {
            print('Web3Service: init() timed out after 30 seconds');
          }
          throw Exception('Wallet service initialization timed out');
        },
      );

      if (kDebugMode) {
        print('Web3Service: Modal init() completed');
      }

      // Set up event listeners
      _appKitModal!.onModalConnect.subscribe(_onModalConnect);
      _appKitModal!.onModalDisconnect.subscribe(_onModalDisconnect);
      _appKitModal!.onModalUpdate.subscribe(_onModalUpdate);

      // Initialize deep link handler for wallet redirects
      DeepLinkHandler.init(_appKitModal!);

      _initialized = true;
      _updateState();

      if (kDebugMode) {
        print('Web3Service: Initialized successfully');
        print('Web3Service: Connected = $isConnected');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Web3Service: Initialization error: $e');
      }
      rethrow;
    }
  }

  void _onModalConnect(ModalConnect? event) {
    if (kDebugMode) {
      print('Web3Service: Modal connected - ${event?.session.topic}');
    }
    _updateState();
  }

  void _onModalDisconnect(ModalDisconnect? event) {
    if (kDebugMode) {
      print('Web3Service: Modal disconnected');
    }
    _walletAddress = null;
    _chainId = null;
    _balance = null;
    notifyListeners();
  }

  void _onModalUpdate(ModalConnect? event) {
    if (kDebugMode) {
      print('Web3Service: Modal updated');
    }
    _updateState();
  }

  void _updateState() {
    if (_appKitModal == null) return;

    final session = _appKitModal!.session;
    if (session != null) {
      // Get address from session
      final address = _appKitModal!.session?.getAddress('eip155');
      _walletAddress = address;

      // Get current chain
      _chainId = _appKitModal!.selectedChain?.chainId;

      if (kDebugMode) {
        print('Web3Service: Address = $_walletAddress');
        print('Web3Service: Chain ID = $_chainId');
        print('Web3Service: Chain Name = ${_appKitModal!.selectedChain?.name}');
        print('Web3Service: Expected Chain ID = ${Web3Config.defaultChainId}');
      }
    } else {
      _walletAddress = null;
      _chainId = null;
    }

    notifyListeners();
  }

  /// Open the wallet connection modal
  Future<void> openModal() async {
    if (_appKitModal == null) {
      if (kDebugMode) {
        print('Web3Service: openModal() called but _appKitModal is null!');
      }
      throw Exception('Web3Service not initialized. Call initialize() first.');
    }

    if (kDebugMode) {
      print('Web3Service: Opening modal view...');
    }
    await _appKitModal!.openModalView();
    if (kDebugMode) {
      print('Web3Service: Modal view opened/closed');
    }
  }

  /// Connect wallet (opens modal if not connected)
  /// Returns the wallet address when connected, or null if user cancelled/timeout
  Future<String?> connectWallet() async {
    if (_appKitModal == null) {
      throw Exception('Web3Service not initialized. Call initialize() first.');
    }

    if (isConnected) {
      return _walletAddress;
    }

    // Create a completer to wait for connection
    final completer = Completer<String?>();

    // Set up a one-time listener for connection
    void onConnect(ModalConnect? event) {
      if (kDebugMode) {
        print('Web3Service: onConnect event received');
        print('Web3Service: event topic = ${event?.session.topic}');
      }
      if (!completer.isCompleted) {
        _updateState();
        if (kDebugMode) {
          print('Web3Service: Completing with address = $_walletAddress');
        }
        completer.complete(_walletAddress);
      }
    }

    void onDisconnect(ModalDisconnect? event) {
      if (kDebugMode) {
        print('Web3Service: onDisconnect event received');
      }
      if (!completer.isCompleted) {
        completer.complete(null);
      }
    }

    // Subscribe to events
    _appKitModal!.onModalConnect.subscribe(onConnect);
    _appKitModal!.onModalDisconnect.subscribe(onDisconnect);

    if (kDebugMode) {
      print('Web3Service: Opening modal for wallet connection...');
    }

    // Open the modal to let user select and connect a wallet
    await _appKitModal!.openModalView();

    if (kDebugMode) {
      print('Web3Service: Modal closed/returned');
      print('Web3Service: isConnected = $isConnected');
    }

    // Check if already connected after modal closed (direct connection)
    if (isConnected && !completer.isCompleted) {
      _appKitModal!.onModalConnect.unsubscribe(onConnect);
      _appKitModal!.onModalDisconnect.unsubscribe(onDisconnect);
      return _walletAddress;
    }

    // Wait for connection with timeout (90 seconds for user to complete connection in external wallet)
    try {
      final result = await completer.future.timeout(
        const Duration(seconds: 90),
        onTimeout: () {
          if (kDebugMode) {
            print('Web3Service: Connection timeout');
          }
          // Check one more time if connected
          _updateState();
          return _walletAddress;
        },
      );
      return result;
    } finally {
      // Clean up listeners
      _appKitModal!.onModalConnect.unsubscribe(onConnect);
      _appKitModal!.onModalDisconnect.unsubscribe(onDisconnect);
    }
  }

  /// Disconnect wallet
  Future<void> disconnect() async {
    if (_appKitModal == null) return;

    try {
      await _appKitModal!.disconnect();
      _walletAddress = null;
      _chainId = null;
      _balance = null;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Web3Service: Disconnect error: $e');
      }
      rethrow;
    }
  }

  /// Send ETH payment
  Future<String> sendPayment({
    required String recipientAddress,
    required double amountInUsd,
    double ethPrice = 2500.0, // You should fetch this from a price API
  }) async {
    if (_appKitModal == null || !isConnected || _walletAddress == null) {
      throw Exception('Wallet not connected');
    }

    // SAFETY CHECK: Prevent accidental mainnet transactions in test mode
    if (Web3Config.useTestnet) {
      final currentChainId = _appKitModal!.selectedChain?.chainId;
      final expectedChainId = Web3Config.defaultChainId.toString();

      // Check if the chain ID matches (handle both formats: "11155111" and "eip155:11155111")
      final isCorrectChain =
          currentChainId == expectedChainId ||
          currentChainId == 'eip155:$expectedChainId' ||
          currentChainId?.replaceFirst('eip155:', '') == expectedChainId;

      if (!isCorrectChain) {
        if (kDebugMode) {
          print(
            'Web3Service: Chain mismatch - current: $currentChainId, expected: $expectedChainId',
          );
          print('Web3Service: Attempting to switch to Sepolia...');
        }

        // Try to switch to Sepolia automatically
        final switched = await switchToSepolia();
        if (!switched) {
          throw Exception(
            'Please switch to Sepolia testnet. '
            'Tap "Change Network" below or disconnect and reconnect your wallet while on Sepolia.',
          );
        }
      }
    }

    try {
      // Calculate ETH amount
      final ethAmount = amountInUsd / ethPrice;
      final weiAmount = BigInt.from(ethAmount * 1e18);

      // Request transaction via AppKit
      final result = await _appKitModal!.request(
        topic: _appKitModal!.session!.topic,
        chainId: _appKitModal!.selectedChain!.chainId,
        request: SessionRequestParams(
          method: 'eth_sendTransaction',
          params: [
            {
              'from': _walletAddress!,
              'to': recipientAddress,
              'value': '0x${weiAmount.toRadixString(16)}',
              'data': '0x',
            },
          ],
        ),
      );

      if (kDebugMode) {
        print('Web3Service: Transaction hash: $result');
      }

      return result.toString();
    } catch (e) {
      if (kDebugMode) {
        print('Web3Service: Payment error: $e');
      }
      rethrow;
    }
  }

  /// Get ETH balance
  Future<double> getBalance() async {
    if (_appKitModal == null || !isConnected || _walletAddress == null) {
      return 0.0;
    }

    try {
      final balanceResult = await _appKitModal!.request(
        topic: _appKitModal!.session!.topic,
        chainId: _appKitModal!.selectedChain!.chainId,
        request: SessionRequestParams(
          method: 'eth_getBalance',
          params: [_walletAddress!, 'latest'],
        ),
      );

      // Parse hex balance to wei, then convert to ETH
      final weiBalance = BigInt.parse(balanceResult.toString());
      _balance = weiBalance.toDouble() / 1e18;
      notifyListeners();

      return _balance!;
    } catch (e) {
      if (kDebugMode) {
        print('Web3Service: Balance error: $e');
      }
      return 0.0;
    }
  }

  /// Sign a message
  Future<String> signMessage(String message) async {
    if (_appKitModal == null || !isConnected || _walletAddress == null) {
      throw Exception('Wallet not connected');
    }

    try {
      final result = await _appKitModal!.request(
        topic: _appKitModal!.session!.topic,
        chainId: _appKitModal!.selectedChain!.chainId,
        request: SessionRequestParams(
          method: 'personal_sign',
          params: [message, _walletAddress!],
        ),
      );

      return result.toString();
    } catch (e) {
      if (kDebugMode) {
        print('Web3Service: Sign error: $e');
      }
      rethrow;
    }
  }

  /// Switch to a different chain
  /// Use the AppKit modal to switch chains - it handles the UI
  Future<void> switchChain() async {
    if (_appKitModal == null) return;

    try {
      // Open the network selection view in the modal
      await _appKitModal!.openModalView(ReownAppKitModalSelectNetworkPage());
      _updateState();
    } catch (e) {
      if (kDebugMode) {
        print('Web3Service: Switch chain error: $e');
      }
      rethrow;
    }
  }

  /// Switch to Sepolia testnet programmatically
  Future<bool> switchToSepolia() async {
    if (_appKitModal == null || !isConnected) return false;

    // Check if already on Sepolia - no need to switch
    final currentChainId = _appKitModal!.selectedChain?.chainId;
    final alreadyOnSepolia =
        currentChainId == '11155111' || currentChainId == 'eip155:11155111';

    if (kDebugMode) {
      print(
        'Web3Service: switchToSepolia called, current chain: $currentChainId',
      );
      print('Web3Service: Already on Sepolia: $alreadyOnSepolia');
    }

    if (alreadyOnSepolia) {
      if (kDebugMode) {
        print('Web3Service: Already on Sepolia, no switch needed');
      }
      return true;
    }

    try {
      const sepoliaChainId = '0xaa36a7'; // 11155111 in hex

      if (kDebugMode) {
        print('Web3Service: Requesting wallet to switch to Sepolia...');
      }

      // Request wallet to switch to Sepolia with timeout
      await _appKitModal!
          .request(
            topic: _appKitModal!.session!.topic,
            chainId: _appKitModal!.selectedChain!.chainId,
            request: SessionRequestParams(
              method: 'wallet_switchEthereumChain',
              params: [
                {'chainId': sepoliaChainId},
              ],
            ),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              if (kDebugMode) {
                print(
                  'Web3Service: Switch request timed out, checking current chain...',
                );
              }
              return null;
            },
          );

      // Wait for the chain switch to take effect
      await Future.delayed(const Duration(milliseconds: 500));
      _updateState();

      // Verify the switch was successful
      final newChainId = _appKitModal!.selectedChain?.chainId;
      final isCorrectChain =
          newChainId == '11155111' || newChainId == 'eip155:11155111';

      if (kDebugMode) {
        print('Web3Service: After switch, chain is: $newChainId');
        print('Web3Service: Switch successful: $isCorrectChain');
      }

      return isCorrectChain;
    } catch (e) {
      if (kDebugMode) {
        print('Web3Service: Switch to Sepolia error: $e');
      }

      // If switch failed (maybe Sepolia not added), try to add it
      try {
        await _addSepoliaNetwork();
        return await switchToSepolia();
      } catch (addError) {
        if (kDebugMode) {
          print('Web3Service: Add Sepolia network error: $addError');
        }
        return false;
      }
    }
  }

  /// Add Sepolia network to wallet
  Future<void> _addSepoliaNetwork() async {
    if (_appKitModal == null || !isConnected) return;

    await _appKitModal!.request(
      topic: _appKitModal!.session!.topic,
      chainId: _appKitModal!.selectedChain!.chainId,
      request: SessionRequestParams(
        method: 'wallet_addEthereumChain',
        params: [
          {
            'chainId': '0xaa36a7', // 11155111 in hex
            'chainName': 'Sepolia Testnet',
            'nativeCurrency': {
              'name': 'Sepolia ETH',
              'symbol': 'ETH',
              'decimals': 18,
            },
            'rpcUrls': ['https://ethereum-sepolia.publicnode.com'],
            'blockExplorerUrls': ['https://sepolia.etherscan.io'],
          },
        ],
      ),
    );
  }

  @override
  void dispose() {
    _appKitModal?.onModalConnect.unsubscribe(_onModalConnect);
    _appKitModal?.onModalDisconnect.unsubscribe(_onModalDisconnect);
    _appKitModal?.onModalUpdate.unsubscribe(_onModalUpdate);
    super.dispose();
  }
}
