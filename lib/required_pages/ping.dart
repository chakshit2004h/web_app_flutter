import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class PingStatementPage extends StatefulWidget {
  @override
  _PingStatementPageState createState() => _PingStatementPageState();
}

class _PingStatementPageState extends State<PingStatementPage> {
  bool excludeEventsFromLog = false;
  int count = 20;
  bool enableRedoPackageLossThreshold = false;
  bool enableRedoRttThreshold = false;
  double interval = 0.2;
  int packetSize = 16;
  double redoPackageLossThreshold = 1.0;
  double redoRttThreshold = 80.0;
  String serverAddr = "www.google.com";
  double sessionSuccessThreshold = 0.0;
  bool takeScreenshotWhenDone = false;
  double timeout = 150.0;
  bool usePing6 = false;

  final TextEditingController serverAddrController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    serverAddrController.dispose();
    super.dispose();
  }

  // Load saved values
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      excludeEventsFromLog = prefs.getBool('ping_excludeEventsFromLog') ?? false;
      count = prefs.getInt('ping_count') ?? 20;
      enableRedoPackageLossThreshold = prefs.getBool('ping_enableRedoPackageLossThreshold') ?? false;
      enableRedoRttThreshold = prefs.getBool('ping_enableRedoRttThreshold') ?? false;
      interval = prefs.getDouble('ping_interval') ?? 0.2;
      packetSize = prefs.getInt('ping_packetSize') ?? 16;
      redoPackageLossThreshold = prefs.getDouble('ping_redoPackageLossThreshold') ?? 1.0;
      redoRttThreshold = prefs.getDouble('ping_redoRttThreshold') ?? 80.0;
      serverAddr = prefs.getString('ping_serverAddr') ?? "www.google.com";
      sessionSuccessThreshold = prefs.getDouble('ping_sessionSuccessThreshold') ?? 0.0;
      takeScreenshotWhenDone = prefs.getBool('ping_takeScreenshotWhenDone') ?? false;
      timeout = prefs.getDouble('ping_timeout') ?? 150.0;
      usePing6 = prefs.getBool('ping_usePing6') ?? false;
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ping_excludeEventsFromLog', excludeEventsFromLog);
    await prefs.setInt('ping_count', count);
    await prefs.setBool('ping_enableRedoPackageLossThreshold', enableRedoPackageLossThreshold);
    await prefs.setBool('ping_enableRedoRttThreshold', enableRedoRttThreshold);
    await prefs.setDouble('ping_interval', interval);
    await prefs.setInt('ping_packetSize', packetSize);
    await prefs.setDouble('ping_redoPackageLossThreshold', redoPackageLossThreshold);
    await prefs.setDouble('ping_redoRttThreshold', redoRttThreshold);
    await prefs.setString('ping_serverAddr', serverAddr);
    await prefs.setDouble('ping_sessionSuccessThreshold', sessionSuccessThreshold);
    await prefs.setBool('ping_takeScreenshotWhenDone', takeScreenshotWhenDone);
    await prefs.setDouble('ping_timeout', timeout);
    await prefs.setBool('ping_usePing6', usePing6);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 300,
        color: const Color(0xff1a1e22),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSwitch("Exclude Events From Log", excludeEventsFromLog, (val) {
              setState(() => excludeEventsFromLog = val);
            }),
            _buildNumberField("Count", count, (val) => setState(() => count = val)),
            _buildSwitch("Enable Redo Package Loss Threshold", enableRedoPackageLossThreshold,
                    (val) => setState(() => enableRedoPackageLossThreshold = val)),
            _buildSwitch("Enable Redo RTT Threshold", enableRedoRttThreshold,
                    (val) => setState(() => enableRedoRttThreshold = val)),
            _buildDoubleField("Interval", interval, (val) => setState(() => interval = val)),
            _buildNumberField("Packet Size", packetSize, (val) => setState(() => packetSize = val)),
            _buildDoubleField("Redo Package Loss Threshold", redoPackageLossThreshold,
                    (val) => setState(() => redoPackageLossThreshold = val)),
            _buildDoubleField("Redo RTT Threshold", redoRttThreshold,
                    (val) => setState(() => redoRttThreshold = val)),
            _buildTextField("Server Address", serverAddr, (val) => setState(() => serverAddr = val)),
            _buildDoubleField("Session Success Threshold", sessionSuccessThreshold,
                    (val) => setState(() => sessionSuccessThreshold = val)),
            _buildSwitch("Take Screenshot When Done", takeScreenshotWhenDone,
                    (val) => setState(() => takeScreenshotWhenDone = val)),
            _buildDoubleField("Timeout", timeout, (val) => setState(() => timeout = val)),
            _buildSwitch("Use Ping6", usePing6, (val) => setState(() => usePing6 = val)),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences
      
                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false).addCard(cardOutput(
                    excludeEventsFromLog: excludeEventsFromLog,
                    count: count,
                    enableRedoPackageLossThreshold: enableRedoPackageLossThreshold,
                    enableRedoRttThreshold: enableRedoRttThreshold,
                    interval: interval,
                    packetSize: packetSize,
                    redoPackageLossThreshold: redoPackageLossThreshold,
                    redoRttThreshold: redoRttThreshold,
                    serverAddr: serverAddr,
                    sessionSuccessThreshold: sessionSuccessThreshold,
                    takeScreenshotWhenDone: takeScreenshotWhenDone,
                    timeout: timeout,
                    usePing6: usePing6,
                  ));
                },
                child: const Text('Save', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 14))),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xff04bcb0),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberField(String label, int value, Function(int) onChanged) {
    return _buildCustomTextField(
      label: label,
      value: value.toString(),
      keyboardType: TextInputType.number,
      onChanged: (val) {
        final newValue = int.tryParse(val);
        if (newValue != null) onChanged(newValue);
      },
    );
  }

  Widget _buildDoubleField(String label, double value, Function(double) onChanged) {
    return _buildCustomTextField(
      label: label,
      value: value.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (val) {
        final newValue = double.tryParse(val);
        if (newValue != null) onChanged(newValue);
      },
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    return _buildCustomTextField(
      label: label,
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildCustomTextField({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          TextField(
            controller: TextEditingController(text: value),
            onChanged: onChanged,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xff2c2f33),
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
      ),
    );
  }
}

// ✅ Card Output Widget
Widget cardOutput({
  required bool excludeEventsFromLog,
  required int count,
  required bool enableRedoPackageLossThreshold,
  required bool enableRedoRttThreshold,
  required double interval,
  required int packetSize,
  required double redoPackageLossThreshold,
  required double redoRttThreshold,
  required String serverAddr,
  required double sessionSuccessThreshold,
  required bool takeScreenshotWhenDone,
  required double timeout,
  required bool usePing6,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Ping Statement", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Exclude Events From Log: ${excludeEventsFromLog ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
          Text("Count: $count", style: const TextStyle(color: Colors.white)),
          Text("Enable Redo Package Loss Threshold: ${enableRedoPackageLossThreshold ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
          Text("Enable Redo RTT Threshold: ${enableRedoRttThreshold ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
          Text("Interval: $interval", style: const TextStyle(color: Colors.white)),
          Text("Packet Size: $packetSize", style: const TextStyle(color: Colors.white)),
          Text("Redo Package Loss Threshold: $redoPackageLossThreshold", style: const TextStyle(color: Colors.white)),
          Text("Redo RTT Threshold: $redoRttThreshold", style: const TextStyle(color: Colors.white)),
          Text("Server Address: $serverAddr", style: const TextStyle(color: Colors.white)),
          Text("Session Success Threshold: $sessionSuccessThreshold", style: const TextStyle(color: Colors.white)),
          Text("Take Screenshot When Done: ${takeScreenshotWhenDone ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
          Text("Timeout: $timeout", style: const TextStyle(color: Colors.white)),
          Text("Use Ping6: ${usePing6 ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
