import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Appointment model
class Appointment {
  final String id;
  final String therapistName;
  final DateTime date;
  final String time;
  final int amount;
  final String paymentMethod;
  final String? transactionHash;
  final DateTime createdAt;
  final String status; // 'upcoming', 'completed', 'cancelled'

  Appointment({
    required this.id,
    required this.therapistName,
    required this.date,
    required this.time,
    required this.amount,
    required this.paymentMethod,
    this.transactionHash,
    required this.createdAt,
    this.status = 'upcoming',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'therapistName': therapistName,
        'date': date.toIso8601String(),
        'time': time,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'transactionHash': transactionHash,
        'createdAt': createdAt.toIso8601String(),
        'status': status,
      };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json['id'] as String,
        therapistName: json['therapistName'] as String,
        date: DateTime.parse(json['date'] as String),
        time: json['time'] as String,
        amount: json['amount'] as int,
        paymentMethod: json['paymentMethod'] as String,
        transactionHash: json['transactionHash'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        status: json['status'] as String? ?? 'upcoming',
      );

  Appointment copyWith({String? status}) => Appointment(
        id: id,
        therapistName: therapistName,
        date: date,
        time: time,
        amount: amount,
        paymentMethod: paymentMethod,
        transactionHash: transactionHash,
        createdAt: createdAt,
        status: status ?? this.status,
      );
}

/// Service for managing appointments
class AppointmentService extends ChangeNotifier {
  static final AppointmentService _instance = AppointmentService._internal();
  factory AppointmentService() => _instance;
  AppointmentService._internal();

  static const String _keyAppointments = 'appointments';
  static const String _keyLastCompletedPayment = 'last_completed_payment';

  List<Appointment> _appointments = [];
  Appointment? _lastCompletedPayment;

  List<Appointment> get appointments => List.unmodifiable(_appointments);
  List<Appointment> get upcomingAppointments =>
      _appointments.where((a) => a.status == 'upcoming').toList()
        ..sort((a, b) => a.date.compareTo(b.date));
  Appointment? get lastCompletedPayment => _lastCompletedPayment;

  /// Initialize and load appointments from storage
  Future<void> initialize() async {
    await _loadAppointments();
    await _loadLastCompletedPayment();
  }

  Future<void> _loadAppointments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyAppointments);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _appointments =
            jsonList.map((json) => Appointment.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) print('Error loading appointments: $e');
    }
  }

  Future<void> _saveAppointments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString =
          jsonEncode(_appointments.map((a) => a.toJson()).toList());
      await prefs.setString(_keyAppointments, jsonString);
    } catch (e) {
      if (kDebugMode) print('Error saving appointments: $e');
    }
  }

  /// Add a new appointment after successful payment
  Future<Appointment> addAppointment({
    required String therapistName,
    required DateTime date,
    required String time,
    required int amount,
    required String paymentMethod,
    String? transactionHash,
  }) async {
    final appointment = Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      therapistName: therapistName,
      date: date,
      time: time,
      amount: amount,
      paymentMethod: paymentMethod,
      transactionHash: transactionHash,
      createdAt: DateTime.now(),
    );

    _appointments.add(appointment);
    await _saveAppointments();

    // Also save as last completed payment for showing success screen
    await _saveLastCompletedPayment(appointment);

    notifyListeners();
    return appointment;
  }

  /// Save last completed payment for showing success screen after redirect
  Future<void> _saveLastCompletedPayment(Appointment appointment) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          _keyLastCompletedPayment, jsonEncode(appointment.toJson()));
      _lastCompletedPayment = appointment;
    } catch (e) {
      if (kDebugMode) print('Error saving last completed payment: $e');
    }
  }

  /// Load last completed payment (for showing success screen after redirect)
  Future<void> _loadLastCompletedPayment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_keyLastCompletedPayment);
      if (jsonString != null) {
        _lastCompletedPayment =
            Appointment.fromJson(jsonDecode(jsonString));
      }
    } catch (e) {
      if (kDebugMode) print('Error loading last completed payment: $e');
    }
  }

  /// Clear last completed payment (after showing success screen)
  Future<void> clearLastCompletedPayment() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyLastCompletedPayment);
      _lastCompletedPayment = null;
    } catch (e) {
      if (kDebugMode) print('Error clearing last completed payment: $e');
    }
  }

  /// Check if there's a completed payment to show
  bool get hasCompletedPaymentToShow => _lastCompletedPayment != null;

  /// Cancel an appointment
  Future<void> cancelAppointment(String id) async {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(status: 'cancelled');
      await _saveAppointments();
      notifyListeners();
    }
  }

  /// Mark appointment as completed
  Future<void> completeAppointment(String id) async {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(status: 'completed');
      await _saveAppointments();
      notifyListeners();
    }
  }
}
