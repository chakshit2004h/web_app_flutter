import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class FileUploadPage extends StatefulWidget {
  @override
  _FileUploadPageState createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  final TextEditingController _fileSizeController = TextEditingController(text: "1024");
  final TextEditingController _filePathController = TextEditingController(text: "/3mb.jpg");
  final TextEditingController _fileUrlController = TextEditingController(text: "https://files.azenqos.com/temp/3mb.jpg");
  final TextEditingController _timeoutController = TextEditingController(text: "10");

  bool _useGenerateFile = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved values from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fileSizeController.text = prefs.getString('file_size') ?? "1024";
      _filePathController.text = prefs.getString('file_path') ?? "/3mb.jpg";
      _fileUrlController.text = prefs.getString('file_url') ?? "https://files.azenqos.com/temp/3mb.jpg";
      _timeoutController.text = prefs.getString('timeout') ?? "10";
      _useGenerateFile = prefs.getBool('use_generate_file') ?? false;
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('file_size', _fileSizeController.text);
    prefs.setString('file_path', _filePathController.text);
    prefs.setString('file_url', _fileUrlController.text);
    prefs.setString('timeout', _timeoutController.text);
    prefs.setBool('use_generate_file', _useGenerateFile);
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
            _buildCustomTextField(
              label: "Generate File Size (bytes)",
              controller: _fileSizeController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "File Path",
              controller: _filePathController,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Source File URL",
              controller: _fileUrlController,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Timeout (seconds)",
              controller: _timeoutController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildSwitchField(
              label: "Use Generated File",
              value: _useGenerateFile,
              onChanged: (val) {
                setState(() {
                  _useGenerateFile = val;
                });
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false).addCard(
                    cardOutput(
                      fileInfo: {
                        'file_size': _fileSizeController.text,
                        'file_path': _filePathController.text,
                        'file_url': _fileUrlController.text,
                        'timeout': _timeoutController.text,
                        'use_generate_file': _useGenerateFile.toString(),
                      },
                    ),
                  );
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
                    Icon(Icons.upload, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Upload File',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff2c2f33),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xff04bcb0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchField({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return SwitchListTile(
      title: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xff04bcb0),
      tileColor: const Color(0xff2c2f33),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// ✅ Card Output Widget
Widget cardOutput({
  required Map<String, String> fileInfo,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("File Upload Info", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fileInfo.entries.map((entry) {
          return Text("${entry.key}: ${entry.value}", style: const TextStyle(color: Colors.white));
        }).toList(),
      ),
    ),
  );
}
