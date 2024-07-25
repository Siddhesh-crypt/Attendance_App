import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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

  static Future<Map<String, dynamic>> markAttendance({
    required String candidateId,
    required String status,
    required String type,
    required XFile imageFile,
  }) async {
    final url = Uri.parse('$_baseUrl/attendance.php'); // Replace with your server URL

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final check_in_time = DateFormat('HH:mm:ss').format(now);
    final check_out_time = DateFormat('HH:mm:ss').format(now);

    final request = http.MultipartRequest('POST', url)
      ..fields['candidate_id'] = candidateId
      ..fields['status'] = status
      ..fields['type'] = type
      ..fields['date'] = formattedDate
      ..fields['time'] = check_in_time 
      ..fields['check_in_time'] = check_in_time
      ..fields['check_out_time'] = check_out_time
      ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final json = jsonDecode(responseData);
      return json;
    } else {
      return {
        'status': 'error',
        'message': 'Server error: ${response.reasonPhrase}',
      };
    }
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
