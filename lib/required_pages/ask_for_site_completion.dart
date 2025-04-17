import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Assuming SaveCardState is defined there

class CompletionFile extends StatefulWidget {
  const CompletionFile({super.key});

  @override
  State<CompletionFile> createState() => _CompletionFileState();
}

class _CompletionFileState extends State<CompletionFile> {
  bool askForCompletion = false;
  bool autoUploadReport = false;
  final TextEditingController siteNameController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      askForCompletion = prefs.getBool('askForCompletion') ?? false;
      autoUploadReport = prefs.getBool('autoUploadReport') ?? false;
      siteNameController.text = prefs.getString('siteName') ?? '';
      commentsController.text = prefs.getString('comments') ?? '';
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('askForCompletion', askForCompletion);
    await prefs.setBool('autoUploadReport', autoUploadReport);
    await prefs.setString('siteName', siteNameController.text);
    await prefs.setString('comments', commentsController.text);
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
            const Text(
              'Completion Settings',
              style: TextStyle(
                color: Color(0xff04bcb0),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildCustomCheckbox(
              label: 'Ask for Completion',
              value: askForCompletion,
              onChanged: (value) {
                setState(() {
                  askForCompletion = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            _buildCustomCheckbox(
              label: 'Auto Upload Report',
              value: autoUploadReport,
              onChanged: (value) {
                setState(() {
                  autoUploadReport = value!;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Site Information',
              style: TextStyle(
                color: Color(0xff04bcb0),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildCustomTextField(
              label: 'Site Name',
              controller: siteNameController,
              hintText: 'e.g., AZQ-Site-001',
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: 'Comments',
              controller: commentsController,
              hintText: 'Any additional info...',
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences();
                  Provider.of<SaveCardState>(context, listen: false).addCard(
                    completionCardOutput(
                      askForCompletion: askForCompletion,
                      autoUploadReport: autoUploadReport,
                      siteName: siteNameController.text,
                      comments: commentsController.text,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
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
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff2c2f33),
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
        ),
      ],
    );
  }

  Widget _buildCustomCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value ? const Color(0xff04bcb0) : const Color(0xff2c2f33),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// Card Widget for Output Display
Widget completionCardOutput({
  required bool askForCompletion,
  required bool autoUploadReport,
  required String siteName,
  required String comments,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Completion Settings", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ask for Completion: ${askForCompletion ? 'Enabled' : 'Disabled'}",
              style: const TextStyle(color: Colors.white)),
          Text("Auto Upload Report: ${autoUploadReport ? 'Enabled' : 'Disabled'}",
              style: const TextStyle(color: Colors.white)),
          Text("Site Name: $siteName", style: const TextStyle(color: Colors.white)),
          Text("Comments: $comments", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
