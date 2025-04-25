import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Import the SaveCardState file

class VoiceFtpUpload extends StatefulWidget {
  const VoiceFtpUpload({super.key});

  @override
  State<VoiceFtpUpload> createState() => _VoiceFtpUploadState();
}

class _VoiceFtpUploadState extends State<VoiceFtpUpload> {
  int answerTimeout = 60;
  int duration = 60;
  String filesizeStr = "5mb";
  int inactivityTimeout = 600;
  String ip = "blr.azenqos.com";
  String password = "qazwsx123";
  String phoneNumber = "";
  int sessionCount = 1;
  bool stopAtVoiceEnd = true;
  int timeoutData = 1200;
  int timeoutVoice = 45;
  String username = "tester";

  @override
  void initState() {
    super.initState();
    _loadPreferences();  // Load preferences when the widget is created
  }

  // Load preferences from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      answerTimeout = prefs.getInt('answerTimeout') ?? 60;
      duration = prefs.getInt('duration') ?? 60;
      filesizeStr = prefs.getString('filesizeStr') ?? "5mb";
      inactivityTimeout = prefs.getInt('inactivityTimeout') ?? 600;
      ip = prefs.getString('ip') ?? "blr.azenqos.com";
      password = prefs.getString('password') ?? "qazwsx123";
      phoneNumber = prefs.getString('phoneNumber') ?? "";
      sessionCount = prefs.getInt('sessionCount') ?? 1;
      stopAtVoiceEnd = prefs.getBool('stopAtVoiceEnd') ?? true;
      timeoutData = prefs.getInt('timeoutData') ?? 1200;
      timeoutVoice = prefs.getInt('timeoutVoice') ?? 45;
      username = prefs.getString('username') ?? "tester";
    });
  }

  // Save preferences to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('answerTimeout', answerTimeout);
    await prefs.setInt('duration', duration);
    await prefs.setString('filesizeStr', filesizeStr);
    await prefs.setInt('inactivityTimeout', inactivityTimeout);
    await prefs.setString('ip', ip);
    await prefs.setString('password', password);
    await prefs.setString('phoneNumber', phoneNumber);
    await prefs.setInt('sessionCount', sessionCount);
    await prefs.setBool('stopAtVoiceEnd', stopAtVoiceEnd);
    await prefs.setInt('timeoutData', timeoutData);
    await prefs.setInt('timeoutVoice', timeoutVoice);
    await prefs.setString('username', username);
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
            buildNumberField("Answer Timeout", answerTimeout, (val) {
              setState(() => answerTimeout = val);
              _savePreferences();  // Save the updated value
            }),
            buildNumberField("Duration", duration, (val) {
              setState(() => duration = val);
              _savePreferences();  // Save the updated value
            }),
            buildTextField("File Size", filesizeStr, (val) {
              setState(() => filesizeStr = val);
              _savePreferences();  // Save the updated value
            }),
            buildNumberField("Inactivity Timeout", inactivityTimeout, (val) {
              setState(() => inactivityTimeout = val);
              _savePreferences();  // Save the updated value
            }),
            buildTextField("IP", ip, (val) {
              setState(() => ip = val);
              _savePreferences();  // Save the updated value
            }),
            buildTextField("Password", password, (val) {
              setState(() => password = val);
              _savePreferences();  // Save the updated value
            }),
            buildTextField("Phone Number", phoneNumber, (val) {
              setState(() => phoneNumber = val);
              _savePreferences();  // Save the updated value
            }),
            buildNumberField("Session Count", sessionCount, (val) {
              setState(() => sessionCount = val);
              _savePreferences();  // Save the updated value
            }),
            buildCustomSwitch("Stop at Voice End", stopAtVoiceEnd, (val) {
              setState(() => stopAtVoiceEnd = val);
              _savePreferences();  // Save the updated value
            }),
            buildNumberField("Timeout Data", timeoutData, (val) {
              setState(() => timeoutData = val);
              _savePreferences();  // Save the updated value
            }),
            buildNumberField("Timeout Voice", timeoutVoice, (val) {
              setState(() => timeoutVoice = val);
              _savePreferences();  // Save the updated value
            }),
            buildTextField("Username", username, (val) {
              setState(() => username = val);
              _savePreferences();  // Save the updated value
            }),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save to global state when saving
                setState(() {
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(
                    answerTimeout: answerTimeout,
                    duration: duration,
                    filesizeStr: filesizeStr,
                    inactivityTimeout: inactivityTimeout,
                    ip: ip,
                    password: password,
                    phoneNumber: phoneNumber,
                    sessionCount: sessionCount,
                    stopAtVoiceEnd: stopAtVoiceEnd,
                    timeoutData: timeoutData,
                    timeoutVoice: timeoutVoice,
                    username: username,
                  ));
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff04bcb0),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                shadowColor: Colors.black.withOpacity(0.2),
                elevation: 5,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String value, Function(String) onChanged) {
    TextEditingController controller = TextEditingController(text: value);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            onChanged: onChanged,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black12,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.tealAccent),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNumberField(String label, int value, Function(int) onChanged) {
    TextEditingController controller = TextEditingController(text: value.toString());
    return buildTextField(label, controller.text, (val) {
      int? parsed = int.tryParse(val);
      if (parsed != null) onChanged(parsed);
    });
  }

  Widget buildCustomSwitch(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Transform.scale(
            scale: 0.8, // Adjust this value to make the switch smaller or larger
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.tealAccent,
            ),
          ),
        ],
      ),
    );
  }


  Widget cardOutput({
    required int answerTimeout,
    required int duration,
    required String filesizeStr,
    required int inactivityTimeout,
    required String ip,
    required String password,
    required String phoneNumber,
    required int sessionCount,
    required bool stopAtVoiceEnd,
    required int timeoutData,
    required int timeoutVoice,
    required String username,
  }) {
    return Card(
      color: const Color(0xff101f1f),
      elevation: 5,
      child: ListTile(
        title: const Text(
          "Voice FTP Upload",
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Answer Timeout: $answerTimeout", style: const TextStyle(color: Colors.white)),
            Text("Duration: $duration", style: const TextStyle(color: Colors.white)),
            Text("File Size: $filesizeStr", style: const TextStyle(color: Colors.white)),
            Text("Inactivity Timeout: $inactivityTimeout", style: const TextStyle(color: Colors.white)),
            Text("IP: $ip", style: const TextStyle(color: Colors.white)),
            Text("Username: $username", style: const TextStyle(color: Colors.white)),
            Text("Stop at Voice End: ${stopAtVoiceEnd ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
