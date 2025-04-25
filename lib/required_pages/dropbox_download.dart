import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class DropboxDownloadPage extends StatefulWidget {
  @override
  _DropboxDownloadPageState createState() => _DropboxDownloadPageState();
}

class _DropboxDownloadPageState extends State<DropboxDownloadPage> {
  Map<String, String> settings = {
    "path": "/3mb.jpg",
    "timeout": "10",
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      settings['path'] = prefs.getString('path') ?? '/3mb.jpg';
      settings['timeout'] = prefs.getString('timeout') ?? '10';
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    settings.forEach((key, value) {
      prefs.setString(key, value);
    });
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
            ...settings.keys.map(
                  (key) => _buildCustomTextField(
                label: key,
                value: settings[key]!,
                onChanged: (val) => setState(() => settings[key] = val),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(settings: settings));
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
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[850],
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xff04bcb0)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

// ✅ Card Output Widget
Widget cardOutput({
  required Map<String, String> settings,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Dropbox Download", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: settings.entries.map((entry) {
          return Text("${entry.key}: ${entry.value}", style: const TextStyle(color: Colors.white));
        }).toList(),
      ),
    ),
  );
}
