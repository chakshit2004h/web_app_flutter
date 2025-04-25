import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class AnswerPage extends StatefulWidget {
  @override
  _AnswerPageState createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  int answerDelay = 1500;
  int customVolumePercent = 0;
  int duration = 120;
  bool fullDupUseOnPhonePolqa24 = false;
  bool fullDupUseOnPhonePolqa3 = false;
  String telNumber = "";
  bool useFullDuplexMos = false;
  bool useNarrowband = false;
  int waitTime = 600000;

  final TextEditingController telNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    telNumberController.text = telNumber;
    _loadPreferences();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      answerDelay = prefs.getInt('answerDelay') ?? 1500;
      customVolumePercent = prefs.getInt('customVolumePercent') ?? 0;
      duration = prefs.getInt('duration') ?? 120;
      fullDupUseOnPhonePolqa24 = prefs.getBool('fullDupUseOnPhonePolqa24') ?? false;
      fullDupUseOnPhonePolqa3 = prefs.getBool('fullDupUseOnPhonePolqa3') ?? false;
      telNumber = prefs.getString('telNumber') ?? '';
      useFullDuplexMos = prefs.getBool('useFullDuplexMos') ?? false;
      useNarrowband = prefs.getBool('useNarrowband') ?? false;
      waitTime = prefs.getInt('waitTime') ?? 600000;
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('answerDelay', answerDelay);
    prefs.setInt('customVolumePercent', customVolumePercent);
    prefs.setInt('duration', duration);
    prefs.setBool('fullDupUseOnPhonePolqa24', fullDupUseOnPhonePolqa24);
    prefs.setBool('fullDupUseOnPhonePolqa3', fullDupUseOnPhonePolqa3);
    prefs.setString('telNumber', telNumber);
    prefs.setBool('useFullDuplexMos', useFullDuplexMos);
    prefs.setBool('useNarrowband', useNarrowband);
    prefs.setInt('waitTime', waitTime);
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
            buildNumberField("Answer Delay", answerDelay, (val) {
              setState(() => answerDelay = val);
            }),
            buildNumberField("Custom Volume Percent", customVolumePercent, (val) {
              setState(() => customVolumePercent = val);
            }),
            buildNumberField("Duration", duration, (val) {
              setState(() => duration = val);
            }),
            buildSwitch("Full Dup Use On Phone Polqa24", fullDupUseOnPhonePolqa24, (val) {
              setState(() => fullDupUseOnPhonePolqa24 = val);
            }),
            buildSwitch("Full Dup Use On Phone Polqa3", fullDupUseOnPhonePolqa3, (val) {
              setState(() => fullDupUseOnPhonePolqa3 = val);
            }),
            buildTextField("Tel Number", telNumberController, onChanged: (val) {
              setState(() => telNumber = val);
            }),
            buildSwitch("Use Full Duplex MOS", useFullDuplexMos, (val) {
              setState(() => useFullDuplexMos = val);
            }),
            buildSwitch("Use Narrowband", useNarrowband, (val) {
              setState(() => useNarrowband = val);
            }),
            buildNumberField("Wait Time", waitTime, (val) {
              setState(() => waitTime = val);
            }),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(cellInfo: {
                    "answerDelay": answerDelay.toString(),
                    "customVolumePercent": customVolumePercent.toString(),
                    "duration": duration.toString(),
                    "fullDupUseOnPhonePolqa24": fullDupUseOnPhonePolqa24.toString(),
                    "fullDupUseOnPhonePolqa3": fullDupUseOnPhonePolqa3.toString(),
                    "telNumber": telNumber,
                    "useFullDuplexMos": useFullDuplexMos.toString(),
                    "useNarrowband": useNarrowband.toString(),
                    "waitTime": waitTime.toString(),
                  }));
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

  Widget buildTextField(String label, TextEditingController controller,
      {Function(String)? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff2c2f33),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xff04bcb0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget buildNumberField(String label, int value, Function(int) onChanged) {
    TextEditingController controller = TextEditingController(text: value.toString());
    return buildTextField(label, controller, onChanged: (val) {
      int? parsed = int.tryParse(val);
      if (parsed != null) onChanged(parsed);
    });
  }

  Widget buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xff04bcb0),
          ),
        ],
      ),
    );
  }
}

// ✅ Card Output Widget
Widget cardOutput({
  required Map<String, String> cellInfo,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Answer Page Info", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cellInfo.entries.map((entry) {
          return Text("${entry.key}: ${entry.value}", style: const TextStyle(color: Colors.white));
        }).toList(),
      ),
    ),
  );
}
