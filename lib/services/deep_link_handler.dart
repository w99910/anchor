import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:reown_appkit/reown_appkit.dart';

/// Handles deep links from wallet apps (e.g., MetaMask) and dispatches them to Reown AppKit
class DeepLinkHandler {
  static const _eventChannel = EventChannel(
    'com.example.anchor/deeplink_events',
  );
  static ReownAppKitModal? _appKitModal;
  static bool _initialized = false;

  /// Initialize the deep link handler with the AppKit modal instance
  static void init(ReownAppKitModal appKitModal) {
    if (_initialized) {
      // Update the modal reference if already initialized
      _appKitModal = appKitModal;
      return;
    }

    if (kIsWeb) return;

    try {
      _appKitModal = appKitModal;
      _eventChannel.receiveBroadcastStream().listen(_onLink, onError: _onError);
      _initialized = true;
      if (kDebugMode) {
        print('DeepLinkHandler: Initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('DeepLinkHandler: Failed to initialize: $e');
      }
    }
  }

  static void _onLink(dynamic link) async {
    if (kDebugMode) {
      print('DeepLinkHandler: Received link: $link');
    }

    if (link == null || _appKitModal == null) return;

    try {
      final linkString = link.toString();

      // Check if this is a WalletConnect/Reown link
      if (linkString.contains('wc') ||
          linkString.contains('reown') ||
          linkString.startsWith('anchor://')) {
        if (kDebugMode) {
          print('DeepLinkHandler: Dispatching to AppKit: $linkString');
        }
        await _appKitModal!.dispatchEnvelope(linkString);
      }
    } catch (e) {
      if (kDebugMode) {
        print('DeepLinkHandler: Error dispatching link: $e');
      }
    }
  }

  static void _onError(dynamic error) {
    if (kDebugMode) {
      print('DeepLinkHandler: Stream error: $error');
    }
  }

  /// Update the modal reference (call this if modal is re-created)
  static void updateModal(ReownAppKitModal appKitModal) {
    _appKitModal = appKitModal;
  }
}
