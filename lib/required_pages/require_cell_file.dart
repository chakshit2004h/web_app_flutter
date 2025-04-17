import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Update with your actual provider file path

class RequireCellFilePage extends StatefulWidget {
  const RequireCellFilePage({super.key});

  @override
  State<RequireCellFilePage> createState() => _RequireCellFilePageState();
}

class _RequireCellFilePageState extends State<RequireCellFilePage> {
  int mTimeout = 10;
  String mUssd = "";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load stored values from SharedPreferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      mTimeout = prefs.getInt('cellTimeout') ?? 10;
      mUssd = prefs.getString('cellUssd') ?? '';
    });
  }

  // Save values to SharedPreferences
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cellTimeout', mTimeout);
    await prefs.setString('cellUssd', mUssd);
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
          _buildLabel("Timeout (seconds)"),
          Slider(
            activeColor: const Color(0xff04bcb0),
            value: mTimeout.toDouble(),
            min: 0,
            max: 60,
            divisions: 60,
            label: '$mTimeout',
            onChanged: (value) {
              setState(() {
                mTimeout = value.toInt();
              });
            },
          ),
          Text(
            'Current Timeout: $mTimeout',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          _buildLabel("USSD Code"),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Enter USSD code",
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
                mUssd = value;
              });
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Current USSD Code: $mUssd',
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              _savePreferences();
              Provider.of<SaveCardState>(context, listen: false).addCard(
                cardOutput(timeout: mTimeout, ussd: mUssd),
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
Widget cardOutput({required int timeout, required String ussd}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Require Cell File", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Timeout: $timeout seconds", style: const TextStyle(color: Colors.white)),
          Text("USSD Code: $ussd", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
