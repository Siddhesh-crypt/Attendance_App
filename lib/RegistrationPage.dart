import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FaceRecognitionPage extends StatefulWidget {
  @override
  _FaceRecognitionPageState createState() => _FaceRecognitionPageState();
}

class _FaceRecognitionPageState extends State<FaceRecognitionPage> {
  final _centerController = TextEditingController();
  final _candidateController = TextEditingController();
  final _imagePicker = ImagePicker();

  File? _image;

  Future<void> _registerCandidate() async {
    final center = _centerController.text;
    final candidate = _candidateController.text;

    if (center.isEmpty || candidate.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all fields!',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    if (_image == null) {
      Fluttertoast.showToast(
        msg: 'Please select an image!',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'srv1022.hstgr.io',
        port: 3306,
        db: 'u777017855_DBS_PORT',
        user: 'u777017855_DBS_PORT',
        password: 'aU1#mCd#bL',
      ));

      final results = await conn.query(
        'INSERT INTO candidates (center_id, candidate_name, image) VALUES (?,?,?)',
        [center, candidate, _image!.readAsBytesSync()],
      );

      if (results.affectedRows! > 0) {
        Fluttertoast.showToast(
          msg: 'Candidate registered successfully! ✅',
          backgroundColor: Colors.green,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Error registering candidate! ❌',
          backgroundColor: Colors.red,
          textColor: Colors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }

      await conn.close();
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(
        msg: 'Error connecting to database! ❌',
        backgroundColor: Colors.red,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> _selectImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile!= null) {
        _image = File(pickedFile.path);
      } else {
        _image = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face Recognition Registration'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _centerController,
                decoration: InputDecoration(
                  labelText: 'Center ID',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _candidateController,
                decoration: InputDecoration(
                  labelText: 'Candidate Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _selectImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 10),
            _image!= null
                ? Image.file(
              _image!,
              height: 100,
              width: 100,
            )
                : Text('No image selected'),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _registerCandidate,
              child: Text('Register Candidate'),
            ),
          ],
        ),
      ),
    );
  }
}