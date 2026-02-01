import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/generated/app_localizations.dart';
import 'pages/onboarding/language_selection_page.dart';
import 'pages/onboarding/feature_intro_page.dart';
import 'pages/main_scaffold.dart';
import 'pages/help/payment_page.dart';
import 'pages/lock_screen.dart';
import 'services/ai_settings_service.dart';
import 'services/app_lock_service.dart';
import 'services/appointment_service.dart';
import 'services/locale_service.dart';
import 'services/user_info_service.dart';

// Keys for shared preferences
const String _keyOnboardingComplete = 'onboarding_complete';
const String _keyThemeMode = 'theme_mode';
const String _keyPendingPayment = 'pending_payment_data';

// Global theme notifier
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

// Global appointment service
final appointmentService = AppointmentService();

// Global AI settings service
final aiSettingsService = AiSettingsService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Load environment variables (with fallback for release builds where .env may not exist)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // .env file not found or failed to load - this is expected in release builds
    // if .env is in .gitignore. The app will use default/empty values.
    debugPrint('Warning: Could not load .env file: $e');
  }

  // Load saved theme
  await _loadTheme();

  // Initialize locale service
  await localeService.initialize();
  localeNotifier.value = localeService.locale;

  // Initialize AI settings
  await aiSettingsService.initialize();

  // Initialize appointment service
  await appointmentService.initialize();

  // Initialize app lock service
  await appLockService.initialize();

  // Initialize user info service
  await UserInfoService().load();

  runApp(const AnchorApp());
}

Future<void> _loadTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final themeModeIndex = prefs.getInt(_keyThemeMode) ?? 0;
  themeNotifier.value = ThemeMode.values[themeModeIndex];
}

Future<void> saveTheme(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt(_keyThemeMode, mode.index);
  themeNotifier.value = mode;
}

Future<bool> isOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_keyOnboardingComplete) ?? false;
}

Future<void> setOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_keyOnboardingComplete, true);
}

/// Pending payment data class
class PendingPaymentData {
  final int amount;
  final String therapistName;
  final DateTime date;
  final String time;

  PendingPaymentData({
    required this.amount,
    required this.therapistName,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'amount': amount,
    'therapistName': therapistName,
    'date': date.toIso8601String(),
    'time': time,
  };

  factory PendingPaymentData.fromJson(Map<String, dynamic> json) =>
      PendingPaymentData(
        amount: json['amount'] as int,
        therapistName: json['therapistName'] as String,
        date: DateTime.parse(json['date'] as String),
        time: json['time'] as String,
      );
}

// Pending payment state management (for wallet redirect recovery)
Future<void> savePendingPayment({
  required int amount,
  required String therapistName,
  required DateTime date,
  required String time,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final data = PendingPaymentData(
    amount: amount,
    therapistName: therapistName,
    date: date,
    time: time,
  );
  await prefs.setString(_keyPendingPayment, jsonEncode(data.toJson()));
}

Future<PendingPaymentData?> getPendingPayment() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString(_keyPendingPayment);
  if (jsonString != null) {
    try {
      return PendingPaymentData.fromJson(jsonDecode(jsonString));
    } catch (e) {
      return null;
    }
  }
  return null;
}

Future<void> clearPendingPayment() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_keyPendingPayment);
}

class AnchorApp extends StatefulWidget {
  const AnchorApp({super.key});

  @override
  State<AnchorApp> createState() => _AnchorAppState();
}

class _AnchorAppState extends State<AnchorApp> with WidgetsBindingObserver {
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isLocked = appLockService.isLockEnabled && appLockService.isLocked;
    appLockService.addListener(_onLockStateChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    appLockService.removeListener(_onLockStateChanged);
    super.dispose();
  }

