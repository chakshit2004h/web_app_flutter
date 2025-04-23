import 'package:flutter/material.dart';

class Trasroute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: double.infinity,
      color: const Color(0xff1a1e22),
      child: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text('Save', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xff04bcb0),
          ),
        ),
      ),
    );
  }
}
