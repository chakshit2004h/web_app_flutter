import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust the path accordingly

class LineSendPage extends StatefulWidget {
  const LineSendPage({super.key});

  @override
  State<LineSendPage> createState() => _LineSendConfigPageState();
}

class _LineSendConfigPageState extends State<LineSendPage> {
  Map<String, dynamic> lineConfig = {
    "message": "LINE Message Test",
    "lineMode": 0,
    "photoMode": -1,
    "sendIdentifyText": false,
    "sourcePhotoUrl": "",
    "sourceVideoUrl": "https://files.azenqos.com/temp/1mb.mp4",
    "sourceVoiceUrl": "https://files.azenqos.com/temp/polqaref.wav",
    "stickerNumber": 1,
    "noiseImageHeight": 1280.0,
    "noiseImageWidth": 1280.0,
  };

  late TextEditingController messageController;

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
    _loadPreferences();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      lineConfig["message"] = prefs.getString("message") ?? lineConfig["message"];
      lineConfig["lineMode"] = prefs.getInt("lineMode") ?? 0;
      lineConfig["photoMode"] = prefs.getInt("photoMode") ?? -1;
      lineConfig["sendIdentifyText"] = prefs.getBool("sendIdentifyText") ?? false;
      lineConfig["sourcePhotoUrl"] = prefs.getString("sourcePhotoUrl") ?? "";
      lineConfig["sourceVideoUrl"] = prefs.getString("sourceVideoUrl") ?? lineConfig["sourceVideoUrl"];
      lineConfig["sourceVoiceUrl"] = prefs.getString("sourceVoiceUrl") ?? lineConfig["sourceVoiceUrl"];
      lineConfig["stickerNumber"] = prefs.getInt("stickerNumber") ?? 1;
      lineConfig["noiseImageHeight"] = prefs.getDouble("noiseImageHeight") ?? 1280.0;
      lineConfig["noiseImageWidth"] = prefs.getDouble("noiseImageWidth") ?? 1280.0;
      messageController.text = lineConfig["message"];
    });
  }

  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("message", lineConfig["message"]);
    prefs.setInt("lineMode", lineConfig["lineMode"]);
    prefs.setInt("photoMode", lineConfig["photoMode"]);
    prefs.setBool("sendIdentifyText", lineConfig["sendIdentifyText"]);
    prefs.setString("sourcePhotoUrl", lineConfig["sourcePhotoUrl"]);
    prefs.setString("sourceVideoUrl", lineConfig["sourceVideoUrl"]);
    prefs.setString("sourceVoiceUrl", lineConfig["sourceVoiceUrl"]);
    prefs.setInt("stickerNumber", lineConfig["stickerNumber"]);
    prefs.setDouble("noiseImageHeight", lineConfig["noiseImageHeight"]);
    prefs.setDouble("noiseImageWidth", lineConfig["noiseImageWidth"]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: const Color(0xff1a1e22),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              label: "Message",
              controller: messageController,
              onChanged: (val) => lineConfig["message"] = val,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              value: lineConfig["lineMode"],
              dropdownColor: Colors.grey[900],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Select Line Mode",
              ),
              onChanged: (val) => setState(() => lineConfig["lineMode"] = val!),
              items: const [
                DropdownMenuItem(value: 0, child: Text("Message Mode")),
                DropdownMenuItem(value: 1, child: Text("Sticker Mode")),
                DropdownMenuItem(value: 2, child: Text("Photo Mode")),
                DropdownMenuItem(value: 3, child: Text("Video Mode")),
                DropdownMenuItem(value: 4, child: Text("Voice Mode")),
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              activeColor: const Color(0xff04bcb0),
              title: const Text("Send Identify Text", style: TextStyle(color: Colors.white)),
              value: lineConfig["sendIdentifyText"],
              onChanged: (val) => setState(() => lineConfig["sendIdentifyText"] = val!),
            ),
            const SizedBox(height: 16),
            const Text("Select Photo Mode:", style: TextStyle(color: Colors.white)),
            Row(
              children: [
                _buildRadioOption("Predefined", 0),
                _buildRadioOption("URL", 1),
                _buildRadioOption("Noise", 2),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: "Source Photo URL",
              initialValue: lineConfig["sourcePhotoUrl"],
              onChanged: (val) => lineConfig["sourcePhotoUrl"] = val,
            ),
            _buildTextField(
              label: "Source Video URL",
              initialValue: lineConfig["sourceVideoUrl"],
              onChanged: (val) => lineConfig["sourceVideoUrl"] = val,
            ),
            _buildTextField(
              label: "Source Voice URL",
              initialValue: lineConfig["sourceVoiceUrl"],
              onChanged: (val) => lineConfig["sourceVoiceUrl"] = val,
            ),
            _buildTextField(
              label: "Sticker Number",
              initialValue: lineConfig["stickerNumber"].toString(),
              keyboardType: TextInputType.number,
              onChanged: (val) => lineConfig["stickerNumber"] = int.tryParse(val) ?? 1,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: "Noise Height",
                    initialValue: lineConfig["noiseImageHeight"].toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => lineConfig["noiseImageHeight"] = double.tryParse(val) ?? 1280.0,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: "Noise Width",
                    initialValue: lineConfig["noiseImageWidth"].toString(),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => lineConfig["noiseImageWidth"] = double.tryParse(val) ?? 1280.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences();
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(cellInfo: lineConfig.map((k, v) => MapEntry(k, v.toString()))));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.send, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Send Message',
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

  Widget _buildTextField({
    required String label,
    String? initialValue,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller ?? TextEditingController(text: initialValue),
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title, int value) {
    return Row(
      children: [
        Radio<int>(
          value: value,
          groupValue: lineConfig["photoMode"],
          onChanged: (val) => setState(() => lineConfig["photoMode"] = val!),
          activeColor: const Color(0xff04bcb0),
        ),
        Text(title, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
class cardOutput extends StatelessWidget {
  final Map<String, String> cellInfo;

  const cardOutput({Key? key, required this.cellInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff101f1f),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Line Send',
              style: TextStyle(
                color: Color(0xff04bcb0),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white24),
            ...cellInfo.entries.map(
                  (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        "${entry.key.toUpperCase()}:",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}