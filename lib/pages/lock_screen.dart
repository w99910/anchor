import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/app_lock_service.dart';

/// Lock Screen Page
///
/// Displayed when the app is locked. Supports PIN and biometric authentication.
class LockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;

  const LockScreen({super.key, required this.onUnlocked});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> with WidgetsBindingObserver {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isLoading = false;
  bool _showError = false;
  String? _errorMessage;
  Timer? _lockoutTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Try biometric auth on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryBiometricAuth();
    });

    // Start lockout timer if needed
    _startLockoutTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pinController.dispose();
    _focusNode.dispose();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  void _startLockoutTimer() {
    if (appLockService.isLockedOut) {
      _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!appLockService.isLockedOut) {
          timer.cancel();
          setState(() {
            _errorMessage = null;
            _showError = false;
          });
        } else {
          setState(() {});
        }
      });
    }
  }

  Future<void> _tryBiometricAuth() async {
    if (!appLockService.isBiometricEnabled ||
        !appLockService.canUseBiometrics) {
      return;
    }

    if (appLockService.isLockedOut) {
      return;
    }

    final l10n = AppLocalizations.of(context);
    final success = await appLockService.authenticateWithBiometrics(
      reason: l10n?.unlockAnchor ?? 'Unlock Anchor',
    );

    if (success && mounted) {
      widget.onUnlocked();
    }
  }

  Future<void> _verifyPin() async {
    if (_pinController.text.length < 4) return;

    final l10n = AppLocalizations.of(context)!;

    if (appLockService.isLockedOut) {
      final remaining = appLockService.remainingLockoutTime;
      setState(() {
        _showError = true;
        _errorMessage = l10n.tooManyAttempts(remaining.inSeconds);
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showError = false;
    });

    final success = await appLockService.verifyPin(_pinController.text);

    if (!mounted) return;

    if (success) {
      widget.onUnlocked();
    } else {
      HapticFeedback.heavyImpact();

      if (appLockService.isLockedOut) {
        _startLockoutTimer();
        final remaining = appLockService.remainingLockoutTime;
        setState(() {
          _isLoading = false;
          _showError = true;
          _errorMessage = l10n.tooManyAttempts(remaining.inSeconds);
          _pinController.clear();
        });
      } else {
        final attemptsLeft =
            AppLockService.maxFailedAttempts - appLockService.failedAttempts;
        setState(() {
          _isLoading = false;
          _showError = true;
          _errorMessage = l10n.incorrectPinAttempts(attemptsLeft);
          _pinController.clear();
        });
      }
    }
  }

  void _onDigitPressed(String digit) {
    if (_pinController.text.length >= 4) return;
    if (appLockService.isLockedOut) return;

    HapticFeedback.lightImpact();
    _pinController.text += digit;

    if (_pinController.text.length == 4) {
      _verifyPin();
    }

    setState(() {
      _showError = false;
    });
  }

  void _onBackspacePressed() {
    if (_pinController.text.isEmpty) return;

    HapticFeedback.lightImpact();
    _pinController.text = _pinController.text.substring(
      0,
      _pinController.text.length - 1,
    );

    setState(() {
      _showError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // App icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.lock_rounded,
                  size: 48,
                  color: colorScheme.primary,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                l10n.enterYourPin,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                l10n.enterPinToUnlock,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),

              const SizedBox(height: 40),

              // PIN dots
              _PinDots(
                length: _pinController.text.length,
                maxLength: 4,
                hasError: _showError,
                isLoading: _isLoading,
              ),

              // Error message
              SizedBox(
                height: 40,
                child: _showError && _errorMessage != null
                    ? Center(
                        child: Text(
                          _errorMessage!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.error),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : null,
              ),

              const Spacer(),

              // Number pad
              _NumberPad(
                onDigitPressed: _onDigitPressed,
                onBackspacePressed: _onBackspacePressed,
                onBiometricPressed:
                    appLockService.isBiometricEnabled &&
                        appLockService.canUseBiometrics &&
                        !appLockService.isLockedOut
                    ? _tryBiometricAuth
                    : null,
                biometricType: appLockService.getBiometricTypeName(),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinDots extends StatelessWidget {
  final int length;
  final int maxLength;
  final bool hasError;
  final bool isLoading;

  const _PinDots({
    required this.length,
    required this.maxLength,
    required this.hasError,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(maxLength, (index) {
        final isFilled = index < length;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: isFilled ? 16 : 14,
          height: isFilled ? 16 : 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled
                ? (hasError ? colorScheme.error : colorScheme.primary)
                : null,
            border: Border.all(
              color: hasError
                  ? colorScheme.error
                  : (isFilled ? colorScheme.primary : colorScheme.outline),
              width: 2,
            ),
          ),
          child: isLoading && index == length - 1
              ? SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                )
              : null,
        );
      }),
    );
  }
}

class _NumberPad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback? onBiometricPressed;
  final String biometricType;

  const _NumberPad({
    required this.onDigitPressed,
    required this.onBackspacePressed,
    this.onBiometricPressed,
    required this.biometricType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberButton(digit: '1', onPressed: () => onDigitPressed('1')),
            _NumberButton(digit: '2', onPressed: () => onDigitPressed('2')),
            _NumberButton(digit: '3', onPressed: () => onDigitPressed('3')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberButton(digit: '4', onPressed: () => onDigitPressed('4')),
            _NumberButton(digit: '5', onPressed: () => onDigitPressed('5')),
            _NumberButton(digit: '6', onPressed: () => onDigitPressed('6')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberButton(digit: '7', onPressed: () => onDigitPressed('7')),
            _NumberButton(digit: '8', onPressed: () => onDigitPressed('8')),
            _NumberButton(digit: '9', onPressed: () => onDigitPressed('9')),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Biometric button
            _ActionButton(
              icon: biometricType.contains('Face')
                  ? Icons.face_rounded
                  : Icons.fingerprint_rounded,
              onPressed: onBiometricPressed,
            ),
            _NumberButton(digit: '0', onPressed: () => onDigitPressed('0')),
            // Backspace button
            _ActionButton(
              icon: Icons.backspace_outlined,
              onPressed: onBackspacePressed,
            ),
          ],
        ),
      ],
    );
  }
}

class _NumberButton extends StatelessWidget {
  final String digit;
  final VoidCallback onPressed;

  const _NumberButton({required this.digit, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(40),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(40),
          child: SizedBox(
            width: 72,
            height: 72,
            child: Center(
              child: Text(
                digit,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;

  const _ActionButton({required this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(40),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(40),
          child: SizedBox(
            width: 72,
            height: 72,
            child: Center(
              child: Icon(
                icon,
                size: 28,
                color: onPressed != null
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
