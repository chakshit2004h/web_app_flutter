import 'package:flutter/material.dart';

class WifiScanPage extends StatefulWidget {
  @override
  _WifiScanPageState createState() => _WifiScanPageState();
}

class _WifiScanPageState extends State<WifiScanPage> {
  bool isEnable = true;
  String statusMessage = 'Wi-Fi scan is disabled';
  List<String> availableNetworks = [];

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

  @override
  void initState() {
    super.initState();
    _startWifiScan();
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
            Text(
              'Wi-Fi Scan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xff2c2f33),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                statusMessage,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (availableNetworks.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xff2c2f33),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: availableNetworks.map((network) {
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
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isEnable = !isEnable;
                  });
                  _startWifiScan();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff04bcb0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isEnable ? Icons.wifi_off : Icons.wifi,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEnable ? 'Disable Wi-Fi Scan' : 'Enable Wi-Fi Scan',
                      style: const TextStyle(
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
}
