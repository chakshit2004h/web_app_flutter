import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust if needed

class LineRecieve extends StatefulWidget {
  const LineRecieve({super.key});

  @override
  State<LineRecieve> createState() => _LineRecieveState();
}

class _LineRecieveState extends State<LineRecieve> {
  bool dontClearHistory = false;
  bool loadPhoto = false;
  int photoMinSize = 100;
  int photoReadTimeout = 30;
  bool playVideo = false;
  int playVideoTimeout = 30;
  bool playVoice = false;
  int playVoiceTimeOut = 30;
  int readTimeout = 100000;
  bool regainLineApp = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      dontClearHistory = prefs.getBool('lr_dontClearHistory') ?? false;
      loadPhoto = prefs.getBool('lr_loadPhoto') ?? false;
      photoMinSize = prefs.getInt('lr_photoMinSize') ?? 100;
      photoReadTimeout = prefs.getInt('lr_photoReadTimeout') ?? 30;
      playVideo = prefs.getBool('lr_playVideo') ?? false;
      playVideoTimeout = prefs.getInt('lr_playVideoTimeout') ?? 30;
      playVoice = prefs.getBool('lr_playVoice') ?? false;
      playVoiceTimeOut = prefs.getInt('lr_playVoiceTimeOut') ?? 30;
      readTimeout = prefs.getInt('lr_readTimeout') ?? 100000;
      regainLineApp = prefs.getBool('lr_regainLineApp') ?? true;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('lr_dontClearHistory', dontClearHistory);
    await prefs.setBool('lr_loadPhoto', loadPhoto);
    await prefs.setInt('lr_photoMinSize', photoMinSize);
    await prefs.setInt('lr_photoReadTimeout', photoReadTimeout);
    await prefs.setBool('lr_playVideo', playVideo);
    await prefs.setInt('lr_playVideoTimeout', playVideoTimeout);
    await prefs.setBool('lr_playVoice', playVoice);
    await prefs.setInt('lr_playVoiceTimeOut', playVoiceTimeOut);
    await prefs.setInt('lr_readTimeout', readTimeout);
    await prefs.setBool('lr_regainLineApp', regainLineApp);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: const Color(0xff1a1e22),
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomSwitch("Don't Clear History", dontClearHistory, (val) => setState(() => dontClearHistory = val)),
            _buildCustomSwitch("Load Photo", loadPhoto, (val) => setState(() => loadPhoto = val)),
            _buildCustomSlider("Photo Min Size", photoMinSize.toDouble(), 1, 1000, 100, (val) => setState(() => photoMinSize = val.toInt())),
            _buildCustomSlider("Photo Read Timeout (sec)", photoReadTimeout.toDouble(), 1, 120, 60, (val) => setState(() => photoReadTimeout = val.toInt())),
            _buildCustomSwitch("Play Video", playVideo, (val) => setState(() => playVideo = val)),
            _buildCustomSlider("Play Video Timeout (sec)", playVideoTimeout.toDouble(), 1, 120, 60, (val) => setState(() => playVideoTimeout = val.toInt())),
            _buildCustomSwitch("Play Voice", playVoice, (val) => setState(() => playVoice = val)),
            _buildCustomSlider("Play Voice Timeout (sec)", playVoiceTimeOut.toDouble(), 1, 120, 60, (val) => setState(() => playVoiceTimeOut = val.toInt())),
            _buildCustomSlider("Read Timeout (ms)", readTimeout.toDouble(), 1000, 1000000, 100, (val) => setState(() => readTimeout = val.toInt())),
            _buildCustomSwitch("Regain Line App", regainLineApp, (val) => setState(() => regainLineApp = val)),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _savePreferences();
                  Provider.of<SaveCardState>(context, listen: false).addCard(
                    lineReceiveCard(
                      dontClearHistory,
                      loadPhoto,
                      photoMinSize,
                      photoReadTimeout,
                      playVideo,
                      playVideoTimeout,
                      playVoice,
                      playVoiceTimeOut,
                      readTimeout,
                      regainLineApp,
                    ),
                  );
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

  Widget _buildCustomSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xff04bcb0),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomSlider(String label, double value, double min, double max, int divisions, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${value.toInt()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: value.toInt().toString(),
            onChanged: onChanged,
            activeColor: const Color(0xff04bcb0),
            inactiveColor: Colors.grey,
          ),
        ],
      ),
    );
  }
  Widget lineReceiveCard(
      bool dontClearHistory,
      bool loadPhoto,
      int photoMinSize,
      int photoReadTimeout,
      bool playVideo,
      int playVideoTimeout,
      bool playVoice,
      int playVoiceTimeOut,
      int readTimeout,
      bool regainLineApp,
      ) {
    return Card(
      color: const Color(0xff101f1f),
      child: ListTile(
        title: const Text("Line Receive Settings", style: TextStyle(color: Colors.white)),
        subtitle: Text(
          '''
Don't Clear History: $dontClearHistory
Load Photo: $loadPhoto ($photoMinSize KB, Timeout: $photoReadTimeout sec)
Play Video: $playVideo (Timeout: $playVideoTimeout sec)
Play Voice: $playVoice (Timeout: $playVoiceTimeOut sec)
Read Timeout: $readTimeout ms
Regain Line App: $regainLineApp
''',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
    );
  }
}
