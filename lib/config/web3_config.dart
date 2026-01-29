import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Web3 Configuration for Reown AppKit
///
/// IMPORTANT: Before using the Web3 features, you need to:
/// 1. Get a Project ID from Reown Cloud (https://cloud.reown.com/)
///    - Sign up for free
///    - Create a new project
///    - Copy your Project ID
///
/// 2. (Optional) Get an RPC URL from Alchemy (https://www.alchemy.com/)
///    for better performance and reliability
///
/// Configure these values in your .env file

class Web3Config {
  // Reown Project ID (required)
  // Get from: https://cloud.reown.com/
  static String get projectId =>
      dotenv.env['REOWN_PROJECT_ID'] ?? 'YOUR_PROJECT_ID_HERE';

  // App metadata
  static const String appName = 'Anchor';
  static const String appDescription = 'Mental health support platform';
  static const String appUrl = 'https://anchor.app';
  static const String appIcon = 'https://anchor.app/icon.png';

  // Deep link scheme for your app (used for wallet redirects)
  static const String deepLinkScheme = 'anchor';
  static const String deepLinkHost = 'anchor.app';

  // Recipient wallet address for payments (therapist/platform wallet)
  // This is where crypto payments will be sent
  // Configure in .env file: RECIPIENT_WALLET=0x...
  static String get recipientWalletAddress =>
      dotenv.env['RECIPIENT_WALLET'] ??
      '0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045'; // Default test address

  // Alchemy RPC URLs (optional - for better performance)
  // Get from: https://www.alchemy.com/
  static String get alchemyApiKey => dotenv.env['ALCHEMY_API_KEY'] ?? '';

  // Chain configurations
  static String get ethereumMainnetRpc => alchemyApiKey.isNotEmpty
      ? 'https://eth-mainnet.g.alchemy.com/v2/$alchemyApiKey'
      : 'https://ethereum.publicnode.com';

  static String get sepoliaTestnetRpc => alchemyApiKey.isNotEmpty
      ? 'https://eth-sepolia.g.alchemy.com/v2/$alchemyApiKey'
      : 'https://ethereum-sepolia.publicnode.com';

  // Default to Sepolia testnet for development (safer for testing)
  // Change to mainnet (chainId: 1) for production
  static const bool useTestnet = true;
  static const int defaultChainId = useTestnet ? 11155111 : 1;
  static const String defaultChainName =
      useTestnet ? 'Sepolia Testnet' : 'Ethereum Mainnet';
}
