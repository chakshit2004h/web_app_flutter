import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrowserPage extends StatefulWidget {
  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  int timeout = 180;
  String url = "http://www.azenqos.com";
  bool isEnableJavaScript = true;
  bool isRequestDesktopSite = false;

  final TextEditingController timeoutController = TextEditingController();
  final TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      timeout = prefs.getInt('timeout') ?? 180;
      url = prefs.getString('url') ?? "http://www.azenqos.com";
      isEnableJavaScript = prefs.getBool('isEnableJavaScript') ?? true;
      isRequestDesktopSite = prefs.getBool('isRequestDesktopSite') ?? false;
      timeoutController.text = timeout.toString();
      urlController.text = url;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeout', timeout);
    await prefs.setString('url', url);
    await prefs.setBool('isEnableJavaScript', isEnableJavaScript);
    await prefs.setBool('isRequestDesktopSite', isRequestDesktopSite);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browser Settings"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 300,
          height: double.infinity,
          color: Color(0xff1a1e22),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Browser Settings',
                style: TextStyle(
                  color: Color(0xff04bcb0),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildCustomTextField(
                label: 'Timeout',
                controller: timeoutController,
                hintText: 'e.g., 180',
                keyboardType: TextInputType.number,
                onChanged: (newValue) {
                  setState(() {
                    timeout = int.tryParse(newValue) ?? timeout;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildCustomTextField(
                label: 'URL',
                controller: urlController,
                hintText: 'e.g., http://www.azenqos.com',
                onChanged: (newValue) {
                  setState(() {
                    url = newValue;
                  });
                },
              ),
              const SizedBox(height: 30),
              _buildCustomSwitch(
                label: 'Enable JavaScript',
                value: isEnableJavaScript,
                onChanged: (newValue) {
                  setState(() {
                    isEnableJavaScript = newValue;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildCustomSwitch(
                label: 'Request Desktop Site',
                value: isRequestDesktopSite,
                onChanged: (newValue) {
                  setState(() {
                    isRequestDesktopSite = newValue;
                  });
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _savePreferences();
                    print("Browser settings saved: URL = $url, Timeout = $timeout");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff04bcb0),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    required ValueChanged<String> onChanged,
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
            fillColor: Color(0xff2c2f33),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white38),
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
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildCustomSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      activeColor: Color(0xff04bcb0),
      title: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}
