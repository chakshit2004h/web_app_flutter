import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class DohLookupPage extends StatefulWidget {
  const DohLookupPage({super.key});

  @override
  State<DohLookupPage> createState() => _DohLookupPageState();
}

class _DohLookupPageState extends State<DohLookupPage> {
  String serverUrl = "https://cloudflare-dns.com/dns-query";
  String recordType = "A";
  String domain = "www.azenqos.com";
  int timeout = 45;

  final TextEditingController serverUrlController = TextEditingController();
  final TextEditingController recordTypeController = TextEditingController();
  final TextEditingController domainController = TextEditingController();
  final TextEditingController timeoutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    serverUrlController.dispose();
    recordTypeController.dispose();
    domainController.dispose();
    timeoutController.dispose();
    super.dispose();
  }

  // Load saved values from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      serverUrl = prefs.getString('doh_server_url') ?? "https://cloudflare-dns.com/dns-query";
      recordType = prefs.getString('doh_record_type') ?? "A";
      domain = prefs.getString('doh_domain') ?? "www.azenqos.com";
      timeout = prefs.getInt('doh_timeout') ?? 45;

      serverUrlController.text = serverUrl;
      recordTypeController.text = recordType;
      domainController.text = domain;
      timeoutController.text = timeout.toString();
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('doh_server_url', serverUrl);
    await prefs.setString('doh_record_type', recordType);
    await prefs.setString('doh_domain', domain);
    await prefs.setInt('doh_timeout', timeout);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: const Color(0xff1a1e22),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            label: "DoH Server URL",
            controller: serverUrlController,
            onChanged: (val) {
              setState(() {
                serverUrl = val;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Record Type",
            controller: recordTypeController,
            onChanged: (val) {
              setState(() {
                recordType = val;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Target Domain Name",
            controller: domainController,
            onChanged: (val) {
              setState(() {
                domain = val;
              });
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            label: "Timeout (seconds)",
            controller: timeoutController,
            keyboardType: TextInputType.number,
            onChanged: (val) {
              setState(() {
                timeout = int.tryParse(val) ?? 45;
              });
            },
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _savePreferences(); // Save to shared preferences

                // Add to Provider state
                Provider.of<SaveCardState>(context, listen: false)
                    .addCard(cardOutput(serverUrl: serverUrl, recordType: recordType, domain: domain, timeout: timeout));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff04bcb0),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: const TextStyle(color: Colors.white54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff04bcb0)),
            ),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// ✅ Card Output Widget
Widget cardOutput({
  required String serverUrl,
  required String recordType,
  required String domain,
  required int timeout,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("DoH Lookup", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Server URL: $serverUrl", style: const TextStyle(color: Colors.white)),
          Text("Record Type: $recordType", style: const TextStyle(color: Colors.white)),
          Text("Domain: $domain", style: const TextStyle(color: Colors.white)),
          Text("Timeout: $timeout seconds", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
