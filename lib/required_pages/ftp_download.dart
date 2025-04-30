import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart';
import 'answer.dart'; // Adjust import path if needed

class FtpDownloadPage extends StatefulWidget {
  @override
  _FtpDownloadPageState createState() => _FtpDownloadPageState();
}

class _FtpDownloadPageState extends State<FtpDownloadPage> {
  bool enableRedoAvgThroughputThreshold = false;
  bool enableRedoMaxThroughputThreshold = false;
  bool endWhenNotLte = false;
  String filename = "1GB";
  int ifGsmWaitAfterEnd = 10;
  int ifGsmWaitBeforeEnd = 10;
  int ifWcdmaWaitAfterEnd = 10;
  int ifWcdmaWaitBeforeEnd = 10;
  int inactivityTimeout = 36000;
  String ip = "blr.azenqos.com";
  String password = "azqazqazq";
  int port = 21;
  double redoAvgThroughputThreshold = 1000.0;
  double redoMaxThroughputThreshold = 5000.0;
  int sessionCount = 1;
  int timeout = 36000;
  String username = "ftptest";

  final TextEditingController filenameController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enableRedoAvgThroughputThreshold = prefs.getBool('enableRedoAvgThroughputThreshold') ?? false;
      enableRedoMaxThroughputThreshold = prefs.getBool('enableRedoMaxThroughputThreshold') ?? false;
      endWhenNotLte = prefs.getBool('endWhenNotLte') ?? false;
      filename = prefs.getString('filename') ?? "1GB";
      ifGsmWaitAfterEnd = prefs.getInt('ifGsmWaitAfterEnd') ?? 10;
      ifGsmWaitBeforeEnd = prefs.getInt('ifGsmWaitBeforeEnd') ?? 10;
      ifWcdmaWaitAfterEnd = prefs.getInt('ifWcdmaWaitAfterEnd') ?? 10;
      ifWcdmaWaitBeforeEnd = prefs.getInt('ifWcdmaWaitBeforeEnd') ?? 10;
      inactivityTimeout = prefs.getInt('inactivityTimeout') ?? 36000;
      ip = prefs.getString('ip') ?? "blr.azenqos.com";
      password = prefs.getString('password') ?? "azqazqazq";
      port = prefs.getInt('port') ?? 21;
      redoAvgThroughputThreshold = prefs.getDouble('redoAvgThroughputThreshold') ?? 1000.0;
      redoMaxThroughputThreshold = prefs.getDouble('redoMaxThroughputThreshold') ?? 5000.0;
      sessionCount = prefs.getInt('sessionCount') ?? 1;
      timeout = prefs.getInt('timeout') ?? 36000;
      username = prefs.getString('username') ?? "ftptest";
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('enableRedoAvgThroughputThreshold', enableRedoAvgThroughputThreshold);
    prefs.setBool('enableRedoMaxThroughputThreshold', enableRedoMaxThroughputThreshold);
    prefs.setBool('endWhenNotLte', endWhenNotLte);
    prefs.setString('filename', filename);
    prefs.setInt('ifGsmWaitAfterEnd', ifGsmWaitAfterEnd);
    prefs.setInt('ifGsmWaitBeforeEnd', ifGsmWaitBeforeEnd);
    prefs.setInt('ifWcdmaWaitAfterEnd', ifWcdmaWaitAfterEnd);
    prefs.setInt('ifWcdmaWaitBeforeEnd', ifWcdmaWaitBeforeEnd);
    prefs.setInt('inactivityTimeout', inactivityTimeout);
    prefs.setString('ip', ip);
    prefs.setString('password', password);
    prefs.setInt('port', port);
    prefs.setDouble('redoAvgThroughputThreshold', redoAvgThroughputThreshold);
    prefs.setDouble('redoMaxThroughputThreshold', redoMaxThroughputThreshold);
    prefs.setInt('sessionCount', sessionCount);
    prefs.setInt('timeout', timeout);
    prefs.setString('username', username);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: double.infinity,
      color: const Color(0xff1a1e22),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSwitch("Enable Redo Avg Throughput Threshold", enableRedoAvgThroughputThreshold, (val) {
              setState(() => enableRedoAvgThroughputThreshold = val);
            }),
            const SizedBox(height: 10,),
            buildSwitch("Enable Redo Max Throughput Threshold", enableRedoMaxThroughputThreshold, (val) {
              setState(() => enableRedoMaxThroughputThreshold = val);
            }),
            const SizedBox(height: 10,),
            buildSwitch("End When Not Lte", endWhenNotLte, (val) {
              setState(() => endWhenNotLte = val);
            }),
            const SizedBox(height: 10,),
            buildTextField("Filename", filenameController, onChanged: (val) {
              setState(() => filename = val);
            }),
            const SizedBox(height: 10,),
            buildNumberField("If GSM Wait After End", ifGsmWaitAfterEnd, (val) {
              setState(() => ifGsmWaitAfterEnd = val);
            }),
            const SizedBox(height: 10,),
            buildNumberField("If GSM Wait Before End", ifGsmWaitBeforeEnd, (val) {
              setState(() => ifGsmWaitBeforeEnd = val);
            }),
            const SizedBox(height: 10,),
            buildNumberField("If WCDMA Wait After End", ifWcdmaWaitAfterEnd, (val) {
              setState(() => ifWcdmaWaitAfterEnd = val);
            }),
            const SizedBox(height: 10,),
            buildNumberField("If WCDMA Wait Before End", ifWcdmaWaitBeforeEnd, (val) {
              setState(() => ifWcdmaWaitBeforeEnd = val);
            }),
            const SizedBox(height: 10,),
            buildNumberField("Inactivity Timeout", inactivityTimeout, (val) {
              setState(() => inactivityTimeout = val);
            }),
            const SizedBox(height: 10,),
            buildTextField("IP Address", ipController, onChanged: (val) {
              setState(() => ip = val);
            }),
            const SizedBox(height: 10,),
            buildTextField("Password", passwordController, onChanged: (val) {
              setState(() => password = val);
            }),
            const SizedBox(height: 10,),
            buildNumberField("Port", port, (val) {
              setState(() => port = val);
            }),
            const SizedBox(height: 10,),
            buildNumberField("Redo Avg Throughput Threshold", redoAvgThroughputThreshold.toInt(), (val) {
              setState(() => redoAvgThroughputThreshold = val.toDouble());
            }),
            const SizedBox(height: 10,),
            buildNumberField("Redo Max Throughput Threshold", redoMaxThroughputThreshold.toInt(), (val) {
              setState(() => redoMaxThroughputThreshold = val.toDouble());
            }),
            const SizedBox(height: 10,),
            buildNumberField("Session Count", sessionCount, (val) {
              setState(() => sessionCount = val);
            }),
            const SizedBox(height: 10,),
            buildNumberField("Timeout", timeout, (val) {
              setState(() => timeout = val);
            }),
            const SizedBox(height: 10,),
            buildTextField("Username", usernameController, onChanged: (val) {
              setState(() => username = val);
            }),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false).addCard(cardOutput(cellInfo: {
                    "enableRedoAvgThroughputThreshold": enableRedoAvgThroughputThreshold.toString(),
                    "enableRedoMaxThroughputThreshold": enableRedoMaxThroughputThreshold.toString(),
                    "endWhenNotLte": endWhenNotLte.toString(),
                    "filename": filename,
                    "ifGsmWaitAfterEnd": ifGsmWaitAfterEnd.toString(),
                    "ifGsmWaitBeforeEnd": ifGsmWaitBeforeEnd.toString(),
                    "ifWcdmaWaitAfterEnd": ifWcdmaWaitAfterEnd.toString(),
                    "ifWcdmaWaitBeforeEnd": ifWcdmaWaitBeforeEnd.toString(),
                    "inactivityTimeout": inactivityTimeout.toString(),
                    "ip": ip,
                    "password": password,
                    "port": port.toString(),
                    "redoAvgThroughputThreshold": redoAvgThroughputThreshold.toString(),
                    "redoMaxThroughputThreshold": redoMaxThroughputThreshold.toString(),
                    "sessionCount": sessionCount.toString(),
                    "timeout": timeout.toString(),
                    "username": username,
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  Widget buildSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xff04bcb0),
    );
  }
  Widget buildTextField(String label, TextEditingController controller, {ValueChanged<String>? onChanged}) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white,),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white,),
        filled: true,
        fillColor: Colors.grey[850], // Match your background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Remove border
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Remove border when enabled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Remove border when focused
        ),
        hoverColor: Colors.transparent, // Remove hover color
      ),
    );
  }

  Widget buildNumberField(String label, int initialValue, ValueChanged<int> onChanged) {
    return TextField(
      keyboardType: TextInputType.number,
      controller: TextEditingController()..text = initialValue.toString(),
      onChanged: (val) => onChanged(int.tryParse(val) ?? initialValue),
      style: const TextStyle(color: Colors.white, ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white,),
        filled: true,
        fillColor: Colors.grey[850], // Match your background color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Remove border
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Remove border when enabled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Remove border when focused
        ),
        hoverColor: Colors.transparent, // Remove hover color
      ),
    );
  }
}
