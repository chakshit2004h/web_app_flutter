import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Import your SaveCardState provider

class TcpDumpRecordPage extends StatefulWidget {
  const TcpDumpRecordPage({super.key});

  @override
  State<TcpDumpRecordPage> createState() => _TcpDumpRecordPageState();
}

class _TcpDumpRecordPageState extends State<TcpDumpRecordPage> {
  bool isTcpDumpEnabled = true;
  TextEditingController packetCountController = TextEditingController();
  TextEditingController snaplenController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isTcpDumpEnabled = prefs.getBool('tcpDumpEnabled') ?? true;
      packetCountController.text = prefs.getString('packetCount') ?? '';
      snaplenController.text = prefs.getString('snaplen') ?? '';
    });
  }

  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tcpDumpEnabled', isTcpDumpEnabled);
    await prefs.setString('packetCount', packetCountController.text);
    await prefs.setString('snaplen', snaplenController.text);
  }

  @override
  void dispose() {
    packetCountController.dispose();
    snaplenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xff1a1e22),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCustomCheckbox(
            label: 'Enable TCP Dump',
            value: isTcpDumpEnabled,
            onChanged: (value) {
              setState(() {
                isTcpDumpEnabled = value!;
              });
              _savePreferences();
            },
          ),
          const SizedBox(height: 20),
          const Text('Packet Count', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          TextField(
            controller: packetCountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter packet count',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Snaplen', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 6),
          TextField(
            controller: snaplenController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Enter snaplen value',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.black26,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _savePreferences();

              // Add to global card list
              Provider.of<SaveCardState>(context, listen: false).addCard(
                tcpDumpCardOutput(
                  isTcpDumpEnabled: isTcpDumpEnabled,
                  packetCount: packetCountController.text,
                  snaplen: snaplenController.text,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff04bcb0),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
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
              color: value ? Colors.teal : Colors.transparent,
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

Widget tcpDumpCardOutput({
  required bool isTcpDumpEnabled,
  required String packetCount,
  required String snaplen,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("TCP Dump", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Enabled: ${isTcpDumpEnabled ? 'Yes' : 'No'}", style: const TextStyle(color: Colors.white)),
          Text("Packet Count: $packetCount", style: const TextStyle(color: Colors.white)),
          Text("Snaplen: $snaplen", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
