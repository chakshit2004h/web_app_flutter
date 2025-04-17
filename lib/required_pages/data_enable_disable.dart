import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class DataEnableDisable extends StatefulWidget {
  @override
  _DataEnableDisableState createState() => _DataEnableDisableState();
}

class _DataEnableDisableState extends State<DataEnableDisable> {
  bool isEnable = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isEnable = prefs.getBool('data_enable') ?? true;
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('data_enable', isEnable);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: const Color(0xff1a1e22),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSwitchTile("Enable Data", isEnable, (val) {
            setState(() {
              isEnable = val;
            });
          }),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _savePreferences(); // Save to shared preferences

                // Add to Provider state
                Provider.of<SaveCardState>(context, listen: false)
                    .addCard(cardOutput(isEnable: isEnable));
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff04bcb0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String label, bool value, ValueChanged<bool> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff2c2f33),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value ? "Enabled" : "Disabled", style: const TextStyle(color: Colors.white)),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: const Color(0xff04bcb0),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ✅ Card Output Widget
Widget cardOutput({
  required bool isEnable,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Data Enable/Disable", style: TextStyle(color: Colors.white)),
      subtitle: Text(
        "Data: ${isEnable ? 'Enabled' : 'Disabled'}",
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
