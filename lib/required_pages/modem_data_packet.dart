import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Import your provider file

class ModemDataPacketConfigPage extends StatefulWidget {
  @override
  _ModemDataPacketConfigPageState createState() =>
      _ModemDataPacketConfigPageState();
}

class _ModemDataPacketConfigPageState extends State<ModemDataPacketConfigPage> {
  bool enable = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();  // Load preferences when the widget is created
  }

  // Load preferences from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      enable = prefs.getBool('modemDataPacket') ?? true;
    });
  }

  // Save preferences to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modemDataPacket', enable);
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
            _buildCustomSwitch(
              label: "Enable Modem Data Packet",
              value: enable,
              onChanged: (val) {
                setState(() {
                  enable = val;
                });
                _savePreferences();  // Save the updated value
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Modem Data Packet is ${enable ? "Enabled" : "Disabled"}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Save state to the global state (like card or provider)
                  setState(() {
                    Provider.of<SaveCardState>(context, listen: false)
                        .addCard(cardOutput(enable: enable));
                  });
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

  Widget _buildCustomSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xff04bcb0),
        ),
      ],
    );
  }
}

Widget cardOutput({required bool enable}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Modem Data Packet", style: TextStyle(color: Colors.white)),
      subtitle: Text(
        "Modem Data Packet: ${enable ? 'Enabled' : 'Disabled'}",
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
