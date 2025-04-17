import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class PlayFacebookVideoPage extends StatefulWidget {
  @override
  _PlayFacebookVideoPageState createState() => _PlayFacebookVideoPageState();
}

class _PlayFacebookVideoPageState extends State<PlayFacebookVideoPage> {
  int timeout = 670;
  String url = "https://www.facebook.com/watch/?v=356120718964264";

  late TextEditingController timeoutController;
  late TextEditingController urlController;

  @override
  void initState() {
    super.initState();
    timeoutController = TextEditingController(text: timeout.toString());
    urlController = TextEditingController(text: url);
    _loadPreferences();
  }

  @override
  void dispose() {
    timeoutController.dispose();
    urlController.dispose();
    super.dispose();
  }

  // Load saved values from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timeout = prefs.getInt('facebook_timeout') ?? 670;
      url = prefs.getString('facebook_url') ?? "https://www.facebook.com/watch/?v=356120718964264";
      timeoutController.text = timeout.toString();
      urlController.text = url;
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('facebook_timeout', timeout);
    await prefs.setString('facebook_url', url);
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
              label: "Timeout (ms)",
              controller: timeoutController,
              onChanged: (val) => setState(() => timeout = int.tryParse(val) ?? timeout),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Video URL",
              controller: urlController,
              onChanged: (val) => setState(() => url = val),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to SharedPreferences

                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(timeout: timeout, url: url));
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
    required ValueChanged<String> onChanged,
    int maxLines = 1,
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
          onChanged: onChanged,
          maxLines: maxLines,
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
  required int timeout,
  required String url,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Facebook Video Config", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Timeout: $timeout ms", style: const TextStyle(color: Colors.white)),
          Text("Video URL: $url", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