  void _onLockStateChanged() {
    setState(() {
      _isLocked = appLockService.isLockEnabled && appLockService.isLocked;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Lock the app when it goes to background (if enabled)
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {
      if (appLockService.isLockEnabled && appLockService.lockOnBackground) {
        appLockService.lock();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return ValueListenableBuilder<Locale>(
          valueListenable: localeNotifier,
          builder: (context, locale, child) {
            return MaterialApp(
              title: 'Anchor',
              debugShowCheckedModeBanner: false,
              theme: _buildTheme(Brightness.light),
              darkTheme: _buildTheme(Brightness.dark),
              themeMode: themeMode,
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: LocaleService.supportedLocales,
              home: _isLocked
                  ? LockScreen(onUnlocked: () => appLockService.unlock())
                  : const SplashScreen(),
            );
          },
        );
      },
    );
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    // Primary: #56E016 (Bright Green), Secondary: #FFEB3B (Bright Yellow)
    // Use a darker shade for light mode to improve visibility
    final primaryColor = isDark
        ? const Color.fromARGB(255, 151, 235, 113)
        : const Color.fromARGB(255, 77, 206, 17); // Darker green for light mode
    const secondaryColor = Color(0xFFFFEB3B);

    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      secondary: secondaryColor,
      brightness: brightness,
      // Font colors for light mode: gray-900 (headings), gray-700 (nav), gray-600 (body)
      onSurface: isDark
          ? const Color(0xFFE5E5E5)
          : const Color(0xFF111827), // gray-900
      onSurfaceVariant: isDark
          ? const Color(0xFF9CA3AF)
          : const Color(0xFF4B5563), // gray-600
      // Dark greenish-gray for elevated surfaces in dark mode
      surfaceContainerHighest: isDark
          ? const Color.fromARGB(255, 22, 29, 37) // Dark greenish-gray
          : null,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      // Background gradient colors: indigo-50, purple-50, pink-50 (for light)
      // Dark mode: gray-900 background
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF111827) // gray-900 for dark mode
          : const Color(0xFFEEF2FF), // indigo-50 base for light mode
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        // Features section: white main, gray-50 for cards
        // Privacy section (dark): gray-900 background with gray-800 cards
        color: isDark
            ? const Color(0xFF1F2937)
            : const Color(0xFFF9FAFB), // gray-800 dark, gray-50 light
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Privacy section dark mode uses gray-800 for inputs
        fillColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          backgroundColor: isDark
              ? const Color.fromARGB(255, 151, 235, 113)
              : null,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: isDark
              ? const Color.fromARGB(255, 151, 235, 113)
              : null,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 70,
        // Privacy section: gray-900 dark, white light
        backgroundColor: isDark ? const Color(0xFF111827) : Colors.white,
        // Remove the box behind icons
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        // Fill active icons with primary color
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: primaryColor, size: 24);
          }
          return IconThemeData(
            color: isDark
                ? const Color(0xFF9CA3AF) // gray-400 for dark
                : const Color(0xFF6B7280), // gray-500 for light
            size: 24,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            );
          }
          // Navigation font color: gray-700 for light mode
          return TextStyle(
            fontSize: 11,
            color: isDark
                ? const Color(0xFF9CA3AF) // gray-400 for dark
                : const Color(0xFF374151), // gray-700 for light
          );
        }),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
    _navigate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    final onboardingComplete = await isOnboardingComplete();
    final pendingPayment = await getPendingPayment();
    final hasCompletedPayment = appointmentService.hasCompletedPaymentToShow;
    final hasLocalePreference = await localeService.hasLocalePreference();

    // Wait for animation
    await Future.delayed(const Duration(milliseconds: 2000));

    if (mounted) {
      // Priority 1: Check if there's a completed payment to show success screen
      if (hasCompletedPayment && onboardingComplete) {
        final appointment = appointmentService.lastCompletedPayment!;
        // Clear pending payment since payment is complete
        await clearPendingPayment();

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainScaffold(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
        // Push success page on top after a short delay
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentSuccessPage(
                therapistName: appointment.therapistName,
                paymentMethod: appointment.paymentMethod,
                transactionHash: appointment.transactionHash,
                date: appointment.date,
                time: appointment.time,
              ),
            ),
          );
        }
      }
      // Priority 2: Check if there's a pending payment (wallet connection in progress)
      else if (pendingPayment != null && onboardingComplete) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const MainScaffold(),
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
        // Push payment page on top after a short delay
        await Future.delayed(const Duration(milliseconds: 100));
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentPage(
                amount: pendingPayment.amount,
                therapistName: pendingPayment.therapistName,
                date: pendingPayment.date,
                time: pendingPayment.time,
              ),
            ),
          );
        }
      }
      // Priority 3: Normal navigation
      else {
        Widget destination;
        if (onboardingComplete) {
          destination = const MainScaffold();
        } else if (!hasLocalePreference) {
          // New user - show language selection first
          destination = const LanguageSelectionPage();
        } else {
          // Has locale but hasn't completed onboarding - continue onboarding
          destination = const FeatureIntroPage();
        }

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => destination,
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/app_icon.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Anchor',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your mental wellness companion',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
