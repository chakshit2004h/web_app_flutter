import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class SetLogStatementPage extends StatefulWidget {
  const SetLogStatementPage({super.key});

  @override
  State<SetLogStatementPage> createState() => _SetLogStatementPageState();
}

class _SetLogStatementPageState extends State<SetLogStatementPage> {
  TextEditingController serverController = TextEditingController();
  TextEditingController adapterController = TextEditingController(text: "AllowedMnnMncListItem");
  TextEditingController bindingController = TextEditingController(text: "StatementSetLogServerBinding");
  TextEditingController mccMncController = TextEditingController();
  List<String> allowedMccMnc = [];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverController.text = prefs.getString('server') ?? '';
      adapterController.text = prefs.getString('adapter') ?? 'AllowedMnnMncListItem';
      bindingController.text = prefs.getString('binding') ?? 'StatementSetLogServerBinding';
      allowedMccMnc = prefs.getStringList('allowedMccMnc') ?? [];
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('server', serverController.text);
    prefs.setString('adapter', adapterController.text);
    prefs.setString('binding', bindingController.text);
    prefs.setStringList('allowedMccMnc', allowedMccMnc);
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
            _buildCustomTextField(label: "Adapter", controller: adapterController),
            const SizedBox(height: 16),
            _buildCustomTextField(label: "Allowed MCC MNC", controller: mccMncController),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (mccMncController.text.isNotEmpty) {
                      allowedMccMnc.add(mccMncController.text.trim());
                      mccMncController.clear();
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Add MCC MNC", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),
            if (allowedMccMnc.isEmpty)
              const Text('No MCC MNC added', style: TextStyle(color: Colors.grey))
            else
              Column(
                children: allowedMccMnc.map((mcc) => Card(
                  color: const Color(0xff2c2f33),
                  elevation: 2,
                  child: ListTile(
                    title: Text(mcc, style: const TextStyle(color: Colors.white)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.orangeAccent),
                      onPressed: () {
                        setState(() {
                          allowedMccMnc.remove(mcc);
                        });
                      },
                    ),
                  ),
                )).toList(),
              ),
            const SizedBox(height: 16),
            _buildCustomTextField(label: "Binding", controller: bindingController),
            const SizedBox(height: 16),
            _buildCustomTextField(label: "Server", controller: serverController),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(cellInfo: {
                    "server": serverController.text,
                    "adapter": adapterController.text,
                    "binding": bindingController.text,
                    "allowedMccMnc": allowedMccMnc.join(", ")
                  }));
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
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
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
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xff04bcb0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
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
      title: const Text("Log Statement Info", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Server: ${cellInfo['server']}", style: const TextStyle(color: Colors.white)),
          Text("Adapter: ${cellInfo['adapter']}", style: const TextStyle(color: Colors.white)),
          Text("Binding: ${cellInfo['binding']}", style: const TextStyle(color: Colors.white)),
          Text("Allowed MCC MNC: ${cellInfo['allowedMccMnc']}", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
