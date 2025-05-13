import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class ConditionalLoopPage extends StatefulWidget {
  @override
  _ConditionalLoopPageState createState() => _ConditionalLoopPageState();
}

class _ConditionalLoopPageState extends State<ConditionalLoopPage> {
  final TextEditingController _maxRunController = TextEditingController(text: '10000');
  String _loopResult = '';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  // Load saved loop result from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loopResult = prefs.getString('loopResult') ?? '';
    });
  }

  // Save loop result to SharedPreferences
  _savePreferences(String result) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('loopResult', result);
  }

  // Function to run the conditional loop and handle saving
  void _runConditionalLoop() {
    setState(() {
      final int maxRun = int.tryParse(_maxRunController.text) ?? 10000;
      String result = '';

      for (int i = 1; i <= maxRun; i++) {
        result += 'Iteration $i\n';
        if (i == 10) {
          result += 'Reached iteration 10, breaking loop...\n';
          break;
        }
      }

      _loopResult = result;
      _savePreferences(result);  // Save the result
      // Add to Provider state if needed
      Provider.of<SaveCardState>(context, listen: false)
          .addCard(loopSummaryCard(maxRun));

    });
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
            _buildCustomTextField(
              label: "Enter max iterations (maxRun)",
              controller: _maxRunController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ElevatedButton(
                onPressed: _runConditionalLoop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
              ),]
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color:const Color(0xff04bcb0),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ],
    );
  }
}

Widget loopSummaryCard(int maxRun) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Conditional Loop", style: TextStyle(color: Colors.white)),
      subtitle: Text(
        "[$maxRun]",
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}


