import 'package:audio_rooms/screens/audio_room_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const AudioRooms());
}

class AudioRooms extends StatelessWidget {
  const AudioRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Audio Rooms',
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme().copyWith(
          bodyLarge: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
          bodyMedium: const TextStyle(
            fontSize: 18,
            color: Color(0xFF979797),
          ),
          displayLarge: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF333333),
          ),
          displayMedium: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black,
          ),
          displaySmall: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF333333),
          ),
        ),
        extensions: const <ThemeExtension<dynamic>>[],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xff005FFF),
        ),
        scaffoldBackgroundColor: const Color(0xFFDDDDDD),
        primaryColor: const Color(0xFF005FFF),
      ),
      home: const AudioRoomScreen(),
    );
  }
}
