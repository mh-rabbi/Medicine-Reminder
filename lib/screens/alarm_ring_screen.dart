// import 'package:flutter/material.dart';
// import 'package:alarm/alarm.dart';
// import 'package:vibration/vibration.dart';
// import '../database/alarm_db.dart';
// import '../models/alarm_model.dart';
//
// class AlarmRingScreen extends StatefulWidget {
//   final AlarmSettings alarmSettings;
//   const AlarmRingScreen({super.key, required this.alarmSettings});
//
//   @override
//   State<AlarmRingScreen> createState() => _AlarmRingScreenState();
// }
//
// class _AlarmRingScreenState extends State<AlarmRingScreen> {
//   bool _stopped = false;
//
//   @override
//   void initState() {
//     super.initState();
//     // ensure vibration (you can also rely on plugin's vibrate but double-check)
//     _startVibrate();
//   }
//
//   Future<void> _startVibrate() async {
//     if (await Vibration.hasVibrator() ?? false) {
//       // pattern: vibrate 500ms, pause 500ms, repeat
//       Vibration.vibrate(pattern: [0, 500, 500, 500], repeat: 1);
//     }
//   }
//
//   Future<void> _stopVibrate() async {
//     Vibration.cancel();
//   }
//
//   Future<void> _stopAlarmAndClose({bool markTaken = false, int snoozeMinutes = 0}) async {
//     if (_stopped) return;
//     setState(() => _stopped = true);
//
//     try {
//       await Alarm.stop(widget.alarmSettings.id); // stop plugin audio
//     } catch (_) {}
//     await _stopVibrate();
//
//     // Update DB: mark taken/missed as you want
//     final id = widget.alarmSettings.id;
//     if (id != null) {
//       // Example: fetch alarm, update status column or create history table
//       // var alarmList = await AlarmDatabase.instance.fetchAlarms();
//       // find alarm and update if needed
//     }
//
//     if (snoozeMinutes > 0) {
//       // Reschedule snooze:
//       final snoozeTime = DateTime.now().add(Duration(minutes: snoozeMinutes));
//       final snoozeSettings = widget.alarmSettings.copyWith(
//         dateTime: snoozeTime,
//       );
//       // set new alarm for snooze (keep same id or new id)
//       await Alarm.set(alarmSettings: snoozeSettings);
//     }
//
//     // close ring screen
//     if (mounted) Navigator.of(context).pop();
//   }
//
//   @override
//   void dispose() {
//     _stopVibrate();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final title = widget.alarmSettings.notificationTitle ?? 'Medicine Reminder';
//     final body = widget.alarmSettings.notificationBody ?? 'Time to take medicine';
//
//     return WillPopScope(
//       onWillPop: () async => false, // prevent back button dismiss
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               children: [
//                 const SizedBox(height: 40),
//                 Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 12),
//                 Text(body, style: const TextStyle(fontSize: 16)),
//                 const Spacer(),
//                 ElevatedButton(
//                   onPressed: () => _stopAlarmAndClose(markTaken: true),
//                   child: const Text('Mark as Taken'),
//                 ),
//                 const SizedBox(height: 12),
//                 ElevatedButton(
//                   onPressed: () => _stopAlarmAndClose(snoozeMinutes: 10),
//                   child: const Text('Snooze 10 min'),
//                 ),
//                 const SizedBox(height: 12),
//                 TextButton(
//                   onPressed: () => _stopAlarmAndClose(markTaken: false),
//                   child: const Text('Skip / Missed', style: TextStyle(color: Colors.red)),
//                 ),
//                 const SizedBox(height: 40),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// extension on AlarmSettings {
//   get notificationTitle => null;
//
//   get notificationBody => null;
// }


//------------new updated rigining screen to show food beofre or after-------------//
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:vibration/vibration.dart';
import '../database/alarm_db.dart';
import '../models/alarm_model.dart';
import 'dart:io';

class AlarmRingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({super.key, required this.alarmSettings});

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  bool _stopped = false;
  AlarmModel? _medicineDetails;

  @override
  void initState() {
    super.initState();
    _startVibrate();
    _loadMedicineDetails();
  }

  Future<void> _loadMedicineDetails() async {
    try {
      // Extract base ID (remove the time offset)
      final baseId = widget.alarmSettings.id % 100000;
      final alarm = await AlarmDatabase.instance.fetchAlarmById(baseId);

      if (alarm != null && mounted) {
        setState(() {
          _medicineDetails = alarm;
        });
      }
    } catch (e) {
      print('Error loading medicine details: $e');
    }
  }

  Future<void> _startVibrate() async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        // Pattern: vibrate 500ms, pause 500ms, repeat
        Vibration.vibrate(pattern: [0, 500, 500, 500], repeat: 1);
      }
    } catch (e) {
      print('Vibration error: $e');
    }
  }

  Future<void> _stopVibrate() async {
    try {
      Vibration.cancel();
    } catch (e) {
      print('Error stopping vibration: $e');
    }
  }

  Future<void> _stopAlarmAndClose({bool markTaken = false, int snoozeMinutes = 0}) async {
    if (_stopped) return;
    setState(() => _stopped = true);

    try {
      await Alarm.stop(widget.alarmSettings.id); // Stop plugin audio
    } catch (e) {
      print('Error stopping alarm: $e');
    }

    await _stopVibrate();

    // Handle snooze
    if (snoozeMinutes > 0) {
      try {
        // Reschedule snooze
        final snoozeTime = DateTime.now().add(Duration(minutes: snoozeMinutes));
        final snoozeSettings = AlarmSettings(
          id: widget.alarmSettings.id + 50000, // Different ID for snooze
          dateTime: snoozeTime,
          assetAudioPath: widget.alarmSettings.assetAudioPath,
          loopAudio: widget.alarmSettings.loopAudio,
          vibrate: widget.alarmSettings.vibrate,
          volumeSettings: widget.alarmSettings.volumeSettings,
          notificationSettings: NotificationSettings(
            title: widget.alarmSettings.notificationTitle ?? 'Medicine Reminder',
            body: 'Snooze reminder - Time to take your medicine',
            stopButton: 'Stop',
          ),
        );

        // Set new alarm for snooze
        await Alarm.set(alarmSettings: snoozeSettings);
      } catch (e) {
        print('Error setting snooze: $e');
      }
    }

    // TODO: Update medication history/tracking here if needed

    // Close ring screen
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _stopVibrate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.alarmSettings.notificationTitle ?? 'Medicine Reminder';
    final medicineDetails = _medicineDetails;

    return PopScope(
      canPop: false, // Prevent back button dismiss
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Medicine Image
                if (medicineDetails?.medicineImagePath != null &&
                    medicineDetails!.medicineImagePath.isNotEmpty)
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(medicineDetails!.medicineImagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.medical_services, size: 60, color: Colors.blue),
                            ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.medical_services, size: 60, color: Colors.blue),
                  ),

                const SizedBox(height: 24),

                // Medicine Name
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Current Time
                Text(
                  'Time: ${TimeOfDay.now().format(context)}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 12),

                // Dosage Information
                if (medicineDetails?.note != null && medicineDetails!.note.isNotEmpty)
                  Text(
                    'Dosage: ${medicineDetails!.note}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),

                const SizedBox(height: 16),

                // Food Timing Badge
                if (medicineDetails?.foodTiming != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: medicineDetails!.foodTiming == 'Before Food'
                          ? Colors.orange.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: medicineDetails!.foodTiming == 'Before Food'
                            ? Colors.orange
                            : Colors.green,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          medicineDetails!.foodTiming == 'Before Food'
                              ? Icons.restaurant_menu
                              : Icons.restaurant,
                          color: medicineDetails!.foodTiming == 'Before Food'
                              ? Colors.orange[700]
                              : Colors.green[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Take ${medicineDetails!.foodTiming}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: medicineDetails!.foodTiming == 'Before Food'
                                ? Colors.orange[700]
                                : Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Action Buttons
                Column(
                  children: [
                    // Mark as Taken Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _stopAlarmAndClose(markTaken: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, size: 24),
                            SizedBox(width: 8),
                            Text('Mark as Taken', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Snooze Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => _stopAlarmAndClose(snoozeMinutes: 10),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 1,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.snooze, size: 20),
                            SizedBox(width: 8),
                            Text('Snooze 10 min', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Skip/Missed Button
                    TextButton(
                      onPressed: () => _stopAlarmAndClose(markTaken: false),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.close, size: 20),
                          SizedBox(width: 8),
                          Text('Skip / Missed', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on AlarmSettings {
  get notificationTitle => notificationSettings.title;
}