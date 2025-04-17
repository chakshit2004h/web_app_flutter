import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class SendEmailPage extends StatefulWidget {
  const SendEmailPage({super.key});

  @override
  State<SendEmailPage> createState() => _SendEmailPageState();
}

class _SendEmailPageState extends State<SendEmailPage> {
  final toController = TextEditingController();
  final subjectController = TextEditingController(text: "Sending from Azenqos");
  final bodyController = TextEditingController(text: "azenqos message");
  final hostController = TextEditingController(text: "smtp-mail.outlook.com");
  final portController = TextEditingController(text: "587");
  final fromController = TextEditingController(text: "azenqostestazq@outlook.com");
  final passwordController = TextEditingController(text: "azqtest2018");
  final timeoutController = TextEditingController(text: "60");
  final sslTrustController = TextEditingController(text: "smtp-mail.outlook.com");
  final fileSizeController = TextEditingController(text: "5mb");

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      toController.text = prefs.getString('email_to') ?? '';
      subjectController.text = prefs.getString('email_subject') ?? 'Sending from Azenqos';
      bodyController.text = prefs.getString('email_body') ?? 'azenqos message';
      hostController.text = prefs.getString('email_host') ?? 'smtp-mail.outlook.com';
      portController.text = prefs.getString('email_port') ?? '587';
      fromController.text = prefs.getString('email_from') ?? 'azenqostestazq@outlook.com';
      passwordController.text = prefs.getString('email_password') ?? 'azqtest2018';
      timeoutController.text = prefs.getString('email_timeout') ?? '60';
      sslTrustController.text = prefs.getString('email_sslTrust') ?? 'smtp-mail.outlook.com';
      fileSizeController.text = prefs.getString('email_fileSize') ?? '5mb';
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email_to', toController.text);
    await prefs.setString('email_subject', subjectController.text);
    await prefs.setString('email_body', bodyController.text);
    await prefs.setString('email_host', hostController.text);
    await prefs.setString('email_port', portController.text);
    await prefs.setString('email_from', fromController.text);
    await prefs.setString('email_password', passwordController.text);
    await prefs.setString('email_timeout', timeoutController.text);
    await prefs.setString('email_sslTrust', sslTrustController.text);
    await prefs.setString('email_fileSize', fileSizeController.text);
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
            _buildCustomTextField(label: "To", controller: toController),
            const SizedBox(height: 16),
            _buildCustomTextField(label: "Subject", controller: subjectController),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Body",
              controller: bodyController,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(label: "Host", controller: hostController),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Port",
              controller: portController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(label: "From", controller: fromController),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Password",
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Timeout",
              controller: timeoutController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(label: "SSL Trust", controller: sslTrustController),
            const SizedBox(height: 16),
            _buildCustomTextField(label: "File Size", controller: fileSizeController),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences

                  // Add to Provider state (ScriptCard)
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(
                    to: toController.text,
                    subject: subjectController.text,
                    body: bodyController.text,
                    host: hostController.text,
                    port: portController.text,
                    from: fromController.text,
                    password: passwordController.text,
                    timeout: timeoutController.text,
                    sslTrust: sslTrustController.text,
                    fileSize: fileSizeController.text,
                  ));
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
                    Icon(Icons.send, color: Colors.white),
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

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}

// ✅ Card Output Widget
Widget cardOutput({
  required String to,
  required String subject,
  required String body,
  required String host,
  required String port,
  required String from,
  required String password,
  required String timeout,
  required String sslTrust,
  required String fileSize,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Email Settings", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("To: $to", style: const TextStyle(color: Colors.white)),
          Text("Subject: $subject", style: const TextStyle(color: Colors.white)),
          Text("Body: $body", style: const TextStyle(color: Colors.white)),
          Text("Host: $host", style: const TextStyle(color: Colors.white)),
          Text("Port: $port", style: const TextStyle(color: Colors.white)),
          Text("From: $from", style: const TextStyle(color: Colors.white)),
          Text("Password: $password", style: const TextStyle(color: Colors.white)),
          Text("Timeout: $timeout", style: const TextStyle(color: Colors.white)),
          Text("SSL Trust: $sslTrust", style: const TextStyle(color: Colors.white)),
          Text("File Size: $fileSize", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
