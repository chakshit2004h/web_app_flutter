import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class FacebookPostVideo extends StatefulWidget {
  @override
  _FacebookPostVideoState createState() => _FacebookPostVideoState();
}

class _FacebookPostVideoState extends State<FacebookPostVideo> {
  String caption = "";
  int postTimeout = 60;
  String sourceVideoUrl = "https://files.azenqos.com/temp/1mb.mp4";

  TextEditingController captionController = TextEditingController();
  TextEditingController postTimeoutController = TextEditingController();
  late VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _videoController = VideoPlayerController.network(sourceVideoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    captionController.dispose();
    postTimeoutController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      caption = prefs.getString('facebook_caption') ?? "";
      postTimeout = prefs.getInt('facebook_postTimeout') ?? 60;
      captionController.text = caption;
      postTimeoutController.text = postTimeout.toString();
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('facebook_caption', caption);
    await prefs.setInt('facebook_postTimeout', postTimeout);
  }

  // Update values in state and save to preferences
  void updateValues() {
    setState(() {
      caption = captionController.text;
      postTimeout = int.tryParse(postTimeoutController.text) ?? 60;
    });
    _savePreferences(); // Save to shared preferences

    // Add to Provider state for saving the script card
    Provider.of<SaveCardState>(context, listen: false)
        .addCard(scriptCardOutput(caption: caption, postTimeout: postTimeout));
  }

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[850],
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xff04bcb0)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
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
              label: "Caption",
              controller: captionController,
            ),
            _buildCustomTextField(
              label: "Post Timeout (seconds)",
              controller: postTimeoutController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const Text(
              "Source Video URL",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              sourceVideoUrl,
              style: const TextStyle(color: Colors.blueAccent, fontSize: 12),
            ),
            const SizedBox(height: 20),
            _videoController.value.isInitialized
                ? AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: VideoPlayer(_videoController),
            )
                : const Center(
              child: CircularProgressIndicator(color: Color(0xff04bcb0)),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _videoController.value.isPlaying
                        ? _videoController.pause()
                        : _videoController.play();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _videoController.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: const Color(0xff04bcb0),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _videoController.value.isPlaying ? "Pause Video" : "Play Video",
                      style: const TextStyle(
                        color: Color(0xff04bcb0),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: updateValues,
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
}

// ✅ Card Output Widget
Widget scriptCardOutput({
  required String caption,
  required int postTimeout,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Facebook Post", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Caption: $caption", style: const TextStyle(color: Colors.white)),
          Text("Post Timeout: $postTimeout seconds", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
