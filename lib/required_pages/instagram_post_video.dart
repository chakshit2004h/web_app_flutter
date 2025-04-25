import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class InstagramPostVideoPage extends StatefulWidget {
  const InstagramPostVideoPage({super.key});

  @override
  State<InstagramPostVideoPage> createState() => _InstagramPostVideoPageState();
}

class _InstagramPostVideoPageState extends State<InstagramPostVideoPage> {
  bool isRandomMessage = true;
  bool useRandomMessageCheckBox = false;
  String message = "Instagram Post Video Test";
  int timeout = 60;
  String videoUrl = "https://files.azenqos.com/temp/1mb.mp4";

  final TextEditingController messageController = TextEditingController();
  final TextEditingController videoUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    messageController.dispose();
    videoUrlController.dispose();
    super.dispose();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isRandomMessage = prefs.getBool('isRandomMessage') ?? true;
      useRandomMessageCheckBox = prefs.getBool('useRandomMessageCheckBox') ?? false;
      message = prefs.getString('message') ?? "Instagram Post Video Test";
      timeout = prefs.getInt('timeout') ?? 60;
      videoUrl = prefs.getString('videoUrl') ?? "https://files.azenqos.com/temp/1mb.mp4";
      messageController.text = message;
      videoUrlController.text = videoUrl;
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRandomMessage', isRandomMessage);
    await prefs.setBool('useRandomMessageCheckBox', useRandomMessageCheckBox);
    await prefs.setString('message', message);
    await prefs.setInt('timeout', timeout);
    await prefs.setString('videoUrl', videoUrl);
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
              label: "Is Random Message",
              value: isRandomMessage,
              onChanged: (val) => setState(() => isRandomMessage = val),
            ),
            _buildTextInput(
              label: "Message",
              controller: messageController,
              onChanged: (val) => setState(() => message = val),
            ),
            _buildSlider(
              label: "Timeout (sec)",
              value: timeout.toDouble(),
              min: 1,
              max: 3600,
              divisions: 60,
              onChanged: (val) => setState(() => timeout = val.toInt()),
            ),
            _buildCustomSwitch(
              label: "Use Random Message",
              value: useRandomMessageCheckBox,
              onChanged: (val) => setState(() => useRandomMessageCheckBox = val),
            ),
            _buildTextInput(
              label: "Video URL",
              controller: videoUrlController,
              onChanged: (val) => setState(() => videoUrl = val),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(
                    message: message,
                    timeout: timeout,
                    videoUrl: videoUrl,
                    isRandomMessage: isRandomMessage,
                    useRandomMessageCheckBox: useRandomMessageCheckBox,
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

  Widget _buildSlider({
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

  Widget _buildTextInput({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white24),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xff04bcb0)),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// ✅ Card Output Widget
Widget cardOutput({
  required String message,
  required int timeout,
  required String videoUrl,
  required bool isRandomMessage,
  required bool useRandomMessageCheckBox,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Instagram Post Video", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Message: $message", style: const TextStyle(color: Colors.white)),
          Text("Timeout: $timeout seconds", style: const TextStyle(color: Colors.white)),
          Text("Video URL: $videoUrl", style: const TextStyle(color: Colors.white)),
          Text("Is Random Message: ${isRandomMessage ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
          Text("Use Random Message: ${useRandomMessageCheckBox ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
