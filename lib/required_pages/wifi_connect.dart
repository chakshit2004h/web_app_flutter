import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Update the import path as necessary

class WifiConnectPage extends StatefulWidget {
  @override
  _WifiConnectPageState createState() => _WifiConnectPageState();
}

class _WifiConnectPageState extends State<WifiConnectPage> {
  bool allowToUseConfiguredNetwork = true;
  bool clearAllConfigurations = false;
  int eapMethod = 4;
  bool isPublicWifi = false;
  String operator = "any";
  int security = 0;
  int timeout = 300;
  bool waitUntilTimeout = false;

  final TextEditingController ssidController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController timeoutController = TextEditingController();

  List<String> eapMethods = ['Method 1', 'Method 2', 'Method 3', 'Method 4'];
  List<String> securityTypes = ['None', 'WEP', 'WPA/WPA2'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    ssidController.dispose();
    passwordController.dispose();
    timeoutController.dispose();
    super.dispose();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      allowToUseConfiguredNetwork = prefs.getBool('wifi_allow') ?? true;
      clearAllConfigurations = prefs.getBool('wifi_clear') ?? false;
      eapMethod = prefs.getInt('wifi_eap') ?? 4;
      isPublicWifi = prefs.getBool('wifi_public') ?? false;
      ssidController.text = prefs.getString('wifi_ssid') ?? '';
      passwordController.text = prefs.getString('wifi_password') ?? '';
      operator = prefs.getString('wifi_operator') ?? 'any';
      security = prefs.getInt('wifi_security') ?? 0;
      timeout = prefs.getInt('wifi_timeout') ?? 300;
      timeoutController.text = timeout.toString();
      waitUntilTimeout = prefs.getBool('wifi_wait') ?? false;
    });
  }

  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('wifi_allow', allowToUseConfiguredNetwork);
    await prefs.setBool('wifi_clear', clearAllConfigurations);
    await prefs.setInt('wifi_eap', eapMethod);
    await prefs.setBool('wifi_public', isPublicWifi);
    await prefs.setString('wifi_ssid', ssidController.text);
    await prefs.setString('wifi_password', passwordController.text);
    await prefs.setString('wifi_operator', operator);
    await prefs.setInt('wifi_security', security);
    await prefs.setInt('wifi_timeout', timeout);
    await prefs.setBool('wifi_wait', waitUntilTimeout);
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          onChanged: (_) {
            if (controller == timeoutController) {
              timeout = int.tryParse(timeoutController.text) ?? 300;
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: const Color(0xff2c2f33),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
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
            SwitchListTile(
              activeColor: const Color(0xff04bcb0),
              title: const Text('Allow to Use Configured Network', style: TextStyle(color: Colors.white)),
              value: allowToUseConfiguredNetwork,
              onChanged: (val) => setState(() => allowToUseConfiguredNetwork = val),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              activeColor: const Color(0xff04bcb0),
              title: const Text('Clear All Configurations', style: TextStyle(color: Colors.white)),
              value: clearAllConfigurations,
              onChanged: (val) => setState(() => clearAllConfigurations = val),
            ),
            const SizedBox(height: 16),

            const Text('EAP Method:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            DropdownButton<int>(
              dropdownColor: const Color(0xff2c2f33),
              value: eapMethod,
              iconEnabledColor: Colors.white,
              onChanged: (int? val) => setState(() => eapMethod = val!),
              items: List.generate(eapMethods.length, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text(eapMethods[index], style: const TextStyle(color: Colors.white)),
                );
              }),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              activeColor: const Color(0xff04bcb0),
              title: const Text('Is Public Wi-Fi', style: TextStyle(color: Colors.white)),
              value: isPublicWifi,
              onChanged: (val) => setState(() => isPublicWifi = val),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'SSID',
              hint: 'Enter SSID',
              controller: ssidController,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Wi-Fi Password',
              hint: 'Enter Password',
              controller: passwordController,
              obscure: true,
            ),
            const SizedBox(height: 16),

            const Text('Operator:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            DropdownButton<String>(
              dropdownColor: const Color(0xff2c2f33),
              value: operator,
              iconEnabledColor: Colors.white,
              onChanged: (String? val) => setState(() => operator = val!),
              items: ['any', 'Operator 1', 'Operator 2', 'Operator 3']
                  .map((op) => DropdownMenuItem(
                value: op,
                child: Text(op, style: const TextStyle(color: Colors.white)),
              ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            const Text('Security Type:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            DropdownButton<int>(
              dropdownColor: const Color(0xff2c2f33),
              value: security,
              iconEnabledColor: Colors.white,
              onChanged: (int? val) => setState(() => security = val!),
              items: securityTypes.asMap().entries.map((entry) {
                return DropdownMenuItem<int>(
                  value: entry.key,
                  child: Text(entry.value, style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            _buildTextField(
              label: 'Timeout (seconds)',
              hint: 'Enter Timeout',
              controller: timeoutController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              activeColor: const Color(0xff04bcb0),
              title: const Text('Wait Until Timeout', style: TextStyle(color: Colors.white)),
              value: waitUntilTimeout,
              onChanged: (val) => setState(() => waitUntilTimeout = val),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences();
                  Provider.of<SaveCardState>(context, listen: false).addCard(
                    cardOutput(
                      ssid: ssidController.text,
                      wifiPassword: passwordController.text,
                      eapMethod: eapMethod,
                      operator: operator,
                      security: security,
                      timeout: timeout,
                      isPublicWifi: isPublicWifi,
                      allowToUseConfiguredNetwork: allowToUseConfiguredNetwork,
                      clearAllConfigurations: clearAllConfigurations,
                      waitUntilTimeout: waitUntilTimeout,
                    ),
                  );
                },
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
                      'Save Settings',
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
  Widget cardOutput({
    required bool allowToUseConfiguredNetwork,
    required bool clearAllConfigurations,
    required int eapMethod,
    required bool isPublicWifi,
    required String ssid,
    required String wifiPassword,
    required String operator,
    required int security,
    required int timeout,
    required bool waitUntilTimeout,
  }) {
    return Card(
      color: const Color(0xff101f1f),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Saved WiFi Configuration",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white54),
            _buildRow("SSID", ssid),
            _buildRow(
                "Password", wifiPassword.isNotEmpty ? "••••••••" : "None"),
            _buildRow("Operator", operator),
            _buildRow("Security", security.toString()),
            _buildRow("EAP Method", eapMethod.toString()),
            _buildRow("Timeout", "$timeout sec"),
            _buildRow("Public Wi-Fi", isPublicWifi ? "Yes" : "No"),
            _buildRow("Allow Existing Config",
                allowToUseConfiguredNetwork ? "Yes" : "No"),
            _buildRow(
                "Clear All Configs", clearAllConfigurations ? "Yes" : "No"),
            _buildRow("Wait Until Timeout", waitUntilTimeout ? "Yes" : "No"),
          ],
        ),
      ),
    );
  }
  Widget _buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
