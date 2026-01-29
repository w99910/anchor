import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reown_appkit/reown_appkit.dart';
import '../config/web3_config.dart';

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
        optionalNamespaces: {
          'eip155': RequiredNamespace(
            chains: Web3Config.useTestnet
                ? [
                    'eip155:11155111', // Sepolia Testnet only
                  ]
                : [
                    'eip155:1', // Ethereum Mainnet
                    'eip155:137', // Polygon
                    'eip155:42161', // Arbitrum
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

      // Initialize the modal
      await _appKitModal!.init();

      // Set up event listeners
      _appKitModal!.onModalConnect.subscribe(_onModalConnect);
      _appKitModal!.onModalDisconnect.subscribe(_onModalDisconnect);
      _appKitModal!.onModalUpdate.subscribe(_onModalUpdate);

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
        print('Web3Service: Chain = $_chainId');
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
      throw Exception('Web3Service not initialized. Call initialize() first.');
    }

    await _appKitModal!.openModalView();
  }

  /// Connect wallet (opens modal if not connected)
  Future<String?> connectWallet() async {
    if (_appKitModal == null) {
      throw Exception('Web3Service not initialized. Call initialize() first.');
    }

    if (isConnected) {
      return _walletAddress;
    }

    // Open the modal to let user select and connect a wallet
    await _appKitModal!.openModalView();

    // Wait a bit for connection to complete
    await Future.delayed(const Duration(milliseconds: 500));

    return _walletAddress;
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
      if (currentChainId != 'eip155:${Web3Config.defaultChainId}') {
        throw Exception(
          'Please switch to Sepolia testnet in your wallet. '
          'Currently connected to: ${_appKitModal!.selectedChain?.name ?? "Unknown"}. '
          'Go to MetaMask Settings → Networks → Add Sepolia, then reconnect.',
        );
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

  @override
  void dispose() {
    _appKitModal?.onModalConnect.unsubscribe(_onModalConnect);
    _appKitModal?.onModalDisconnect.unsubscribe(_onModalDisconnect);
    _appKitModal?.onModalUpdate.unsubscribe(_onModalUpdate);
    super.dispose();
  }
}
