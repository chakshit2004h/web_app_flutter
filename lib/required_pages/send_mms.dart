import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../addon/provider.dart'; // Adjust this path as needed

class SendMmsPage extends StatefulWidget {
  const SendMmsPage({super.key});

  @override
  State<SendMmsPage> createState() => _SendMmsPageState();
}

class _SendMmsPageState extends State<SendMmsPage> {
  int dataUploadTimeout = 45;
  String image = "";
  String message = "";
  String phoneNumber = "";
  int selectedImageMode = 3;

  final TextEditingController _timeoutController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  final List<String> imageModes = [
    'IMG_MODE_CUSTOM',
    'IMG_MODE_30KB',
    'IMG_MODE_90KB',
    'IMG_MODE_300KB'
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    _timeoutController.dispose();
    _phoneNumberController.dispose();
    _messageController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dataUploadTimeout = prefs.getInt('mms_timeout') ?? 45;
      phoneNumber = prefs.getString('mms_phoneNumber') ?? "";
      message = prefs.getString('mms_message') ?? "";
      image = prefs.getString('mms_image') ?? "";
      selectedImageMode = prefs.getInt('mms_imageMode') ?? 3;

      _timeoutController.text = dataUploadTimeout.toString();
      _phoneNumberController.text = phoneNumber;
      _messageController.text = message;
      _imageController.text = image;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mms_timeout', dataUploadTimeout);
    await prefs.setString('mms_phoneNumber', phoneNumber);
    await prefs.setString('mms_message', message);
    await prefs.setString('mms_image', image);
    await prefs.setInt('mms_imageMode', selectedImageMode);
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
              label: "Phone Number",
              controller: _phoneNumberController,
              onChanged: (val) => phoneNumber = val,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Message",
              controller: _messageController,
              onChanged: (val) => message = val,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Image URL (optional)",
              controller: _imageController,
              onChanged: (val) => image = val,
            ),
            const SizedBox(height: 16),
            Text(
              "Image Mode",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xff2c2f33),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<int>(
                value: selectedImageMode,
                dropdownColor: const Color(0xff2c2f33),
                isExpanded: true,
                underline: const SizedBox(),
                iconEnabledColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                items: List.generate(
                  imageModes.length,
                      (index) => DropdownMenuItem(
                    value: index,
                    child: Text(imageModes[index]),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedImageMode = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Timeout (seconds)",
              controller: _timeoutController,
              keyboardType: TextInputType.number,
              onChanged: (val) {
                dataUploadTimeout = int.tryParse(val) ?? 45;
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences();
                  Provider.of<SaveCardState>(context, listen: false).addCard(
                    mmsCardOutput(
                      phoneNumber: phoneNumber,
                      message: message,
                      image: image,
                      selectedImageMode: imageModes[selectedImageMode],
                      timeout: dataUploadTimeout,
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
    int maxLines = 1,
    void Function(String)? onChanged,
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
          keyboardType: keyboardType,
          maxLines: maxLines,
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
Widget mmsCardOutput({
  required String phoneNumber,
  required String message,
  required String image,
  required String selectedImageMode,
  required int timeout,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("MMS Configuration", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Phone: $phoneNumber", style: const TextStyle(color: Colors.white)),
          Text("Message: $message", style: const TextStyle(color: Colors.white)),
          Text("Image URL: ${image.isEmpty ? 'None' : image}", style: const TextStyle(color: Colors.white)),
          Text("Image Mode: $selectedImageMode", style: const TextStyle(color: Colors.white)),
          Text("Timeout: $timeout sec", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
