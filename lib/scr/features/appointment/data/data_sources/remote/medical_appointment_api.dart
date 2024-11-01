import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trabajo_moviles_ninjacode/scr/core/utils/usecases/jwt_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MedicalAppointmentApi {
  static const String _baseUrl = 'http://localhost:8080/api/v1';
http://localhost:8080/api/v1
  MedicalAppointmentApi() {
    tz.initializeTimeZones();
  }

  Future<String?> _getToken() async {
    return await JwtStorage.getToken();
  }

  Future<int?> _getUserId() async {
    return await JwtStorage.getUserId();
  }

  Future<Map<String, dynamic>?> getProfile(int profileId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/profile/profile/$profileId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception('Failed to load profile details');
    }
  }

  Future<int?> getProfileIdByPatientId(int patientId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/medical-record/patient/$patientId/profile-id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception('Failed to load profile ID');
    }
  }

  Future<int> _getDoctorId() async {
    final token = await _getToken();
    final profileId = await JwtStorage.getProfileId();
    if (profileId == null) {
      throw Exception('Profile ID not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/doctor/doctor/profile/$profileId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['id'];
    } else {
      throw Exception('Failed to load doctor ID');
    }
  }

  Future<int> getDoctorId() async {
    return await _getDoctorId();
  }

  Future<List<Map<String, dynamic>>> fetchAppointmentsForToday() async {
    final doctorId = await _getDoctorId();
    final token = await _getToken();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/medicalAppointment/medicalAppointments/doctor/$doctorId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> appointments = List<Map<String, dynamic>>.from(json.decode(response.body));
      final limaTimeZone = tz.getLocation('America/Lima');
      final today = tz.TZDateTime.now(limaTimeZone);
      final todayAppointments = appointments.where((appointment) {
        final eventDate = tz.TZDateTime.from(DateTime.parse(appointment['eventDate']), limaTimeZone);
        return eventDate.year == today.year && eventDate.month == today.month && eventDate.day == today.day;
      }).toList();
      return todayAppointments;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllAppointments() async {
    final token = await _getToken();
    final doctorId = await _getDoctorId();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/medicalAppointment/medicalAppointments/doctor/$doctorId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPatients() async {
    final token = await _getToken();
    final doctorId = await _getDoctorId();
    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/medical-record/patient/doctor/$doctorId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> patients = List<Map<String, dynamic>>.from(json.decode(response.body));
      final List<Map<String, dynamic>> patientProfiles = [];

      for (var patient in patients) {
        final profileResponse = await http.get(
          Uri.parse('$_baseUrl/profile/profile/${patient['profileId']}'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (profileResponse.statusCode == 200) {
          final profileData = json.decode(profileResponse.body);
          patientProfiles.add({
            'patientId': patient['id'],
            'fullName': profileData['fullName'],
          });
        }
      }

      return patientProfiles;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<bool> createMedicalAppointment(Map<String, dynamic> appointmentData) async {
    final token = await _getToken();
    final userId = await _getUserId();
    if (token == null || userId == null) {
      throw Exception('Token or user ID not found');
    }

    appointmentData['userId'] = userId; // Add userId to the appointment data

    final response = await http.post(
      Uri.parse('$_baseUrl/medicalAppointment'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(appointmentData),
    );

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Invalid or expired token');
    } else {
      throw Exception('Failed to create appointment');
    }
  }
}