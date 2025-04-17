import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class LTEEARFCNLockPage extends StatefulWidget {
  const LTEEARFCNLockPage({super.key});

  @override
  State<LTEEARFCNLockPage> createState() => _LTEEARFCNLockPageState();
}

class _LTEEARFCNLockPageState extends State<LTEEARFCNLockPage> {
  int band = 0;
  bool dontDisableCa = false;
  int earfcn = 0;

  final TextEditingController bandController = TextEditingController();
  final TextEditingController earfcnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    bandController.dispose();
    earfcnController.dispose();
    super.dispose();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      band = prefs.getInt('lte_band') ?? 0;
      earfcn = prefs.getInt('lte_earfcn') ?? 0;
      dontDisableCa = prefs.getBool('lte_dontDisableCa') ?? false;
      bandController.text = band.toString();
      earfcnController.text = earfcn.toString();
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lte_band', band);
    await prefs.setInt('lte_earfcn', earfcn);
    await prefs.setBool('lte_dontDisableCa', dontDisableCa);
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
          _buildNumberField(
            label: 'Band',
            controller: bandController,
            onChanged: (val) {
              final num = int.tryParse(val);
              if (num != null) {
                setState(() => band = num);
              }
            },
          ),
          const SizedBox(height: 20),
          _buildCustomSwitch(
            label: "Don't Disable CA",
            value: dontDisableCa,
            onChanged: (val) => setState(() => dontDisableCa = val),
          ),
          const SizedBox(height: 20),
          _buildNumberField(
            label: 'EARFCN',
            controller: earfcnController,
            onChanged: (val) {
              final num = int.tryParse(val);
              if (num != null) {
                setState(() => earfcn = num);
              }
            },
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: () {
                _savePreferences(); // Save to shared preferences

                // Add to Provider state
                Provider.of<SaveCardState>(context, listen: false)
                    .addCard(cardOutput(band: band, earfcn: earfcn, dontDisableCa: dontDisableCa));
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

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
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

// ✅ Card Output Widget
Widget cardOutput({
  required int band,
  required int earfcn,
  required bool dontDisableCa,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("LTE EARFCN Lock", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Band: $band", style: const TextStyle(color: Colors.white)),
          Text("EARFCN: $earfcn", style: const TextStyle(color: Colors.white)),
          Text("Don't Disable CA: ${dontDisableCa ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
