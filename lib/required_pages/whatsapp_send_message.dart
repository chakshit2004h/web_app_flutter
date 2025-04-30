import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // adjust import if needed

class WhatsAppMessageSettingsPage extends StatefulWidget {
  @override
  _WhatsAppMessageSettingsPageState createState() => _WhatsAppMessageSettingsPageState();
}

class _WhatsAppMessageSettingsPageState extends State<WhatsAppMessageSettingsPage> {
  bool isRandomMessage = true;
  bool isRandomPhoto = false;
  int photoHeight = 500;
  int photoWidth = 500;
  int timeout = 60;
  int postPhotoMode = 0;
  String message = "WhatsApp Message Test";
  String phoneNumber = "";

  final TextEditingController messageController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController photoHeightController = TextEditingController();
  final TextEditingController photoWidthController = TextEditingController();
  final TextEditingController timeoutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isRandomMessage = prefs.getBool('whatsapp_randomMessage') ?? true;
      isRandomPhoto = prefs.getBool('whatsapp_randomPhoto') ?? false;
      photoHeight = prefs.getInt('whatsapp_photoHeight') ?? 500;
      photoWidth = prefs.getInt('whatsapp_photoWidth') ?? 500;
      timeout = prefs.getInt('whatsapp_timeout') ?? 60;
      postPhotoMode = prefs.getInt('whatsapp_postPhotoMode') ?? 0;
      message = prefs.getString('whatsapp_message') ?? "WhatsApp Message Test";
      phoneNumber = prefs.getString('whatsapp_phoneNumber') ?? "";

      messageController.text = message;
      phoneNumberController.text = phoneNumber;
      photoHeightController.text = photoHeight.toString();
      photoWidthController.text = photoWidth.toString();
      timeoutController.text = timeout.toString();
    });
  }

  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('whatsapp_randomMessage', isRandomMessage);
    await prefs.setBool('whatsapp_randomPhoto', isRandomPhoto);
    await prefs.setInt('whatsapp_photoHeight', photoHeight);
    await prefs.setInt('whatsapp_photoWidth', photoWidth);
    await prefs.setInt('whatsapp_timeout', timeout);
    await prefs.setInt('whatsapp_postPhotoMode', postPhotoMode);
    await prefs.setString('whatsapp_message', message);
    await prefs.setString('whatsapp_phoneNumber', phoneNumber);
  }

  @override
  void dispose() {
    messageController.dispose();
    phoneNumberController.dispose();
    photoHeightController.dispose();
    photoWidthController.dispose();
    timeoutController.dispose();
    super.dispose();
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
            _buildSwitchField("Random Message", isRandomMessage, (val) {
              setState(() => isRandomMessage = val);
            }),
            const SizedBox(height: 12),
            _buildSwitchField("Random Photo", isRandomPhoto, (val) {
              setState(() => isRandomPhoto = val);
            }),
            const SizedBox(height: 16),
            _buildTextField("Message", messageController),
            const SizedBox(height: 16),
            _buildTextField("Phone Number", phoneNumberController, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField("Photo Height", photoHeightController, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField("Photo Width", photoWidthController, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildTextField("Timeout (seconds)", timeoutController, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            _buildRadioGroup(),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    message = messageController.text;
                    phoneNumber = phoneNumberController.text;
                    photoHeight = int.tryParse(photoHeightController.text) ?? 500;
                    photoWidth = int.tryParse(photoWidthController.text) ?? 500;
                    timeout = int.tryParse(timeoutController.text) ?? 60;
                  });

                  _savePreferences();

                  Provider.of<SaveCardState>(context, listen: false).addCard(
                    whatsappCardOutput(
                      isRandomMessage: isRandomMessage,
                      isRandomPhoto: isRandomPhoto,
                      message: message,
                      phoneNumber: phoneNumber,
                      photoHeight: photoHeight,
                      photoWidth: photoWidth,
                      timeout: timeout,
                      postPhotoMode: postPhotoMode,
                    ),
                  );
                },
                child: const Text('Save', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchField(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Switch(
          activeColor: const Color(0xff04bcb0),
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff2c2f33),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioGroup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Post Photo Mode", style: TextStyle(color: Colors.white)),
        Row(
          children: [
            _buildRadio("Don't Post", 0),
            _buildRadio("Preset", 1),
            _buildRadio("Generate", 2),
          ],
        ),
      ],
    );
  }

  Widget _buildRadio(String label, int value) {
    return Row(
      children: [
        Radio<int>(
          activeColor: const Color(0xff04bcb0),
          value: value,
          groupValue: postPhotoMode,
          onChanged: (val) => setState(() => postPhotoMode = val!),
        ),
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(width: 1),
      ],
    );
  }
  Widget whatsappCardOutput({
    required bool isRandomMessage,
    required bool isRandomPhoto,
    required String message,
    required String phoneNumber,
    required int photoHeight,
    required int photoWidth,
    required int timeout,
    required int postPhotoMode,
  }) {
    return Card(
      color: Color(0xff101f1f),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Message: $message", style: const TextStyle(color: Colors.white)),
            Text("Phone Number: $phoneNumber", style: const TextStyle(color: Colors.white)),
            Text("Random Msg: $isRandomMessage", style: const TextStyle(color: Colors.white)),
            Text("Random Photo: $isRandomPhoto", style: const TextStyle(color: Colors.white)),
            Text("Photo Size: ${photoHeight}x$photoWidth", style: const TextStyle(color: Colors.white)),
            Text("Timeout: $timeout", style: const TextStyle(color: Colors.white)),
            Text("Post Photo Mode: $postPhotoMode", style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

}
