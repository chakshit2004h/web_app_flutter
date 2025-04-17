import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../addon/provider.dart'; // adjust if needed

class SendSmsPage extends StatefulWidget {
  @override
  _SendSmsPageState createState() => _SendSmsPageState();
}

class _SendSmsPageState extends State<SendSmsPage> {
  List<Map<String, dynamic>> fields = [
    {"fieldName": "autoAddIdPrefix", "type": "boolean", "value": true},
    {"fieldName": "deliveredTimeOut", "type": "int", "value": 45},
    {"fieldName": "enableRedoWhenDeliveryFailed", "type": "boolean", "value": false},
    {"fieldName": "enableRedoWhenSendFailed", "type": "boolean", "value": false},
    {"fieldName": "message", "type": "String", "value": ""},
    {"fieldName": "phoneNumber", "type": "String", "value": ""},
    {"fieldName": "sentTimeOut", "type": "int", "value": 45},
    {"fieldName": "smsc", "type": "String", "value": ""},
  ];

  Map<String, TextEditingController> textControllers = {};

  @override
  void initState() {
    super.initState();
    for (var field in fields) {
      if (field["type"] == "String") {
        textControllers[field["fieldName"]] = TextEditingController(text: field["value"]);
      }
    }
    _loadPreferences();
  }

  @override
  void dispose() {
    textControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    for (var field in fields) {
      String key = field["fieldName"];
      if (field["type"] == "boolean") {
        field["value"] = prefs.getBool(key) ?? field["value"];
      } else if (field["type"] == "int") {
        field["value"] = prefs.getInt(key) ?? field["value"];
      } else if (field["type"] == "String") {
        field["value"] = prefs.getString(key) ?? field["value"];
        textControllers[key]?.text = field["value"];
      }
    }
    setState(() {});
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    for (var field in fields) {
      String key = field["fieldName"];
      var value = field["value"];
      if (value is bool) {
        await prefs.setBool(key, value);
      } else if (value is int) {
        await prefs.setInt(key, value);
      } else if (value is String) {
        await prefs.setString(key, value);
      }
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
          children: [
            ...fields.map<Widget>((field) {
              final label = field["fieldName"];
              switch (field["type"]) {
                case "boolean":
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildCheckbox(label, field["value"], (val) {
                      setState(() {
                        field["value"] = val ?? false;
                      });
                    }),
                  );
                case "int":
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildStyledTextField(
                      label: label,
                      initialValue: field["value"].toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() {
                          field["value"] = int.tryParse(val) ?? field["value"];
                        });
                      },
                    ),
                  );
                case "String":
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildStyledTextField(
                      label: label,
                      controller: textControllers[label],
                      onChanged: (val) {
                        setState(() {
                          field["value"] = val;
                        });
                      },
                    ),
                  );
                default:
                  return const SizedBox.shrink();
              }
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _savePreferences();
                Provider.of<SaveCardState>(context, listen: false)
                    .addCard(sendSmsCardOutput(fields));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff04bcb0),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required String label,
    String? initialValue,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xff04bcb0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xff04bcb0),
          checkColor: Colors.white,
        ),
      ],
    );
  }
  Widget sendSmsCardOutput(List<Map<String, dynamic>> fields) {
    return Card(
      color: const Color(0xff101f1f),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Send SMS Configuration", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...fields.map((field) {
              final name = field['fieldName'];
              final value = field['value'];
              return Text("$name: $value", style: const TextStyle(color: Colors.white));
            }).toList(),
          ],
        ),
      ),
    );
  }

}
