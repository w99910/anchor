import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';
import '../config/ethstorage_config.dart';

/// Result of an EthStorage upload operation
class EthStorageUploadResult {
  final String txHash;
  final String key;
  final String explorerUrl;

  EthStorageUploadResult({
    required this.txHash,
    required this.key,
    required this.explorerUrl,
  });
}

/// Journal summary data structure for EthStorage
class JournalSummaryData {
  final int entryId;
  final String summary;
  final String emotionStatus;
  final List<String> actionItems;
  final String riskStatus;
  final DateTime timestamp;
  final String? walletAddress; // User's wallet for verification

  JournalSummaryData({
    required this.entryId,
    required this.summary,
    required this.emotionStatus,
    required this.actionItems,
    required this.riskStatus,
    DateTime? timestamp,
    this.walletAddress,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'entryId': entryId,
    'summary': summary,
    'emotionStatus': emotionStatus,
    'actionItems': actionItems,
    'riskStatus': riskStatus,
    'timestamp': timestamp.toIso8601String(),
    'walletAddress': walletAddress,
    'version': '1.0',
  };

  String toJsonString() => jsonEncode(toJson());

  /// Generate a unique key for this journal entry
  String get storageKey =>
      'anchor/journal/${walletAddress ?? 'anonymous'}/$entryId';
}

/// Service for storing journal data on EthStorage testnet
///
/// EthStorage is a decentralized storage layer that stores data as blobs
/// on Ethereum. This service provides a way to permanently store journal
/// summaries on-chain.
class EthStorageService extends ChangeNotifier {
  static final EthStorageService _instance = EthStorageService._internal();
  factory EthStorageService() => _instance;
  EthStorageService._internal();

  // Web3 client
  Web3Client? _web3Client;
  EthPrivateKey? _credentials;

  bool _isUploading = false;
  String? _lastError;
  String? _walletAddress;

  bool get isUploading => _isUploading;
  String? get lastError => _lastError;
  String? get walletAddress => _walletAddress;
  bool get isConfigured => EthStorageConfig.isConfigured;

  /// Initialize the Web3 client
  Future<void> _initializeWeb3() async {
    if (_web3Client != null) return;

    _web3Client = Web3Client(EthStorageConfig.rpcUrl, http.Client());

    final privateKey = EthStorageConfig.privateKey;
    _credentials = EthPrivateKey.fromHex(privateKey);
    _walletAddress = _credentials!.address.hexEip55;
  }

  /// Check if EthStorage is properly configured
  Future<bool> checkConfiguration() async {
    if (!EthStorageConfig.isConfigured) {
      _lastError =
          'EthStorage private key not configured. '
          'Add ETHSTORAGE_PRIVATE_KEY to your .env file.';
      return false;
    }

    try {
      await _initializeWeb3();
      return true;
    } catch (e) {
      _lastError = 'Failed to initialize wallet: $e';
      return false;
    }
  }

  /// Get wallet balance
  Future<double> getBalance() async {
    await _initializeWeb3();
    final balance = await _web3Client!.getBalance(_credentials!.address);
    return balance.getValueInUnit(EtherUnit.ether);
  }

  /// Upload journal summary to EthStorage testnet
  ///
  /// Returns the transaction hash and explorer URL on success
  Future<EthStorageUploadResult> uploadJournalSummary(
    JournalSummaryData data,
  ) async {
    if (!isConfigured) {
      throw Exception(
        'EthStorage not configured. Add ETHSTORAGE_PRIVATE_KEY to .env file.',
      );
    }

    _isUploading = true;
    _lastError = null;
    notifyListeners();

    try {
      // Convert summary data to JSON bytes
      final jsonData = data.toJsonString();
      final dataBytes = utf8.encode(jsonData);

      if (kDebugMode) {
        print('EthStorage: Uploading ${dataBytes.length} bytes');
        print('EthStorage: Key = ${data.storageKey}');
      }

      // Upload to EthStorage using JSON-RPC
      final txHash = await _uploadToEthStorage(
        key: data.storageKey,
        data: Uint8List.fromList(dataBytes),
      );

      final result = EthStorageUploadResult(
        txHash: txHash,
        key: data.storageKey,
        explorerUrl: EthStorageConfig.getExplorerTxUrl(txHash),
      );

      if (kDebugMode) {
        print('EthStorage: Upload successful!');
        print('EthStorage: TX Hash = $txHash');
        print('EthStorage: Explorer = ${result.explorerUrl}');
      }

      _isUploading = false;
      notifyListeners();

      return result;
    } catch (e) {
      _lastError = e.toString();
      _isUploading = false;
      notifyListeners();

      if (kDebugMode) {
        print('EthStorage: Upload failed - $e');
      }

      rethrow;
    }
  }

