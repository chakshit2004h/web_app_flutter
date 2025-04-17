import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust the path if needed

class FTPUploadPage extends StatefulWidget {
  const FTPUploadPage({super.key});

  @override
  State<FTPUploadPage> createState() => _FTPUploadPageState();
}

class _FTPUploadPageState extends State<FTPUploadPage> {
  Map<String, dynamic> ftpConfig = {
    "directory": "",
    "enableRedoAvgThroughputThreshold": false,
    "enableRedoMaxThroughputThreshold": false,
    "endWhenNotLte": false,
    "filesizeStr": "5mb",
    "ifGsmWaitAfterEnd": 10,
    "ifGsmWaitBeforeEnd": 10,
    "ifWcdmaWaitAfterEnd": 10,
    "ifWcdmaWaitBeforeEnd": 10,
    "inactivityTimeout": 600,
    "ip": "blr.azenqos.com",
    "password": "azqazqazq",
    "port": 21,
    "redoAvgThroughputThreshold": 1000.0,
    "redoMaxThroughputThreshold": 5000.0,
    "sessionCount": 1,
    "timeout": 1200,
    "username": "ftptest",
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      ftpConfig.forEach((key, value) {
        if (value is int) {
          ftpConfig[key] = prefs.getInt(key) ?? value;
        } else if (value is double) {
          ftpConfig[key] = prefs.getDouble(key) ?? value;
        } else if (value is bool) {
          ftpConfig[key] = prefs.getBool(key) ?? value;
        } else if (value is String) {
          ftpConfig[key] = prefs.getString(key) ?? value;
        }
      });
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    ftpConfig.forEach((key, value) {
      if (value is int) {
        prefs.setInt(key, value);
      } else if (value is double) {
        prefs.setDouble(key, value);
      } else if (value is bool) {
        prefs.setBool(key, value);
      } else if (value is String) {
        prefs.setString(key, value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: const Color(0xff1a1e22),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Directory", "directory"),
            _buildSwitch("Enable Redo Avg Throughput Threshold", "enableRedoAvgThroughputThreshold"),
            _buildSwitch("Enable Redo Max Throughput Threshold", "enableRedoMaxThroughputThreshold"),
            _buildSwitch("End When Not LTE", "endWhenNotLte"),
            _buildTextField("File Size", "filesizeStr"),
            _buildNumberField("GSM Wait After End (s)", "ifGsmWaitAfterEnd"),
            _buildNumberField("GSM Wait Before End (s)", "ifGsmWaitBeforeEnd"),
            _buildNumberField("WCDMA Wait After End (s)", "ifWcdmaWaitAfterEnd"),
            _buildNumberField("WCDMA Wait Before End (s)", "ifWcdmaWaitBeforeEnd"),
            _buildNumberField("Inactivity Timeout (s)", "inactivityTimeout"),
            _buildTextField("IP Address", "ip"),
            _buildTextField("Password", "password"),
            _buildNumberField("Port", "port"),
            _buildDoubleField("Redo Avg Throughput Threshold", "redoAvgThroughputThreshold"),
            _buildDoubleField("Redo Max Throughput Threshold", "redoMaxThroughputThreshold"),
            _buildNumberField("Session Count", "sessionCount"),
            _buildNumberField("Timeout (s)", "timeout"),
            _buildTextField("Username", "username"),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences();
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(cellInfo: ftpConfig.map((k, v) => MapEntry(k, v.toString()))));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: TextEditingController(text: ftpConfig[key]),
        onChanged: (val) => setState(() => ftpConfig[key] = val),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildNumberField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: TextEditingController(text: ftpConfig[key].toString()),
        keyboardType: TextInputType.number,
        onChanged: (val) => setState(() => ftpConfig[key] = int.tryParse(val) ?? 0),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildDoubleField(String label, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: TextEditingController(text: ftpConfig[key].toString()),
        keyboardType: TextInputType.number,
        onChanged: (val) => setState(() => ftpConfig[key] = double.tryParse(val) ?? 0.0),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, String key) {
    return SwitchListTile(
      activeColor: const Color(0xff04bcb0),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      value: ftpConfig[key] ?? false,
      onChanged: (val) => setState(() => ftpConfig[key] = val),
    );
  }
  Widget cardOutput({required Map<String, String> cellInfo}) {
    return Card(
      color: const Color(0xff101f1f),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ftp Upload',
              style: TextStyle(
                color: Color(0xff04bcb0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...cellInfo.entries.map(
                  (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        "${entry.key}:",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
