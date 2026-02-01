import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/app_lock_service.dart';
import '../utils/responsive.dart';

/// App Lock Setup Page
///
/// Allows users to set up, change, or disable the app lock PIN.
class AppLockSetupPage extends StatefulWidget {
  final bool isChangingPin;
  final bool isDisabling;

  const AppLockSetupPage({
    super.key,
    this.isChangingPin = false,
    this.isDisabling = false,
  });

  @override
  State<AppLockSetupPage> createState() => _AppLockSetupPageState();
}

class _AppLockSetupPageState extends State<AppLockSetupPage> {
  final _currentPinController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  int _step = 0; // 0: enter current (if changing), 1: new pin, 2: confirm
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (!widget.isChangingPin && !widget.isDisabling) {
      _step = 1; // Skip current PIN step for new setup
    }
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  String get _currentStepTitle {
    final l10n = AppLocalizations.of(context)!;
    if (widget.isDisabling) {
      return l10n.enterCurrentPin;
    }
    switch (_step) {
      case 0:
        return l10n.enterCurrentPin;
      case 1:
        return l10n.createNewPin;
      case 2:
        return l10n.confirmYourPin;
      default:
        return '';
    }
  }

  String get _currentStepSubtitle {
    final l10n = AppLocalizations.of(context)!;
    if (widget.isDisabling) {
      return l10n.enterPinToDisableLock;
    }
    switch (_step) {
      case 0:
        return l10n.enterCurrentPinToContinue;
      case 1:
        return l10n.choosePinDigits;
      case 2:
        return l10n.reenterPinToConfirm;
      default:
        return '';
    }
  }

  TextEditingController get _currentController {
    if (widget.isDisabling) return _currentPinController;
    switch (_step) {
      case 0:
        return _currentPinController;
      case 1:
        return _newPinController;
      case 2:
        return _confirmPinController;
      default:
        return _newPinController;
    }
  }

  void _onDigitPressed(String digit) {
    if (_currentController.text.length >= 4) return;

    HapticFeedback.lightImpact();
    _currentController.text += digit;
    setState(() => _error = null);

    if (_currentController.text.length == 4) {
      // Auto-submit when PIN is complete
      _onSubmit();
    }
  }

  void _onBackspacePressed() {
    if (_currentController.text.isEmpty) return;

    HapticFeedback.lightImpact();
    _currentController.text = _currentController.text.substring(
      0,
      _currentController.text.length - 1,
    );
    setState(() => _error = null);
  }

  Future<void> _onSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    final pin = _currentController.text;

    if (pin.length < 4) {
      setState(() => _error = l10n.pinMustBeDigits);
      return;
    }

    setState(() => _isLoading = true);

    // Handle disabling
    if (widget.isDisabling) {
      await appLockService.disableLock(pin);
      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.appLockDisabled)));
      }
      return;
    }

    // Handle steps
    switch (_step) {
      case 0: // Verify current PIN
        final isValid = await appLockService.verifyPin(pin);
        if (isValid) {
          setState(() {
            _step = 1;
            _isLoading = false;
          });
        } else {
          HapticFeedback.heavyImpact();
          setState(() {
            _error = l10n.incorrectPin;
            _isLoading = false;
            _currentPinController.clear();
          });
        }
        break;

      case 1: // Set new PIN
        setState(() {
          _step = 2;
          _isLoading = false;
        });
        break;

      case 2: // Confirm PIN
        if (_newPinController.text == _confirmPinController.text) {
          final success = await appLockService.setPin(_newPinController.text);
          if (success && mounted) {
            Navigator.pop(context, true);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.isChangingPin ? l10n.pinChanged : l10n.appLockEnabled,
                ),
              ),
            );
          } else {
            setState(() {
              _error = l10n.failedToSetPin;
              _isLoading = false;
            });
          }
        } else {
          HapticFeedback.heavyImpact();
          setState(() {
            _error = l10n.pinsDoNotMatch;
            _isLoading = false;
            _confirmPinController.clear();
          });
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isDisabling
              ? l10n.disableAppLock
              : (widget.isChangingPin ? l10n.changePin : l10n.setUpAppLock),
        ),
      ),
      body: SafeArea(
        child: ResponsiveCenter(
          maxWidth: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Step indicator (only for setup/change, not disable)
              if (!widget.isDisabling) ...[
                _StepIndicator(
                  currentStep: _step,
                  totalSteps: widget.isChangingPin ? 3 : 2,
                ),
                const SizedBox(height: 40),
              ],

              Text(
                _currentStepTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                _currentStepSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // PIN dots
              _PinDots(
                length: _currentController.text.length,
                maxLength: 4,
                hasError: _error != null,
                isLoading: _isLoading,
              ),

              // Error message
              SizedBox(
                height: 40,
                child: _error != null
                    ? Center(
                        child: Text(
                          _error!,
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
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({required this.currentStep, required this.totalSteps});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        final isActive = index <= currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: index == currentStep ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        );
      }),
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
        );
      }),
    );
  }
}

class _NumberPad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onBackspacePressed;

  const _NumberPad({
    required this.onDigitPressed,
    required this.onBackspacePressed,
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
            const SizedBox(width: 88),
            _NumberButton(digit: '0', onPressed: () => onDigitPressed('0')),
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
