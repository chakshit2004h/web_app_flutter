import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class OttVideoStreamingMosPage extends StatefulWidget {
  const OttVideoStreamingMosPage({super.key});

  @override
  State<OttVideoStreamingMosPage> createState() => _OttVideoStreamingMosPageState();
}

class _OttVideoStreamingMosPageState extends State<OttVideoStreamingMosPage> {
  int timeout = 60;
  String videoId = "";
  bool takeScreenshotWhenDone = false;

  final TextEditingController timeoutController = TextEditingController();
  final TextEditingController videoIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    timeoutController.dispose();
    videoIdController.dispose();
    super.dispose();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timeout = prefs.getInt('ott_timeout') ?? 60;
      videoId = prefs.getString('ott_videoId') ?? '';
      takeScreenshotWhenDone = prefs.getBool('ott_takeScreenshotWhenDone') ?? false;
      timeoutController.text = timeout.toString();
      videoIdController.text = videoId;
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ott_timeout', timeout);
    await prefs.setString('ott_videoId', videoId);
    await prefs.setBool('ott_takeScreenshotWhenDone', takeScreenshotWhenDone);
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
          _buildNumberField(
            label: 'Timeout (seconds)',
            controller: timeoutController,
            onChanged: (val) {
              final num = int.tryParse(val);
              if (num != null) {
                setState(() => timeout = num);
              }
            },
          ),
          const SizedBox(height: 20),
          _buildTextField(
            label: 'Video ID',
            controller: videoIdController,
            onChanged: (val) {
              setState(() => videoId = val);
            },
          ),
          const SizedBox(height: 20),
          _buildCustomSwitch(
            label: 'Take Screenshot When Done',
            value: takeScreenshotWhenDone,
            onChanged: (val) {
              setState(() => takeScreenshotWhenDone = val);
            },
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _savePreferences(); // Save to shared preferences

                // Add to Provider state
                Provider.of<SaveCardState>(context, listen: false)
                    .addCard(ottCardOutput(timeout: timeout, videoId: videoId, takeScreenshotWhenDone: takeScreenshotWhenDone));
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

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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

// ✅ Card Output Widget
Widget ottCardOutput({
  required int timeout,
  required String videoId,
  required bool takeScreenshotWhenDone,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("OTT Video Streaming", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Timeout: $timeout seconds", style: const TextStyle(color: Colors.white)),
          Text("Video ID: $videoId", style: const TextStyle(color: Colors.white)),
          Text("Take Screenshot When Done: ${takeScreenshotWhenDone ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}

