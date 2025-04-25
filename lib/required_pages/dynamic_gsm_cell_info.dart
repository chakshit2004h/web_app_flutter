import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class GSMCellInfoPage extends StatefulWidget {
  const GSMCellInfoPage({super.key});

  @override
  State<GSMCellInfoPage> createState() => _GSMCellInfoPageState();
}

class _GSMCellInfoPageState extends State<GSMCellInfoPage> {
  Map<String, String> cellInfo = {
    "ant_bw": "",
    "bcch": "",
    "bsic": "",
    "cell_name": "",
    "dir": "",
    "lac": "",
    "lat": "",
    "lon": "",
    "mcc": "",
    "mnc": "",
    "site": ""
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
      cellInfo['ant_bw'] = prefs.getString('ant_bw') ?? '';
      cellInfo['bcch'] = prefs.getString('bcch') ?? '';
      cellInfo['bsic'] = prefs.getString('bsic') ?? '';
      cellInfo['cell_name'] = prefs.getString('cell_name') ?? '';
      cellInfo['dir'] = prefs.getString('dir') ?? '';
      cellInfo['lac'] = prefs.getString('lac') ?? '';
      cellInfo['lat'] = prefs.getString('lat') ?? '';
      cellInfo['lon'] = prefs.getString('lon') ?? '';
      cellInfo['mcc'] = prefs.getString('mcc') ?? '';
      cellInfo['mnc'] = prefs.getString('mnc') ?? '';
      cellInfo['site'] = prefs.getString('site') ?? '';
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    cellInfo.forEach((key, value) {
      prefs.setString(key, value);
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
            ...cellInfo.keys.map(
                  (key) => _buildCustomTextField(
                label: key,
                value: cellInfo[key]!,
                onChanged: (val) => setState(() => cellInfo[key] = val),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(cellInfo: cellInfo));
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
  required Map<String, String> cellInfo,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("GSM Cell Info", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cellInfo.entries.map((entry) {
          return Text("${entry.key}: ${entry.value}", style: const TextStyle(color: Colors.white));
        }).toList(),
      ),
    ),
  );
}
