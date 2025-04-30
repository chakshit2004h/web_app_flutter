import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../addon/provider.dart'; // Adjust path as needed

class WifiScanPage extends StatefulWidget {
  @override
  _WifiScanPageState createState() => _WifiScanPageState();
}

class _WifiScanPageState extends State<WifiScanPage> {
  bool isEnable = true;
  String statusMessage = 'Wi-Fi scan is disabled';
  List<String> availableNetworks = [];
  List<String> savedNetworks = [];

  @override
  void initState() {
    super.initState();
    _loadSavedNetworks();
    _startWifiScan();
  }

  Future<void> _loadSavedNetworks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedNetworks = prefs.getStringList('savedNetworks') ?? [];
    });
  }

  Future<void> _saveNetworks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedNetworks', availableNetworks);
    setState(() {
      savedNetworks = List.from(availableNetworks);
    });

    // Save to provider
    Provider.of<SaveCardState>(context, listen: false).addCard(
      _buildCardOutput(
        wifiEnabled: isEnable,
        networks: availableNetworks,
        status: statusMessage,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Networks saved successfully!')),
    );
  }

  void _startWifiScan() {
    if (isEnable) {
      setState(() {
        statusMessage = 'Wi-Fi scan is enabled! Scanning for networks...';
      });

      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          availableNetworks = ['Network 1', 'Network 2', 'Network 3', 'Network 4'];
          statusMessage = 'Scan complete! Found ${availableNetworks.length} networks.';
        });
      });
    } else {
      setState(() {
        statusMessage = 'Wi-Fi scan is disabled!';
        availableNetworks = [];
      });
    }
  }

  Widget _buildCardOutput({
    required bool wifiEnabled,
    required List<String> networks,
    required String status,
  }) {
    return Card(
      color: const Color(0xff101f1f),
      elevation: 5,
      child: ListTile(
        title: const Text("Wi-Fi Scan Info", style: TextStyle(color: Colors.white)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Wi-Fi Enabled: ${wifiEnabled ? 'Yes' : 'No'}", style: const TextStyle(color: Colors.white)),
            Text("Status: $status", style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 10),
            if (networks.isNotEmpty)
              Text("Available Networks:", style: const TextStyle(color: Colors.white)),
            ...networks.map((network) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(network, style: const TextStyle(color: Colors.white)),
            )).toList(),
          ],
        ),
      ),
    );
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
            _buildSwitch("Enable Wi-Fi Scan", isEnable, (value) {
              setState(() {
                isEnable = value;
              });
              _startWifiScan();
            }),
            const SizedBox(height: 20),
            _buildStatusBox("Status", statusMessage),
            const SizedBox(height: 20),
            if (availableNetworks.isNotEmpty)
              _buildNetworkList("Available Networks", availableNetworks),
            const SizedBox(height: 20),
            if (savedNetworks.isNotEmpty)
              _buildNetworkList("Saved Networks", savedNetworks),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _saveNetworks,
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

  Widget _buildSwitch(String label, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.teal,
        ),
      ],
    );
  }

  Widget _buildStatusBox(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xff2c2f33),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        content,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildNetworkList(String title, List<String> networks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xff2c2f33),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: networks.map((network) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  network,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
