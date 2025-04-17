import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust path if needed

class UploadVideoPage extends StatefulWidget {
  @override
  _UploadVideoPageState createState() => _UploadVideoPageState();
}

class _UploadVideoPageState extends State<UploadVideoPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeoutController = TextEditingController();
  final TextEditingController _videoUrlController = TextEditingController();

  String title = "";
  String description = "";
  int timeout = 30;
  String videoUrl = "";

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeoutController.dispose();
    _videoUrlController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      title = prefs.getString('video_title') ?? "Test Upload";
      description = prefs.getString('video_description') ?? "Test Upload Description";
      timeout = prefs.getInt('video_timeout') ?? 30;
      videoUrl = prefs.getString('video_url') ?? "https://files.azenqos.com/temp/10mb.mp4";

      _titleController.text = title;
      _descriptionController.text = description;
      _timeoutController.text = timeout.toString();
      _videoUrlController.text = videoUrl;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('video_title', title);
    await prefs.setString('video_description', description);
    await prefs.setInt('video_timeout', timeout);
    await prefs.setString('video_url', videoUrl);
  }

  void _handleSave() {
    setState(() {
      title = _titleController.text.trim();
      description = _descriptionController.text.trim();
      timeout = int.tryParse(_timeoutController.text.trim()) ?? 30;
      videoUrl = _videoUrlController.text.trim();
    });

    _savePreferences();

    // Save to provider state
    Provider.of<SaveCardState>(context, listen: false).addCard(
      videoCardOutput(
        title: title,
        description: description,
        timeout: timeout,
        videoUrl: videoUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: 300,
      padding: const EdgeInsets.all(16),
      color: const Color(0xff1a1e22),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomTextField(label: "Video Title", controller: _titleController),
            const SizedBox(height: 16),
            _buildCustomTextField(label: "Video Description", controller: _descriptionController),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Timeout (seconds)",
              controller: _timeoutController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(label: "Video URL", controller: _videoUrlController),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.save, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Save Video',
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
  Widget videoCardOutput({
    required String title,
    required String description,
    required int timeout,
    required String videoUrl,
  }) {
    return Card(
      color: const Color(0xff101f1f),
      elevation: 5,
      child: ListTile(
        title: const Text("Video Upload", style: TextStyle(color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title: $title", style: const TextStyle(color: Colors.white)),
            Text("Description: $description", style: const TextStyle(color: Colors.white)),
            Text("Timeout: $timeout seconds", style: const TextStyle(color: Colors.white)),
            Text("Video URL: $videoUrl", style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

}
