import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class WaitForPciPage extends StatefulWidget {
  @override
  _WaitForPciPageState createState() => _WaitForPciPageState();
}

class _WaitForPciPageState extends State<WaitForPciPage> {
  final TextEditingController _pciController = TextEditingController();
  final TextEditingController _pciVariableController = TextEditingController();
  double _timeout = 300;

  // GSM Cell Info Fields (Similar to cellInfo in the second page)
  Map<String, String> pciInfo = {
    "mPci": "",
    "mPci Variable": "",
    "mTimeout": "",
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
      pciInfo['mPci'] = prefs.getString('mPci') ?? '';
      pciInfo['mPci Variable'] = prefs.getString('mPci Variable') ?? '';
      pciInfo['mTimeout'] = prefs.getString('mTimeout') ?? '300';
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('mPci', pciInfo['mPci']!);
    prefs.setString('mPci Variable', pciInfo['mPci Variable']!);
    prefs.setString('mTimeout', pciInfo['mTimeout']!);
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
            ...pciInfo.keys.map(
                  (key) => _buildCustomTextField(
                label: key,
                value: pciInfo[key]!,
                onChanged: (val) => setState(() => pciInfo[key] = val),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'mTimeout: ${_timeout.toInt()} seconds',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _timeout,
              min: 1,
              max: 600,
              divisions: 599,
              label: _timeout.toInt().toString(),
              activeColor: const Color(0xff04bcb0),
              onChanged: (value) {
                setState(() {
                  _timeout = value;
                  pciInfo['mTimeout'] = value.toInt().toString(); // Sync the timeout value
                });
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state (Similar to the second page logic)
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(cellInfo: pciInfo));
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
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 8),
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
  required Map<String, String> cellInfo,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("PCI Configuration Info", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cellInfo.entries.map((entry) {
          return Text("${entry.key}: ${entry.value}", style: const TextStyle(color: Colors.white));
        }).toList(),
      ),
    ),
  );
}
