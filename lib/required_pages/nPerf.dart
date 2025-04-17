import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class NPerfTestPage extends StatefulWidget {
  @override
  _NPerfTestPageState createState() => _NPerfTestPageState();
}

class _NPerfTestPageState extends State<NPerfTestPage> {
  bool enableRedoDownloadThroughputThreshold = false;
  bool enableRedoJitterThreshold = false;
  bool enableRedoLatencyThreshold = false;
  bool enableRedoUploadThroughputThreshold = false;
  int maxRetries = 5;
  bool ocrMode = true;
  double redoDownloadThroughputThreshold = 500.0;
  double redoJitterThreshold = 10.0;
  double redoLatencyThreshold = 10.0;
  double redoUploadThroughputThreshold = 300.0;
  int retryWaitSecs = 5;
  bool takeScreenshot = false;
  int timeout = 300;

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
            _buildSwitch("Enable Redo Download Throughput Threshold", enableRedoDownloadThroughputThreshold, (value) {
              setState(() => enableRedoDownloadThroughputThreshold = value);
            }),
            _buildSwitch("Enable Redo Jitter Threshold", enableRedoJitterThreshold, (value) {
              setState(() => enableRedoJitterThreshold = value);
            }),
            _buildSwitch("Enable Redo Latency Threshold", enableRedoLatencyThreshold, (value) {
              setState(() => enableRedoLatencyThreshold = value);
            }),
            _buildSwitch("Enable Redo Upload Throughput Threshold", enableRedoUploadThroughputThreshold, (value) {
              setState(() => enableRedoUploadThroughputThreshold = value);
            }),
            _buildNumberField("Max Retries", maxRetries, (value) {
              setState(() => maxRetries = value);
            }),
            _buildSwitch("OCR Mode", ocrMode, (value) {
              setState(() => ocrMode = value);
            }),
            _buildDoubleField("Redo Download Throughput Threshold", redoDownloadThroughputThreshold, (value) {
              setState(() => redoDownloadThroughputThreshold = value);
            }),
            _buildDoubleField("Redo Jitter Threshold", redoJitterThreshold, (value) {
              setState(() => redoJitterThreshold = value);
            }),
            _buildDoubleField("Redo Latency Threshold", redoLatencyThreshold, (value) {
              setState(() => redoLatencyThreshold = value);
            }),
            _buildDoubleField("Redo Upload Throughput Threshold", redoUploadThroughputThreshold, (value) {
              setState(() => redoUploadThroughputThreshold = value);
            }),
            _buildNumberField("Retry Wait Seconds", retryWaitSecs, (value) {
              setState(() => retryWaitSecs = value);
            }),
            _buildSwitch("Take Screenshot", takeScreenshot, (value) {
              setState(() => takeScreenshot = value);
            }),
            _buildNumberField("Timeout", timeout, (value) {
              setState(() => timeout = value);
            }),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences(); // Save to shared preferences
                  // Add to Provider state
                  Provider.of<SaveCardState>(context, listen: false)
                      .addCard(cardOutput(
                    enableRedoDownloadThroughputThreshold: enableRedoDownloadThroughputThreshold,
                    enableRedoJitterThreshold: enableRedoJitterThreshold,
                    enableRedoLatencyThreshold: enableRedoLatencyThreshold,
                    enableRedoUploadThroughputThreshold: enableRedoUploadThroughputThreshold,
                    maxRetries: maxRetries,
                    ocrMode: ocrMode,
                    redoDownloadThroughputThreshold: redoDownloadThroughputThreshold,
                    redoJitterThreshold: redoJitterThreshold,
                    redoLatencyThreshold: redoLatencyThreshold,
                    redoUploadThroughputThreshold: redoUploadThroughputThreshold,
                    retryWaitSecs: retryWaitSecs,
                    takeScreenshot: takeScreenshot,
                    timeout: timeout,
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
                    Icon(Icons.save, color: Colors.white),
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
            const SizedBox(height: 20),
            _buildCardOutput(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardOutput() {
    return Card(
      color: const Color(0xff101f1f),
      elevation: 5,
      child: ListTile(
        title: const Text("NPerf Test Settings", style: TextStyle(color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Max Retries: $maxRetries", style: const TextStyle(color: Colors.white)),
            Text("OCR Mode: ${ocrMode ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
            Text("Redo Download Throughput Threshold: $redoDownloadThroughputThreshold", style: const TextStyle(color: Colors.white)),
            Text("Redo Jitter Threshold: $redoJitterThreshold", style: const TextStyle(color: Colors.white)),
            Text("Redo Latency Threshold: $redoLatencyThreshold", style: const TextStyle(color: Colors.white)),
            Text("Redo Upload Throughput Threshold: $redoUploadThroughputThreshold", style: const TextStyle(color: Colors.white)),
            Text("Retry Wait Seconds: $retryWaitSecs", style: const TextStyle(color: Colors.white)),
            Text("Timeout: $timeout", style: const TextStyle(color: Colors.white)),
            Text("Take Screenshot: ${takeScreenshot ? 'Enabled' : 'Disabled'}", style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      activeColor: const Color(0xff04bcb0),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildNumberField(String label, int value, Function(int) onChanged) {
    return _buildCustomTextField(
      label: label,
      value: value.toString(),
      onChanged: (val) => onChanged(int.tryParse(val) ?? 0),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDoubleField(String label, double value, Function(double) onChanged) {
    return _buildCustomTextField(
      label: label,
      value: value.toString(),
      onChanged: (val) => onChanged(double.tryParse(val) ?? 0.0),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  // Save preferences to SharedPreferences (if required)
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('max_retries', maxRetries);
    await prefs.setBool('ocr_mode', ocrMode);
    await prefs.setDouble('redo_download_throughput_threshold', redoDownloadThroughputThreshold);
    await prefs.setDouble('redo_jitter_threshold', redoJitterThreshold);
    await prefs.setDouble('redo_latency_threshold', redoLatencyThreshold);
    await prefs.setDouble('redo_upload_throughput_threshold', redoUploadThroughputThreshold);
    await prefs.setInt('retry_wait_secs', retryWaitSecs);
    await prefs.setInt('timeout', timeout);
    await prefs.setBool('take_screenshot', takeScreenshot);
  }
  Widget cardOutput({
    required bool enableRedoDownloadThroughputThreshold,
    required bool enableRedoJitterThreshold,
    required bool enableRedoLatencyThreshold,
    required bool enableRedoUploadThroughputThreshold,
    required int maxRetries,
    required bool ocrMode,
    required double redoDownloadThroughputThreshold,
    required double redoJitterThreshold,
    required double redoLatencyThreshold,
    required double redoUploadThroughputThreshold,
    required int retryWaitSecs,
    required bool takeScreenshot,
    required int timeout,
  }) {
    return Card(
      color: const Color(0xff101f1f),
      elevation: 5,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "NPerf Test Settings",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Max Retries: $maxRetries",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "OCR Mode: ${ocrMode ? 'Enabled' : 'Disabled'}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Redo Download Throughput Threshold: $redoDownloadThroughputThreshold",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Redo Jitter Threshold: $redoJitterThreshold",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Redo Latency Threshold: $redoLatencyThreshold",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Redo Upload Throughput Threshold: $redoUploadThroughputThreshold",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Retry Wait Seconds: $retryWaitSecs",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Timeout: $timeout",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Take Screenshot: ${takeScreenshot ? 'Enabled' : 'Disabled'}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Enable Redo Download Throughput Threshold: ${enableRedoDownloadThroughputThreshold ? 'Enabled' : 'Disabled'}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Enable Redo Jitter Threshold: ${enableRedoJitterThreshold ? 'Enabled' : 'Disabled'}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Enable Redo Latency Threshold: ${enableRedoLatencyThreshold ? 'Enabled' : 'Disabled'}",
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              "Enable Redo Upload Throughput Threshold: ${enableRedoUploadThroughputThreshold ? 'Enabled' : 'Disabled'}",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

}
