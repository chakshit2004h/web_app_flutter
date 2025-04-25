import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class PausePage extends StatefulWidget {
  @override
  _PausePageState createState() => _PausePageState();
}

class _PausePageState extends State<PausePage> {
  bool pauseRecording = false;
  bool showPrompt = false;
  String tag = "";
  String text = "";
  int timeout = 3600;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved values from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      pauseRecording = prefs.getBool('pauseRecording') ?? false;
      showPrompt = prefs.getBool('showPrompt') ?? false;
      tag = prefs.getString('tag') ?? "";
      text = prefs.getString('text') ?? "";
      timeout = prefs.getInt('timeout') ?? 3600;
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pauseRecording', pauseRecording);
    await prefs.setBool('showPrompt', showPrompt);
    await prefs.setString('tag', tag);
    await prefs.setString('text', text);
    await prefs.setInt('timeout', timeout);
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
              label: "Pause Recording",
              value: pauseRecording,
              onChanged: (val) => setState(() => pauseRecording = val),
            ),
            _buildCustomSwitch(
              label: "Show Prompt",
              value: showPrompt,
              onChanged: (val) => setState(() => showPrompt = val),
            ),
            _buildCustomTextField(
              label: "Tag",
              value: tag,
              onChanged: (val) => setState(() => tag = val),
            ),
            _buildCustomTextField(
              label: "Text",
              value: text,
              onChanged: (val) => setState(() => text = val),
            ),
            _buildCustomSlider(
              label: "Timeout (sec)",
              value: timeout.toDouble(),
              min: 10,
              max: 10000,
              divisions: 100,
              onChanged: (val) => setState(() => timeout = val.toInt()),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(
                    pauseRecording: pauseRecording,
                    showPrompt: showPrompt,
                    tag: tag,
                    text: text,
                    timeout: timeout,
                  ));
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

  Widget _buildCustomSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
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
      ),
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    final controller = TextEditingController(text: value);
    controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: const Color(0xff2a2e33),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: onChanged,
        controller: controller,
      ),
    );
  }

  Widget _buildCustomSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ${value.toInt()}',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.toInt().toString(),
            onChanged: onChanged,
            activeColor: const Color(0xff04bcb0),
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}

// ✅ Card Output Widget
Widget cardOutput({
  required bool pauseRecording,
  required bool showPrompt,
  required String tag,
  required String text,
  required int timeout,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Pause Settings", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pause Recording: ${pauseRecording ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
          Text("Show Prompt: ${showPrompt ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
          Text("Tag: $tag", style: const TextStyle(color: Colors.white)),
          Text("Text: $text", style: const TextStyle(color: Colors.white)),
          Text("Timeout: $timeout sec", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