  /// Upload data to EthStorage using web3dart
  Future<String> _uploadToEthStorage({
    required String key,
    required Uint8List data,
  }) async {
    await _initializeWeb3();

    // Build the transaction data
    final txData = _buildStorageTransaction(key, data);

    // Create and send transaction using web3dart
    final transaction = Transaction(
      to: EthereumAddress.fromHex(EthStorageConfig.ethStorageContractAddress),
      data: txData,
      maxGas: 500000, // Gas limit for storage operations
    );

    final txHash = await _web3Client!.sendTransaction(
      _credentials!,
      transaction,
      chainId: EthStorageConfig.chainId,
    );

    return txHash;
  }

  /// Build the calldata for storage transaction
  Uint8List _buildStorageTransaction(String key, Uint8List data) {
    // EthStorage uses a simple key-value storage interface
    // The contract function is: write(bytes32 key, bytes data)
    // Function selector for write(bytes32,bytes) = 0x0d6d62f8

    // Convert key to bytes32 (keccak256 hash of the key string)
    final keyBytes = _stringToBytes32(key);

    // Encode the function call using ABI encoding
    // selector (4 bytes) + key (32 bytes) + offset (32 bytes) + length (32 bytes) + data + padding
    final selector = [0x0d, 0x6d, 0x62, 0xf8]; // write(bytes32,bytes)

    final encoded = <int>[];
    encoded.addAll(selector);
    encoded.addAll(keyBytes); // bytes32 key
    encoded.addAll(
      _encodeUint256(64),
    ); // offset to data (after key + offset fields)
    encoded.addAll(_encodeUint256(data.length)); // data length
    encoded.addAll(data); // actual data

    // Pad to 32-byte boundary
    while (encoded.length % 32 != 0) {
      encoded.add(0);
    }

    return Uint8List.fromList(encoded);
  }

  /// Convert string to bytes32 (using keccak256 hash)
  List<int> _stringToBytes32(String str) {
    // Use keccak256 hash for consistent key derivation
    final bytes = utf8.encode(str);
    final hash = keccak256(Uint8List.fromList(bytes));
    return hash.toList();
  }

  /// Encode uint256
  List<int> _encodeUint256(int value) {
    final result = List<int>.filled(32, 0);
    var remaining = value;
    for (var i = 31; i >= 0 && remaining > 0; i--) {
      result[i] = remaining & 0xff;
      remaining >>= 8;
    }
    return result;
  }

  /// Read journal summary from EthStorage
  /// Note: This is a simplified implementation. In production, use the EthStorage SDK.
  Future<JournalSummaryData?> readJournalSummary({
    required String walletAddress,
    required int entryId,
  }) async {
    await _initializeWeb3();
    final key = 'anchor/journal/$walletAddress/$entryId';

    try {
      // Build the read transaction calldata
      final callData = _buildReadTransaction(key);

      // Make a raw eth_call to read from the contract
      final result = await _web3Client!.callRaw(
        contract: EthereumAddress.fromHex(
          EthStorageConfig.ethStorageContractAddress,
        ),
        data: callData,
      );

      if (result.isEmpty || result == '0x') {
        return null;
      }

      // Parse hex result to bytes
      final hexData = result.startsWith('0x') ? result.substring(2) : result;
      final resultBytes = <int>[];
      for (var i = 0; i < hexData.length; i += 2) {
        resultBytes.add(int.parse(hexData.substring(i, i + 2), radix: 16));
      }

      // Decode the response - skip the first 64 bytes (offset and length)
      // and parse the actual data
      if (resultBytes.length <= 64) return null;
      final dataBytes = resultBytes.sublist(64);
      final jsonString = utf8.decode(dataBytes.where((b) => b != 0).toList());
      final json = jsonDecode(jsonString);

      return JournalSummaryData(
        entryId: json['entryId'],
        summary: json['summary'],
        emotionStatus: json['emotionStatus'],
        actionItems: List<String>.from(json['actionItems']),
        riskStatus: json['riskStatus'],
        timestamp: DateTime.parse(json['timestamp']),
        walletAddress: json['walletAddress'],
      );
    } catch (e) {
      if (kDebugMode) {
        print('EthStorage: Failed to read - $e');
      }
      return null;
    }
  }

  /// Build read transaction calldata
  Uint8List _buildReadTransaction(String key) {
    // Function selector for read(bytes32)
    final selector = [0x84, 0xd5, 0x55, 0x45]; // read(bytes32)
    final keyBytes = _stringToBytes32(key);

    return Uint8List.fromList([...selector, ...keyBytes]);
  }

  /// Dispose resources
  @override
  void dispose() {
    _web3Client?.dispose();
    super.dispose();
  }
}
