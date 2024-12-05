import 'package:flutter/material.dart';
import '../Services/api/logs_service.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  List<dynamic> logs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedLogs = await fetchLogs();
      setState(() {
        logs = fetchedLogs ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load log data.';
      });
      debugPrint('Error fetching logs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Logs'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : logs.isEmpty
              ? const Center(child: Text('No logs available.'))
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Movie Title')),
                          DataColumn(label: Text('Date Searched')),
                          DataColumn(label: Text('Search Results')),
                        ],
                        rows: logs.map((e) {
                          return DataRow(
                            cells: [
                              DataCell(Text((e['id'] ?? '').toString())),
                              DataCell(Text((e['movieTitle'] ?? '').toString())),
                              DataCell(Text((DateTime.parse(e['queryDate'])).toString())),
                              DataCell(Text((e['numOfResults'] ?? 0).toString())),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
    );
  }
}
