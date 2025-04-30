import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path as needed

class OttVideoStreamingMos extends StatefulWidget {
  const OttVideoStreamingMos({super.key});

  @override
  State<OttVideoStreamingMos> createState() => _OttVideoStreamingMosState();
}

class _OttVideoStreamingMosState extends State<OttVideoStreamingMos> {
  int timeout = 60;
  String videoId = "";
  String videoPlayerUrl = "file:///android_asset/video_player/index.html";

  final TextEditingController timeoutController = TextEditingController();
  final TextEditingController videoIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved values from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timeout = prefs.getInt('timeout') ?? 60;
      videoId = prefs.getString('videoId') ?? "";
      timeoutController.text = timeout.toString();
      videoIdController.text = videoId;
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timeout = int.tryParse(timeoutController.text) ?? 60;
      videoId = videoIdController.text;
    });

    await prefs.setInt('timeout', timeout);
    await prefs.setString('videoId', videoId);
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
            _buildCustomTextField(
              label: "Timeout (seconds)",
              controller: timeoutController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Video ID",
              controller: videoIdController,
            ),
            const SizedBox(height: 16),
            _buildReadOnlyInfo(
              label: "Video Player URL",
              content: videoPlayerUrl,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(videoCardOutput(
                    videoInfo: {
                      "timeout": timeout.toString(),
                      "videoId": videoId,
                      "playerUrl": videoPlayerUrl,
                    },
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
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
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
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
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyInfo({
    required String label,
    required String content,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xff2c2f33),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            content,
            style: const TextStyle(color: Colors.blueAccent),
          ),
        ),
      ],
    );
  }
}

// Card Output Widget for Video Settings
Widget videoCardOutput({
  required Map<String, String> videoInfo,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Video Streaming Settings",
          style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Timeout: ${videoInfo['timeout']} seconds",
              style: const TextStyle(color: Colors.white)),
          Text("Video ID: ${videoInfo['videoId']}",
              style: const TextStyle(color: Colors.white)),
          Text("Player URL: ${videoInfo['playerUrl']}",
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}