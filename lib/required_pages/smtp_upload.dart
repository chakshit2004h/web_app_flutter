import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart';

class SftpUploadPage extends StatefulWidget {
  @override
  _SftpUploadPageState createState() => _SftpUploadPageState();
}

class _SftpUploadPageState extends State<SftpUploadPage> {
  final TextEditingController fileSizeController = TextEditingController();
  final TextEditingController hostController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController portController = TextEditingController();
  final TextEditingController sessionCountController = TextEditingController();
  final TextEditingController timeoutController = TextEditingController();
  final TextEditingController uploadPathController = TextEditingController();
  final TextEditingController avgThresholdController = TextEditingController();
  final TextEditingController maxThresholdController = TextEditingController();

  bool enableRedoAvgThroughputThreshold = false;
  bool enableRedoMaxThroughputThreshold = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    fileSizeController.dispose();
    hostController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    portController.dispose();
    sessionCountController.dispose();
    timeoutController.dispose();
    uploadPathController.dispose();
    avgThresholdController.dispose();
    maxThresholdController.dispose();
    super.dispose();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fileSizeController.text = prefs.getString('sftp_fileSize') ?? '5MB';
      hostController.text = prefs.getString('sftp_host') ?? 'blr.azenqos.com';
      usernameController.text = prefs.getString('sftp_username') ?? 'ftptest';
      passwordController.text = prefs.getString('sftp_password') ?? 'azqazqazq';
      portController.text = prefs.getString('sftp_port') ?? '22';
      sessionCountController.text = prefs.getString('sftp_sessionCount') ?? '1';
      timeoutController.text = prefs.getString('sftp_timeout') ?? '36000';
      uploadPathController.text = prefs.getString('sftp_uploadPath') ?? './';
      avgThresholdController.text = prefs.getString('sftp_avgThreshold') ?? '1000';
      maxThresholdController.text = prefs.getString('sftp_maxThreshold') ?? '5000';
      enableRedoAvgThroughputThreshold = prefs.getBool('sftp_enableRedoAvg') ?? false;
      enableRedoMaxThroughputThreshold = prefs.getBool('sftp_enableRedoMax') ?? false;
    });
  }

  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sftp_fileSize', fileSizeController.text);
    await prefs.setString('sftp_host', hostController.text);
    await prefs.setString('sftp_username', usernameController.text);
    await prefs.setString('sftp_password', passwordController.text);
    await prefs.setString('sftp_port', portController.text);
    await prefs.setString('sftp_sessionCount', sessionCountController.text);
    await prefs.setString('sftp_timeout', timeoutController.text);
    await prefs.setString('sftp_uploadPath', uploadPathController.text);
    await prefs.setString('sftp_avgThreshold', avgThresholdController.text);
    await prefs.setString('sftp_maxThreshold', maxThresholdController.text);
    await prefs.setBool('sftp_enableRedoAvg', enableRedoAvgThroughputThreshold);
    await prefs.setBool('sftp_enableRedoMax', enableRedoMaxThroughputThreshold);
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      activeColor: const Color(0xff04bcb0),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xff2c2f33),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xff04bcb0)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardOutput() {
    return Card(
      color: const Color(0xff101f1f),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("SFTP Upload Configuration", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Host: ${hostController.text}", style: const TextStyle(color: Colors.white)),
            Text("Port: ${portController.text}", style: const TextStyle(color: Colors.white)),
            Text("Username: ${usernameController.text}", style: const TextStyle(color: Colors.white)),
            Text("Password: ${passwordController.text}", style: const TextStyle(color: Colors.white)),
            Text("File Size: ${fileSizeController.text}", style: const TextStyle(color: Colors.white)),
            Text("Upload Path: ${uploadPathController.text}", style: const TextStyle(color: Colors.white)),
            Text("Session Count: ${sessionCountController.text}", style: const TextStyle(color: Colors.white)),
            Text("Timeout: ${timeoutController.text} sec", style: const TextStyle(color: Colors.white)),
            Text("Avg Threshold: ${avgThresholdController.text} kbps (Enabled: $enableRedoAvgThroughputThreshold)", style: const TextStyle(color: Colors.white)),
            Text("Max Threshold: ${maxThresholdController.text} kbps (Enabled: $enableRedoMaxThroughputThreshold)", style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final saveCardState = Provider.of<SaveCardState>(context);

    return SingleChildScrollView(
      child: Container(
        width: 300,
        color: const Color(0xff1a1e22),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSwitchTile('Enable Redo Avg Throughput Threshold', enableRedoAvgThroughputThreshold, (val) {
              setState(() => enableRedoAvgThroughputThreshold = val);
            }),
            _buildSwitchTile('Enable Redo Max Throughput Threshold', enableRedoMaxThroughputThreshold, (val) {
              setState(() => enableRedoMaxThroughputThreshold = val);
            }),
            const SizedBox(height: 20),
            _buildTextField('File Size', fileSizeController),
            _buildTextField('Host', hostController),
            _buildTextField('Username', usernameController),
            _buildTextField('Password', passwordController, obscure: true),
            _buildTextField('Port', portController, keyboardType: TextInputType.number),
            _buildTextField('Session Count', sessionCountController, keyboardType: TextInputType.number),
            _buildTextField('Timeout', timeoutController, keyboardType: TextInputType.number),
            _buildTextField('Upload Path', uploadPathController),
            _buildTextField('Avg Threshold (kbps)', avgThresholdController, keyboardType: TextInputType.number),
            _buildTextField('Max Threshold (kbps)', maxThresholdController, keyboardType: TextInputType.number),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences();
                  saveCardState.addCard(_cardOutput());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
