import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/attendance.dart';

class DatabaseHelper {
  static const String _baseUrl = 'https://dbs.ideaas.co.in/api';

  static Future<bool> registerCandidate({required String name, required String candidateId, required String centerId, required XFile imageFile}) async {
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/register.php'));
    request.fields['name'] = name;
    request.fields['candidate_id'] = candidateId;
    request.fields['center_id'] = centerId;
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();
    return response.statusCode == 200;
  }

  static Future<bool> markAttendance({required String candidateId, required String status, required XFile imageFile}) async {
    final request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/attendance.php'));

    // Add form fields
    request.fields['candidate_id'] = candidateId;
    request.fields['status'] = status;

    // Add current date and time
    DateTime now = DateTime.now();
    String formattedDate = '${now.year}-${_twoDigits(now.month)}-${_twoDigits(now.day)}';
    String formattedTime = '${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}';
    request.fields['date'] = formattedDate;
    request.fields['time'] = formattedTime;

    // Add image file
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    // Send the request
    final response = await request.send();
    return response.statusCode == 200;
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }

  static Future<List<Map<String, dynamic>>> fetchAttendanceData() async {
    final response = await http.get(Uri.parse('$_baseUrl/show_attendance.php'));
    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Failed to load attendance data');
        }
      } catch (e) {
        print('Error decoding JSON: $e');
        throw Exception('Error decoding JSON');
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }

  static Future<void> downloadCsv() async {
    try {
      var status = await Permission.storage.request();
      print(status);
      if (status.isGranted) {
        final response = await http.get(Uri.parse('$_baseUrl/download_attendance.php'));
        if (response.statusCode == 200) {
          final directory = await getExternalStorageDirectory();
          final path = directory?.path;
          final file = File('$path/attendance_data.csv');
          await file.writeAsBytes(response.bodyBytes);
          print('CSV downloaded: $file');
        } else {
          throw Exception('Failed to download CSV');
        }
      } else {
        throw Exception('Storage permission denied');
      }
    } catch (e) {
      print('Error downloading CSV: $e');
    }
  }
}

// class Attendance {
//   final String name;
//   final String id;
//   final String status;
//   final String date;
//
//   Attendance({
//     required this.name,
//     required this.id,
//     required this.status,
//     required this.date,
//   });
// }


