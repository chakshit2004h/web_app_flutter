import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart';// Import the SaveCardState file

class GpsEnableDisable extends StatefulWidget {
  const GpsEnableDisable({super.key});

  @override
  State<GpsEnableDisable> createState() => _GpsEnableDisableState();
}

class _GpsEnableDisableState extends State<GpsEnableDisable> {
  bool lockScript = false;
  bool useTraceroute = false;
  TextEditingController val = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();  // Load preferences when the widget is created
  }

  // Load preferences from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lockScript = prefs.getBool('lockScript') ?? false;
      useTraceroute = prefs.getBool('useTraceroute') ?? false;
    });
  }

  // Save preferences to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lockScript', lockScript);
    await prefs.setBool('useTraceroute', useTraceroute);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Color(0xff1a1e22),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomCheckbox(
            label: 'Lock script',
            value: lockScript,
            onChanged: (value) {
              setState(() {
                lockScript = value!;
              });
              _savePreferences();  // Save the updated value
            },
          ),
          const SizedBox(height: 20),
          _buildCustomCheckbox(
            label: 'Use Traceroute 6',
            value: useTraceroute,
            onChanged: (value) {
              setState(() {
                useTraceroute = value!;
              });
              _savePreferences();  // Save the updated value
            },
          ),
          const SizedBox(height: 10),
          TextField(
            controller: val,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "bir.azenqos.com",
              labelText: 'IP Addr.',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add to global state when saving
              setState(() {
                Provider.of<SaveCardState>(context, listen: false)
                    .addCard(cardOutput(lockScript: lockScript, useTraceroute: useTraceroute));
              });
            },
            child: Text('Save', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff04bcb0),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Checkbox Widget
  Widget _buildCustomCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value), // Toggle checkbox when tapped
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value ? Colors.teal : Colors.transparent, // Change color when selected
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? Icon(Icons.check, color: Colors.white, size: 18)
                : null, // Show check icon when selected
          ),
          SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

Widget cardOutput({required bool lockScript, required bool useTraceroute}) {
  return Card(
    color: Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: Text("GPS",style: TextStyle(color: Colors.white),),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lock Script: ${lockScript ? 'Enabled' : 'Disabled'}",style: TextStyle(color: Colors.white),),
          Text("Use Traceroute: ${useTraceroute ? 'Enabled' : 'Disabled'}",style: TextStyle(color: Colors.white),),
        ],
      ),
    ),
  );
}
