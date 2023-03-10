import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_drift/widgets/bg.dart';

class MostlyPlayed extends StatelessWidget {
  const MostlyPlayed({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: linearGradient()),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Mostly Played',
            style: GoogleFonts.iceberg(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 25,
                letterSpacing: 2,
                fontStyle: FontStyle.italic),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
