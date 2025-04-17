import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../addon/provider.dart'; // Adjust import path if needed

class DynamicWcdmaCellInfoPage extends StatefulWidget {
  @override
  _DynamicWcdmaCellInfoPageState createState() =>
      _DynamicWcdmaCellInfoPageState();
}

class _DynamicWcdmaCellInfoPageState extends State<DynamicWcdmaCellInfoPage> {
  // Variables to store user input
  String antBw = "";
  String cellName = "";
  String ch = "";
  String dir = "";
  String lac = "";
  String lat = "";
  String lon = "";
  String mcc = "";
  String mnc = "";
  String rac = "";
  String scr = "";
  String site = "";

  // Controllers for text fields
  final TextEditingController antBwController = TextEditingController();
  final TextEditingController cellNameController = TextEditingController();
  final TextEditingController chController = TextEditingController();
  final TextEditingController dirController = TextEditingController();
  final TextEditingController lacController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lonController = TextEditingController();
  final TextEditingController mccController = TextEditingController();
  final TextEditingController mncController = TextEditingController();
  final TextEditingController racController = TextEditingController();
  final TextEditingController scrController = TextEditingController();
  final TextEditingController siteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    antBwController.dispose();
    cellNameController.dispose();
    chController.dispose();
    dirController.dispose();
    lacController.dispose();
    latController.dispose();
    lonController.dispose();
    mccController.dispose();
    mncController.dispose();
    racController.dispose();
    scrController.dispose();
    siteController.dispose();
    super.dispose();
  }

  // Load saved values from SharedPreferences
  _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      antBw = prefs.getString('antBw') ?? "";
      cellName = prefs.getString('cellName') ?? "";
      ch = prefs.getString('ch') ?? "";
      dir = prefs.getString('dir') ?? "";
      lac = prefs.getString('lac') ?? "";
      lat = prefs.getString('lat') ?? "";
      lon = prefs.getString('lon') ?? "";
      mcc = prefs.getString('mcc') ?? "";
      mnc = prefs.getString('mnc') ?? "";
      rac = prefs.getString('rac') ?? "";
      scr = prefs.getString('scr') ?? "";
      site = prefs.getString('site') ?? "";
      // Set the text controllers
      antBwController.text = antBw;
      cellNameController.text = cellName;
      chController.text = ch;
      dirController.text = dir;
      lacController.text = lac;
      latController.text = lat;
      lonController.text = lon;
      mccController.text = mcc;
      mncController.text = mnc;
      racController.text = rac;
      scrController.text = scr;
      siteController.text = site;
    });
  }

  // Save values to SharedPreferences
  _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('antBw', antBw);
    await prefs.setString('cellName', cellName);
    await prefs.setString('ch', ch);
    await prefs.setString('dir', dir);
    await prefs.setString('lac', lac);
    await prefs.setString('lat', lat);
    await prefs.setString('lon', lon);
    await prefs.setString('mcc', mcc);
    await prefs.setString('mnc', mnc);
    await prefs.setString('rac', rac);
    await prefs.setString('scr', scr);
    await prefs.setString('site', site);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1a1e22),
      body: Center(
        child: Container(
          width: 350,
          height: double.infinity,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCustomTextField("Ant BW", antBwController),
                _buildCustomTextField("Cell Name", cellNameController),
                _buildCustomTextField("Ch", chController),
                _buildCustomTextField("Dir", dirController),
                _buildCustomTextField("LAC", lacController),
                _buildCustomTextField("Lat", latController),
                _buildCustomTextField("Lon", lonController),
                _buildCustomTextField("MCC", mccController),
                _buildCustomTextField("MNC", mncController),
                _buildCustomTextField("RAC", racController),
                _buildCustomTextField("SCR", scrController),
                _buildCustomTextField("Site", siteController),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _savePreferences(); // Save to shared preferences

                      // Add to Provider state (or any other state management method you're using)
                      Provider.of<SaveCardState>(context, listen: false).addCard(
                        cardOutput(
                          antBw: antBw,
                          cellName: cellName,
                          ch: ch,
                          dir: dir,
                          lac: lac,
                          lat: lat,
                          lon: lon,
                          mcc: mcc,
                          mnc: mnc,
                          rac: rac,
                          scr: scr,
                          site: site,
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
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 8),
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
        ),
      ),
    );
  }

  Widget _buildCustomTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          hintText: 'Enter $label',
          hintStyle: const TextStyle(color: Colors.white38),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white38),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xff04bcb0)),
          ),
        ),
        onChanged: (val) {
          setState(() {
            // Update the respective variable based on the field
            if (label == "Ant BW") antBw = val;
            if (label == "Cell Name") cellName = val;
            if (label == "Ch") ch = val;
            if (label == "Dir") dir = val;
            if (label == "LAC") lac = val;
            if (label == "Lat") lat = val;
            if (label == "Lon") lon = val;
            if (label == "MCC") mcc = val;
            if (label == "MNC") mnc = val;
            if (label == "RAC") rac = val;
            if (label == "SCR") scr = val;
            if (label == "Site") site = val;
          });
        },
      ),
    );
  }
}

// ✅ Card Output Widget (display saved data)
Widget cardOutput({
  required String antBw,
  required String cellName,
  required String ch,
  required String dir,
  required String lac,
  required String lat,
  required String lon,
  required String mcc,
  required String mnc,
  required String rac,
  required String scr,
  required String site,
}) {
  return Card(
    color: const Color(0xff101f1f),
    elevation: 5,
    child: ListTile(
      title: const Text("WCDMA Cell Info", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ant BW: $antBw", style: const TextStyle(color: Colors.white)),
          Text("Cell Name: $cellName", style: const TextStyle(color: Colors.white)),
          Text("Ch: $ch", style: const TextStyle(color: Colors.white)),
          Text("Dir: $dir", style: const TextStyle(color: Colors.white)),
          Text("LAC: $lac", style: const TextStyle(color: Colors.white)),
          Text("Lat: $lat", style: const TextStyle(color: Colors.white)),
          Text("Lon: $lon", style: const TextStyle(color: Colors.white)),
          Text("MCC: $mcc", style: const TextStyle(color: Colors.white)),
          Text("MNC: $mnc", style: const TextStyle(color: Colors.white)),
          Text("RAC: $rac", style: const TextStyle(color: Colors.white)),
          Text("SCR: $scr", style: const TextStyle(color: Colors.white)),
          Text("Site: $site", style: const TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}
