import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'AnimatedDrawer.dart';

class AttendanceListPage extends StatefulWidget {
  @override
  _AttendanceListPageState createState() => _AttendanceListPageState();
}

class _AttendanceListPageState extends State<AttendanceListPage> {
  List<Map<String, dynamic>> _attendanceData = [];
  bool _loading = true;
  DateTime? _filterDate;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await DatabaseHelper.fetchAttendanceData();
      setState(() {
        _attendanceData = data;
      });
    } catch (e) {
      // Print the error message
      print('Error fetching attendance data: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }



  void _filterByDate(DateTime? date) {
    setState(() {
      _filterDate = date;
    });
  }

  void _downloadCsv() async {
    try {
      await DatabaseHelper.downloadCsv();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV downloaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading CSV: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Attendance List', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.white,),
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
              );
              _filterByDate(selectedDate);
            },
          ),
          IconButton(
            icon: Icon(Icons.download, color: Colors.white,),
            onPressed: _downloadCsv,
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: AnimatedDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Column(
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('Candidate ID')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Check In')),
                  DataColumn(label: Text('Check Out'))
                ],
                rows: _attendanceData
                    .where((record) =>
                _filterDate == null ||
                    record['date'] ==
                        _filterDate
                            ?.toIso8601String()
                            .split('T')
                            .first)
                    .map((record) {
                  return DataRow(cells: [
                    DataCell(Text(record['candidate_id'])),
                    DataCell(Text(record['status'])),
                    DataCell(Text(record['date'])),
                    DataCell(Text(record['check_in_time'])),
                    DataCell(Text(record['check_out_time'])),
                  ]);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
