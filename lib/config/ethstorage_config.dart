import 'package:flutter_dotenv/flutter_dotenv.dart';

/// EthStorage Configuration for storing journal data on-chain
///
/// IMPORTANT: Before using EthStorage features, you need to:
///
/// 1. Set up your wallet private key in .env file:
///    ETHSTORAGE_PRIVATE_KEY=0xabcd...your_private_key...
///
///    SECURITY WARNING: Never commit your private key to version control!
///    Use a dedicated wallet for testing, not your main wallet.
///
/// 2. Get Sepolia testnet ETH from a faucet:
///    - https://sepoliafaucet.com/
///    - https://www.alchemy.com/faucets/ethereum-sepolia
///
/// 3. (Optional) Deploy your own FlatDirectory contract or use the default
///
/// For more info, see: https://docs.ethstorage.io/

class EthStorageConfig {
  // Private key for signing transactions
  // NEVER hardcode this - always use .env file
  static String get privateKey => dotenv.env['ETHSTORAGE_PRIVATE_KEY'] ?? '';

  // Check if EthStorage is properly configured
  static bool get isConfigured =>
      privateKey.isNotEmpty && privateKey.startsWith('0x');

  // EthStorage Testnet RPC endpoints (Sepolia + EthStorage)
  // The EthStorage testnet runs on top of Sepolia L1
  // Using PublicNode which is more reliable than rpc.sepolia.org
  static const String rpcUrl = 'https://ethereum-sepolia-rpc.publicnode.com';
  static const String ethStorageRpcUrl =
      'https://rpc.testnet.ethstorage.io:9546';

  // Chain ID for Sepolia
  static const int chainId = 11155111;

  // Optional: Pre-deployed FlatDirectory contract address
  // If not set, the service will deploy a new one (costs more gas)
  static String? get flatDirectoryAddress =>
      dotenv.env['ETHSTORAGE_FLAT_DIRECTORY'];

  // EthStorage contract address on Sepolia (from ethstorage-sdk ETHSTORAGE_MAPPING)
  static const String ethStorageContractAddress =
      '0xAb3d380A268d088BA21Eb313c1C23F3BEC5cfe93';

  // Explorer URL for viewing transactions
  static const String explorerUrl = 'https://sepolia.etherscan.io';

  /// Get explorer link for a transaction hash
  static String getExplorerTxUrl(String txHash) => '$explorerUrl/tx/$txHash';

  /// Get explorer link for a wallet address
  static String getExplorerAddressUrl(String address) =>
      '$explorerUrl/address/$address';
}
