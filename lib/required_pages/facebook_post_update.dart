import 'package:flutter/material.dart';

class FacebookPostPage extends StatefulWidget {
  @override
  _FacebookPostPageState createState() => _FacebookPostPageState();
}

class _FacebookPostPageState extends State<FacebookPostPage> {
  final TextEditingController _messageController =
  TextEditingController(text: "Facebook Message Test");
  final TextEditingController _timeoutController =
  TextEditingController(text: "60");

  String _statusMessage = '';
  bool isRandomMessage = true;

  void _postStatus() {
    final int timeout = int.tryParse(_timeoutController.text.trim()) ?? 60;
    final message = _messageController.text.trim();

    if (isRandomMessage) {
      setState(() {
        _statusMessage = 'Posting random message: $message';
      });

      Future.delayed(Duration(seconds: timeout), () {
        setState(() {
          _statusMessage = 'Message posted successfully!';
        });
      });
    } else {
      setState(() {
        _statusMessage = 'Random message posting is disabled';
      });
    }
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
              label: "Facebook Message",
              controller: _messageController,
            ),
            const SizedBox(height: 16),
            _buildCustomTextField(
              label: "Timeout (seconds)",
              controller: _timeoutController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _postStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
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
                      'Post Status',
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
            const SizedBox(height: 20),
            if (_statusMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff2c2f33),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _statusMessage.contains('successfully')
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontSize: 12,
                    fontFamily: 'Courier',
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
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
