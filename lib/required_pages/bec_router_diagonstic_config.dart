import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class RouterConfigPage extends StatefulWidget {
  @override
  _RouterConfigPageState createState() => _RouterConfigPageState();
}

class _RouterConfigPageState extends State<RouterConfigPage> {
  // Controllers for text fields
  TextEditingController usernameController = TextEditingController(text: "admin");
  TextEditingController passwordController = TextEditingController(text: "admin");
  TextEditingController routerIPController = TextEditingController(text: "192.168.1.254");

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    routerIPController.dispose();
    super.dispose();
  }

  // Load saved values from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usernameController.text = prefs.getString('router_username') ?? 'admin';
      passwordController.text = prefs.getString('router_password') ?? 'admin';
      routerIPController.text = prefs.getString('router_ip') ?? '192.168.1.254';
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('router_username', usernameController.text);
    await prefs.setString('router_password', passwordController.text);
    await prefs.setString('router_ip', routerIPController.text);
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
          _buildCustomTextField(
            controller: usernameController,
            label: 'Username',
            hint: 'Enter Username',
          ),
          const SizedBox(height: 16),
          _buildCustomTextField(
            controller: passwordController,
            label: 'Password',
            hint: 'Enter Password',
            obscure: true,
          ),
          const SizedBox(height: 16),
          _buildCustomTextField(
            controller: routerIPController,
            label: 'Router IP Address',
            hint: 'Enter Router IP Address',
            keyboardType: TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _savePreferences(); // Save to shared preferences

                // Add to Provider state
                Provider.of<SaveCardState>(context, listen: false).addCard(
                  cardOutput(
                    username: usernameController.text,
                    password: passwordController.text,
                    routerIP: routerIPController.text,
                  ),
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff04bcb0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom TextField Widget
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool obscure = false,
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
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  // Card Output Widget
  Widget cardOutput({
    required String username,
    required String password,
    required String routerIP,
  }) {
    return Card(
      color: const Color(0xff101f1f),
      elevation: 5,
      child: ListTile(
        title: const Text("Router Configuration", style: TextStyle(color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Username: $username", style: const TextStyle(color: Colors.white)),
            Text("Password: $password", style: const TextStyle(color: Colors.white)),
            Text("Router IP: $routerIP", style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
