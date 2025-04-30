import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../addon/provider.dart'; // Ensure this path is correct

class R99LockPage extends StatefulWidget {
  const R99LockPage({super.key});

  @override
  State<R99LockPage> createState() => _R99LockPageState();
}

class _R99LockPageState extends State<R99LockPage> {
  bool isLockActivated = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences(); // Load lock status on init
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLockActivated = prefs.getBool('isLockActivated') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLockActivated', isLockActivated);
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
            _buildCustomSwitch(
              label: "Enable R99 Lock",
              value: isLockActivated,
              onChanged: (val) {
                setState(() {
                  isLockActivated = val;
                });
                _savePreferences(); // Save updated value
              },
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'R99 Lock is ${isLockActivated ? "Activated" : "Deactivated"}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(lockStatus: isLockActivated));
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

  Widget _buildCustomSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xff04bcb0),
        ),
      ],
    );
  }
}

Widget cardOutput({required bool lockStatus}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("R99 Lock", style: TextStyle(color: Colors.white)),
      subtitle: Text(
        "R99 Lock is ${lockStatus ? 'Activated' : 'Deactivated'}",
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
