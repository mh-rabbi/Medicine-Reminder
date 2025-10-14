// Flutter medicine reminder UI (single-file sample)
// Save as lib/main.dart in a new Flutter project.
// Dependencies to add in pubspec.yaml:
//   google_fonts: ^6.2.0
//   flutter_animate: ^4.5.0
//   intl: ^0.19.0
// Assets: optionally add a placeholder image at assets/medicine.png

// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:intl/intl.dart';
// import 'package:medicine_reminder/screens/intro_screen.dart';
//
// import 'database/alarm_db.dart';
// import 'models/alarm_model.dart';


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine_reminder/screens/intro_screen.dart';
import 'package:alarm/alarm.dart';
import 'screens/alarm_ring_screen.dart';
import 'screens/home_screen.dart'; // adjust path


final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init(); // initialize alarm plugin
  // optional: set wakelock behavior etc

  // listen for alarms (fires when alarm plugin triggers)
  Alarm.ringStream.stream.listen((alarmSettings) {
    // Use navigator key to show full-screen alarm UI even if app backgrounded
    navKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => AlarmRingScreen(alarmSettings: alarmSettings),
        fullscreenDialog: true,
      ),
    );
  });

  runApp(const MedReminderApp());
}

class MedReminderApp extends StatelessWidget {
  const MedReminderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey, // <-- important to navigate from background callback
      debugShowCheckedModeBanner: false,
      title: 'Medicine Reminder App',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        textTheme: GoogleFonts.poppinsTextTheme()
            .apply(bodyColor: Colors.black87, displayColor: Colors.black87),
      ),
      home: const IntroScreen(),
    );
  }
}












