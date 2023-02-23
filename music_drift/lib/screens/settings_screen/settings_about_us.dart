import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs {
  aboutUs(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 46, 4, 53),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "About Us",
                  style: GoogleFonts.iceberg(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                // Text(
                //   "V.1.0.0",
                //   style: TextStyle(
                //       color: Colors.white, fontWeight: FontWeight.bold),
                // ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    '''Welcome To Music Drift
            Music Drift is a sleek and easy-to-use music player designed to enhance your listening experience.
            With Music Drift, you can create playlists, shuffle songs, and browse your music library with ease.
            Music Drift is the perfect choice for those who want to enjoy their music offline, without worrying about internet connectivity or data charges.
            Music Drift is designed to provide a seamless listening experience, with quick access to your recently played tracks and the ability to search for your favorite songs by artist, album, or genre.
         
            Please give your support and love.''',

                    // style: TextStyle(
                    //   color: Colors.white,
                    // ),
                    style: GoogleFonts.iceberg(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Made with love from ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: 'Brocamp',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
