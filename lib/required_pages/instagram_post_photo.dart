import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust path as needed

class InstagramPostPhotoPage extends StatefulWidget {
  @override
  _InstagramPostPhotoPageState createState() => _InstagramPostPhotoPageState();
}

class _InstagramPostPhotoPageState extends State<InstagramPostPhotoPage> {
  String message = "Instagram Post Photo Test";
  int timeout = 60;
  int photoHeight = 500;
  int photoWidth = 500;
  bool isRandomMessage = true;
  bool isRandomPhoto = false;

  final TextEditingController messageController = TextEditingController();
  final TextEditingController timeoutController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    messageController.dispose();
    timeoutController.dispose();
    heightController.dispose();
    widthController.dispose();
    super.dispose();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      message = prefs.getString('instagram_message') ?? "Instagram Post Photo Test";
      timeout = prefs.getInt('instagram_timeout') ?? 60;
      photoHeight = prefs.getInt('instagram_photo_height') ?? 500;
      photoWidth = prefs.getInt('instagram_photo_width') ?? 500;
      isRandomMessage = prefs.getBool('instagram_is_random_message') ?? true;
      isRandomPhoto = prefs.getBool('instagram_is_random_photo') ?? false;

      messageController.text = message;
      timeoutController.text = timeout.toString();
      heightController.text = photoHeight.toString();
      widthController.text = photoWidth.toString();
    });
  }

  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('instagram_message', message);
    await prefs.setInt('instagram_timeout', timeout);
    await prefs.setInt('instagram_photo_height', photoHeight);
    await prefs.setInt('instagram_photo_width', photoWidth);
    await prefs.setBool('instagram_is_random_message', isRandomMessage);
    await prefs.setBool('instagram_is_random_photo', isRandomPhoto);
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
            _buildCheckbox("Use Random Message", isRandomMessage, (val) {
              setState(() => isRandomMessage = val);
            }),
            _buildCheckbox("Use Random Photo", isRandomPhoto, (val) {
              setState(() => isRandomPhoto = val);
            }),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Message",
              controller: messageController,
              onChanged: (val) => setState(() => message = val),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Timeout (sec)",
              controller: timeoutController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final num = int.tryParse(val);
                if (num != null) setState(() => timeout = num);
              },
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Photo Width",
              controller: widthController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final num = int.tryParse(val);
                if (num != null) setState(() => photoWidth = num);
              },
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Photo Height",
              controller: heightController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                final num = int.tryParse(val);
                if (num != null) setState(() => photoHeight = num);
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences();

                  Provider.of<SaveCardState>(context, listen: false).addCard(
                    photoCardOutput(
                      message: message,
                      timeout: timeout,
                      width: photoWidth,
                      height: photoHeight,
                      isRandomMessage: isRandomMessage,
                      isRandomPhoto: isRandomPhoto,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Post Photo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (val) => onChanged(val ?? false),
          activeColor: const Color(0xff04bcb0),
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
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
        Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

// ✅ Card Output for Post Photo
Widget photoCardOutput({
  required String message,
  required int timeout,
  required int width,
  required int height,
  required bool isRandomMessage,
  required bool isRandomPhoto,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Instagram Post Photo", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Message: $message", style: const TextStyle(color: Colors.white)),
          Text("Timeout: $timeout sec", style: const TextStyle(color: Colors.white)),
          Text("Size: ${width}x$height", style: const TextStyle(color: Colors.white)),
          Text("Random Message: $isRandomMessage", style: const TextStyle(color: Colors.white)),
          Text("Random Photo: $isRandomPhoto", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
