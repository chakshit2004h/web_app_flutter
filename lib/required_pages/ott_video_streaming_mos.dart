import 'package:flutter/material.dart';

class OttVideoStreamingMos extends StatefulWidget {
  const OttVideoStreamingMos({super.key});

  @override
  State<OttVideoStreamingMos> createState() => _OttVideoStreamingMosState();
}

class _OttVideoStreamingMosState extends State<OttVideoStreamingMos> {
  int timeout = 60;
  String videoId = "";
  String videoPlayerUrl = "file:///android_asset/video_player/index.html";
  List<String> videoList = [
    "com.azq.core.testscript.VideoItem@7e4fca1",
    "com.azq.core.testscript.VideoItem@6fecec6",
    "com.azq.core.testscript.VideoItem@a28e87"
  ];

  final TextEditingController timeoutController = TextEditingController();
  final TextEditingController videoIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    timeoutController.text = timeout.toString();
    videoIdController.text = videoId;
  }

  @override
  void dispose() {
    timeoutController.dispose();
    videoIdController.dispose();
    super.dispose();
  }

  void updateValues() {
    setState(() {
      timeout = int.tryParse(timeoutController.text) ?? 60;
      videoId = videoIdController.text;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Settings Updated Successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      color: const Color(0xff1a1e22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabeledField(
            label: "Timeout (seconds)",
            controller: timeoutController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          _buildLabeledField(
            label: "Video ID",
            controller: videoIdController,
          ),
          const SizedBox(height: 16),
          _buildReadOnlyInfo("Video Player URL", videoPlayerUrl),
          const SizedBox(height: 16),
          const Text(
            "Video List",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          ...videoList.map(
                (video) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                video,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: updateValues,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff04bcb0),
            ),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField({
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
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Enter value",
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white54),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xff04bcb0)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyInfo(String label, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(color: Colors.blueAccent, fontSize: 13),
        ),
      ],
    );
  }
}
