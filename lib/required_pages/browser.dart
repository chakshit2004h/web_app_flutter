import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class BrowserPage extends StatefulWidget {
  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage>
    with SingleTickerProviderStateMixin {
  late final WebViewController _controller;
  late Map<String, TextEditingController> textControllers;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  Map<String, dynamic> browserSettings = {
    "dnsResolveTimeout": 0.0,
    "isCollectTcpDump": false,
    "isEnableJavaScript": true,
    "isRequestDesktopSite": false,
    "timeout": 180,
    "url": "http://www.azenqos.com"
  };

  @override
  void initState() {
    super.initState();
    textControllers = {
      "timeout": TextEditingController(text: browserSettings["timeout"].toString()),
      "url": TextEditingController(text: browserSettings["url"])
    };
    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
    _initializeWebView();
    _loadPreferences();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(browserSettings["isEnableJavaScript"]
          ? JavaScriptMode.unrestricted
          : JavaScriptMode.disabled)
      ..loadRequest(Uri.parse(browserSettings["url"]));
  }

  void _updateWebView() {
    _controller.loadRequest(Uri.parse(browserSettings["url"]));
    _controller.setJavaScriptMode(browserSettings["isEnableJavaScript"]
        ? JavaScriptMode.unrestricted
        : JavaScriptMode.disabled);
  }

  // Load saved preferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      browserSettings["timeout"] = prefs.getInt('timeout') ?? 180;
      browserSettings["url"] = prefs.getString('url') ?? "http://www.azenqos.com";
      browserSettings["isEnableJavaScript"] = prefs.getBool('isEnableJavaScript') ?? true;
      browserSettings["isRequestDesktopSite"] = prefs.getBool('isRequestDesktopSite') ?? false;
      textControllers["timeout"]!.text = browserSettings["timeout"].toString();
      textControllers["url"]!.text = browserSettings["url"];
    });
  }

  // Save preferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('timeout', browserSettings["timeout"]);
    await prefs.setString('url', browserSettings["url"]);
    await prefs.setBool('isEnableJavaScript', browserSettings["isEnableJavaScript"]);
    await prefs.setBool('isRequestDesktopSite', browserSettings["isRequestDesktopSite"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Browser"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _updateWebView,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSettingsPanel(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 600),
                  tween: Tween(begin: 0.0, end: 1.0),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: child,
                    );
                  },
                  child: ElevatedButton(
                    onPressed: () {
                      _savePreferences(); // Save preferences
                      // Optionally, add to provider state
                      Provider.of<SaveCardState>(context, listen: false)
                          .addCard(cardOutput(url: browserSettings["url"], timeout: browserSettings["timeout"]));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff04bcb0),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      shadowColor: Colors.black.withOpacity(0.2),
                      elevation: 5,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Save',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return Container(
      padding: EdgeInsets.all(10),
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 400),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: Column(
          key: ValueKey(browserSettings.toString()),
          children: browserSettings.keys.map((key) {
            final value = browserSettings[key];

            if (value is bool) {
              return SwitchListTile(
                activeColor: Color(0xff04bcb0),
                title: Text(key),
                value: value,
                onChanged: (newValue) {
                  setState(() {
                    browserSettings[key] = newValue;
                    if (key == "isEnableJavaScript") {
                      _controller.setJavaScriptMode(newValue
                          ? JavaScriptMode.unrestricted
                          : JavaScriptMode.disabled);
                      _controller.reload();
                    } else if (key == "isRequestDesktopSite") {
                      _controller.setUserAgent(newValue
                          ? "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
                          : "");
                    }
                  });
                },
              );
            } else if (value is String || value is int) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: TextField(
                  controller: textControllers[key],
                  decoration: InputDecoration(
                    labelText: key,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: value is int
                      ? TextInputType.number
                      : TextInputType.text,
                  onSubmitted: (newValue) {
                    setState(() {
                      browserSettings[key] =
                      value is int ? int.tryParse(newValue) ?? value : newValue;
                      if (key == "url") _updateWebView();
                    });
                  },
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }).toList(),
        ),
      ),
    );
  }
}

// ✅ Card Output Widget
Widget cardOutput({
  required String url,
  required int timeout,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("Browser Settings", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("URL: $url", style: const TextStyle(color: Colors.white)),
          Text("Timeout: $timeout", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
