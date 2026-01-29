import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/onboarding/feature_intro_page.dart';
import 'pages/main_scaffold.dart';
import 'pages/help/payment_page.dart';
import 'services/appointment_service.dart';

// Keys for shared preferences
const String _keyOnboardingComplete = 'onboarding_complete';
const String _keyThemeMode = 'theme_mode';
const String _keyPendingPayment = 'pending_payment_data';

// Global theme notifier
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

// Global appointment service
final appointmentService = AppointmentService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Load saved theme
  await _loadTheme();

  // Initialize appointment service
  await appointmentService.initialize();

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

class AnchorApp extends StatelessWidget {
  const AnchorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, child) {
        return MaterialApp(
          title: 'Anchor',
          debugShowCheckedModeBanner: false,
          theme: _buildTheme(Brightness.light),
          darkTheme: _buildTheme(Brightness.dark),
          themeMode: themeMode,
          home: const SplashScreen(),
        );
      },
    );
  }

  static ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6B9B8C),
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF121212)
          : const Color(0xFFFAFAFA),
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
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
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
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        indicatorColor: colorScheme.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            );
          }
          return TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant);
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
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => onboardingComplete
                ? const MainScaffold()
                : const FeatureIntroPage(),
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
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(
                        Icons.anchor_rounded,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
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
