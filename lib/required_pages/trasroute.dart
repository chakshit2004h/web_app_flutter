import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Update with your actual provider file path

class Traceroute extends StatefulWidget {
  @override
  _TracerouteState createState() => _TracerouteState();
}

class _TracerouteState extends State<Traceroute> {
  // Traceroute Configuration Fields
  int maxHop = 15;
  String serverAddr = "blr.azenqos.com";
  bool useTraceroute6 = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load stored values from SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      maxHop = prefs.getInt('maxHop') ?? 15;
      serverAddr = prefs.getString('serverAddr') ?? "blr.azenqos.com";
      useTraceroute6 = prefs.getBool('useTraceroute6') ?? false;
    });
  }

  // Save values to SharedPreferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('maxHop', maxHop);
    await prefs.setString('serverAddr', serverAddr);
    await prefs.setBool('useTraceroute6', useTraceroute6);
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
          _buildLabel("Max Hop"),
          TextField(
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "$maxHop",
              hintStyle: const TextStyle(color: Colors.white70),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff04bcb0)),
              ),
            ),
            onChanged: (value) {
              setState(() {
                maxHop = int.tryParse(value) ?? maxHop;
              });
            },
          ),
          const SizedBox(height: 10),
          _buildLabel("Server Address"),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "$serverAddr",
              hintStyle: const TextStyle(color: Colors.white70),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white54),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xff04bcb0)),
              ),
            ),
            onChanged: (value) {
              setState(() {
                serverAddr = value;
              });
            },
          ),
          const SizedBox(height: 10),
          _buildLabel("Use Traceroute6"),
          Switch(
            value: useTraceroute6,
            onChanged: (value) {
              setState(() {
                useTraceroute6 = value;
              });
            },
            activeColor: const Color(0xff04bcb0),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _savePreferences();
              Provider.of<SaveCardState>(context, listen: false).addCard(
                cardOutput(maxHop: maxHop, serverAddr: serverAddr, useTraceroute6: useTraceroute6),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff04bcb0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
            ),
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// Output card that will be shown after saving
Widget cardOutput({
  required int maxHop,
  required String serverAddr,
  required bool useTraceroute6,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Traceroute Configuration", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Max Hop: $maxHop", style: const TextStyle(color: Colors.white)),
          Text("Server Address: $serverAddr", style: const TextStyle(color: Colors.white)),
          Text("Use Traceroute6: ${useTraceroute6 ? 'Yes' : 'No'}", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
