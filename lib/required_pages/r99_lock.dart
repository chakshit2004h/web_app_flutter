import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

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
    _loadLockStatus();
  }

  // Load the lock status from SharedPreferences
  _loadLockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLockActivated = prefs.getBool('isLockActivated') ?? false;
    });
  }

  // Save the lock status to SharedPreferences
  _saveLockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLockActivated', isLockActivated);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: double.infinity,
      color: const Color(0xff1a1e22),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.lock,
            size: 100.0,
            color: isLockActivated ? Colors.red : Colors.green,
          ),
          const SizedBox(height: 20),
          Text(
            isLockActivated ? 'R99 Lock is Activated!' : 'R99 Lock is Deactivated!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isLockActivated = !isLockActivated;
                _saveLockStatus(); // Save the new lock status
              });

              // Add to Provider state
              Provider.of<SaveCardState>(context, listen: false)
                  .addCard(cardOutput(lockStatus: isLockActivated));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff04bcb0),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.black.withOpacity(0.2),
              elevation: 5,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isLockActivated ? Icons.lock_open : Icons.lock,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Text(
                  isLockActivated ? 'Deactivate' : 'Activate',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          cardOutput(lockStatus: isLockActivated),
        ],
      ),
    );
  }
}

// Card Output Widget to display lock status
Widget cardOutput({
  required bool lockStatus,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Lock Status", style: TextStyle(color: Colors.white)),
      subtitle: Text(
        lockStatus ? "R99 Lock is Activated" : "R99 Lock is Deactivated",
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}