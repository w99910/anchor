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
/// Replace the values below with your actual credentials

class Web3Config {
  // Reown Project ID (required)
  // Get from: https://cloud.reown.com/
  static const String projectId = String.fromEnvironment(
    'REOWN_PROJECT_ID',
    defaultValue: 'YOUR_PROJECT_ID_HERE',
  );

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
  static const String recipientWalletAddress =
      '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb';

  // Alchemy RPC URLs (optional - for better performance)
  // Get from: https://www.alchemy.com/
  static const String alchemyApiKey = String.fromEnvironment(
    'ALCHEMY_API_KEY',
    defaultValue: '',
  );

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
  static const String defaultChainName = useTestnet
      ? 'Sepolia Testnet'
      : 'Ethereum Mainnet';
}
