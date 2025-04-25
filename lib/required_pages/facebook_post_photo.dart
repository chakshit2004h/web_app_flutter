import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Update path if needed

class FacebookPostPhotoPage extends StatefulWidget {
  @override
  _FacebookPostPhotoPageState createState() => _FacebookPostPhotoPageState();
}

class _FacebookPostPhotoPageState extends State<FacebookPostPhotoPage> {
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _postTimeoutController = TextEditingController();
  final TextEditingController _sourcePhotoUrlController = TextEditingController();
  bool _isRandomPhoto = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _captionController.text = prefs.getString('fb_caption') ?? '';
      _postTimeoutController.text = prefs.getString('fb_timeout') ?? '60';
      _sourcePhotoUrlController.text =
          prefs.getString('fb_photo_url') ?? 'https://files.azenqos.com/temp/500kb.jpg';
      _isRandomPhoto = prefs.getBool('fb_is_random') ?? true;
    });
  }

  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fb_caption', _captionController.text);
    await prefs.setString('fb_timeout', _postTimeoutController.text);
    await prefs.setString('fb_photo_url', _sourcePhotoUrlController.text);
    await prefs.setBool('fb_is_random', _isRandomPhoto);
  }

  void _submitForm() {
    _savePreferences();

    Map<String, String> fbInfo = {
      "caption": _captionController.text,
      "isRandomPhoto": _isRandomPhoto.toString(),
      "postTimeout": _postTimeoutController.text,
      "sourcePhotoUrl": _sourcePhotoUrlController.text,
    };

    // Add to provider
    Provider.of<SaveCardState>(context, listen: false).addCard(cardOutputFacebook(fbInfo: fbInfo));
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
              controller: _captionController,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Is Random Photo:',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: _isRandomPhoto,
                  activeColor: const Color(0xff04bcb0),
                  onChanged: (value) {
                    setState(() {
                      _isRandomPhoto = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Post Timeout (seconds)",
              controller: _postTimeoutController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Source Photo URL",
              controller: _sourcePhotoUrlController,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _submitForm,
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
  Widget cardOutputFacebook({
    required Map<String, String> fbInfo,
  }) {
    return Card(
      color: const Color(0xff101f1f),
      elevation: 5,
      child: ListTile(
        title: const Text("Facebook Post Info", style: TextStyle(color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: fbInfo.entries.map((entry) {
            return Text("${entry.key}: ${entry.value}", style: const TextStyle(color: Colors.white));
          }).toList(),
        ),
      ),
    );
  }

}
