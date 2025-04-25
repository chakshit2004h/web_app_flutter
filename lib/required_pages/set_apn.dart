import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class SetApnPage extends StatefulWidget {
  @override
  _SetApnPageState createState() => _SetApnPageState();
}

class _SetApnPageState extends State<SetApnPage> {
  final TextEditingController _apnController = TextEditingController();
  final TextEditingController _maxAttemptController = TextEditingController(text: "100");

  String? _apnProtocol;
  String? _authType;

  final List<String> _apnProtocols = ['IPv4', 'IPv6', 'IPv4/IPv6'];
  final List<String> _authTypes = ['None', 'PAP', 'CHAP', 'PAP or CHAP'];

  Map<String, String> apnInfo = {
    "apn": "",
    "apnProtocol": "",
    "authType": "",
    "maxAttempt": "100"
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
      apnInfo['apn'] = prefs.getString('apn') ?? '';
      apnInfo['apnProtocol'] = prefs.getString('apnProtocol') ?? '';
      apnInfo['authType'] = prefs.getString('authType') ?? '';
      apnInfo['maxAttempt'] = prefs.getString('maxAttempt') ?? '100';
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('apn', apnInfo['apn']!);
    prefs.setString('apnProtocol', apnInfo['apnProtocol']!);
    prefs.setString('authType', apnInfo['authType']!);
    prefs.setString('maxAttempt', apnInfo['maxAttempt']!);
  }

  // Save to provider state and show confirmation
  _submitForm() {
    final apn = _apnController.text.trim();
    final maxAttempt = int.tryParse(_maxAttemptController.text.trim());

    if (maxAttempt != null) {
      _savePreferences(); // Save to shared preferences

      // Add to Provider state
      Provider.of<SaveCardState>(context, listen: false).addCard(cardOutput(cellInfo: apnInfo));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid max attempt")),
      );
    }
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
            _buildCustomTextField(label: "APN", controller: _apnController),
            const SizedBox(height: 16),
            _buildCustomDropdown(
              label: "APN Protocol",
              value: _apnProtocol,
              items: _apnProtocols,
              onChanged: (val) => setState(() {
                _apnProtocol = val;
                apnInfo['apnProtocol'] = val ?? '';
              }),
            ),
            const SizedBox(height: 16),
            _buildCustomDropdown(
              label: "Auth Type",
              value: _authType,
              items: _authTypes,
              onChanged: (val) => setState(() {
                _authType = val;
                apnInfo['authType'] = val ?? '';
              }),
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Max Attempt",
              controller: _maxAttemptController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xff2a2f35),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff04bcb0), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      dropdownColor: const Color(0xff2a2f35),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xff2a2f35),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff04bcb0), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      iconEnabledColor: Colors.white,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
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
      title: const Text("APN Settings", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cellInfo.entries.map((entry) {
          return Text("${entry.key}: ${entry.value}", style: const TextStyle(color: Colors.white));
        }).toList(),
      ),
    ),
  );
}
