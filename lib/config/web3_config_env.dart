/// Environment-based Web3 Configuration (Optional - for production)
///
/// To use environment variables instead of hardcoded values:
///
/// 1. Install flutter_dotenv:
///    Add to pubspec.yaml: flutter_dotenv: ^5.1.0
///
/// 2. Create a .env file in project root:
///    RPC_URL=https://mainnet.infura.io/v3/YOUR_API_KEY
///    WALLETCONNECT_PROJECT_ID=YOUR_PROJECT_ID
///    RECIPIENT_WALLET=0xYOUR_WALLET_ADDRESS
///
/// 3. Add .env to .gitignore
///
/// 4. Load in main.dart:
///    import 'package:flutter_dotenv/flutter_dotenv.dart';
///    await dotenv.load(fileName: ".env");
///
/// 5. Use this class instead of web3_config.dart

// Uncomment when using flutter_dotenv:
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class Web3ConfigEnv {
  // Using environment variables (recommended for production)
  // static String get rpcUrl => dotenv.env['RPC_URL'] ?? '';
  // static String get walletConnectProjectId => dotenv.env['WALLETCONNECT_PROJECT_ID'] ?? '';
  // static String get recipientWalletAddress => dotenv.env['RECIPIENT_WALLET'] ?? '';

  // Hardcoded fallbacks (for development only)
  static const String rpcUrl = 'YOUR_RPC_URL_HERE';
  static const String walletConnectProjectId = 'YOUR_PROJECT_ID_HERE';
  static const String recipientWalletAddress =
      '0x742d35Cc6634C0532925a3b844Bc9e7595f0bEb';

  static const int chainId = 1;
  static const String chainName = 'Ethereum Mainnet';
}
