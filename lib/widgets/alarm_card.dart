// // import 'package:flutter/material.dart';
// //
// // import '../constants/app_constants.dart';
// // import '../database/alarm_db.dart';
// //
// //
// // // ---------- WIDGETS ----------
// // class AlarmCard extends StatefulWidget {
// //
// //   final int id;
// //   final String name;
// //   final String time;
// //   final String note;
// //   final Color color;
// //   final bool isActive; // 🔹 Added field
// //   final String frequency; // 🔹 Needed for re-scheduling
// //   final VoidCallback? onTap;
// //   final VoidCallback? onDelete;
// //
// //
// //   const AlarmCard({super.key, required this.id, required this.name, required this.time, required this.note, required this.color,required this.frequency, required this.isActive, this.onTap, this.onDelete});
// //
// //   @override
// //   State<AlarmCard> createState() => _AlarmCardState();
// // }
// //
// // class _AlarmCardState extends State<AlarmCard> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return GestureDetector(
// //       onTap: widget.onTap,
// //       child: Container(
// //         padding: const EdgeInsets.all(14),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 16)],
// //         ),
// //         child: Row(
// //           children: [
// //             Container(
// //               width: 56,
// //               height: 56,
// //               decoration: BoxDecoration(color: widget.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
// //               child: Icon(Icons.medical_services, color: widget.color, size: 28),
// //             ),
// //             const SizedBox(width: 12),
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w600)),
// //                   const SizedBox(height: 4),
// //                   Text(widget.note, style: const TextStyle(fontSize: 12, color: Colors.black54)),
// //                 ],
// //               ),
// //             ),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.end,
// //               children: [
// //                 Text(widget.time, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
// //                 const SizedBox(height: 6),
// //                 Container(
// //                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
// //                   decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
// //                   child: const Icon(Icons.more_horiz, size: 16),
// //                 ),
// //                 IconButton(onPressed: widget.onDelete, // ✅ Let parent handle delete
// //                 //     () async{
// //                 //   await AlarmDatabase.instance.deleteAlarm(widget.id);
// //                 //   AppConstants.alarms.removeWhere((element) => element.id == widget.id);
// //                 //   setState(() {
// //                 //
// //                 //   });
// //                 // },
// //                     icon: Icon(Icons.delete, color: Colors.red,))
// //               ],
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
//
//
// // --------------------------------new alarm card for toggle --------------
// import 'package:alarm/alarm.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../constants/app_constants.dart';
// import '../database/alarm_db.dart';
// import '../models/alarm_model.dart';
//
// class AlarmCard extends StatefulWidget {
//   final int id;
//   final String name;
//   final String time;
//   final String note;
//   final Color color;
//   final bool isActive; // 🔹 Added field
//   final String frequency; // 🔹 Needed for re-scheduling
//   final String startDate;
//   final String endDate;
//   final VoidCallback? onTap;
//   final VoidCallback? onDelete;
//
//   const AlarmCard({
//     super.key,
//     required this.id,
//     required this.name,
//     required this.time,
//     required this.note,
//     required this.color,
//     required this.isActive, // 🔹 required
//     required this.frequency,
//     required this.startDate,
//     required this.endDate,
//     this.onTap,
//     this.onDelete,
//   });
//
//   @override
//   State<AlarmCard> createState() => _AlarmCardState();
// }
//
// class _AlarmCardState extends State<AlarmCard> {
//   late bool _isActive;
//
//   @override
//   void initState() {
//     super.initState();
//     _isActive = widget.isActive;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 16)],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 color: widget.color.withOpacity(0.12),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(Icons.medical_services, color: widget.color, size: 28),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 4),
//                   Text(widget.note,
//                       style: const TextStyle(fontSize: 12, color: Colors.black54)),
//                 ],
//               ),
//             ),
//
//             // 🔹 Right Side Controls
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(widget.time,
//                     style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
//                 const SizedBox(height: 4),
//
//                 // 🔹 Toggle Switch for Alarm Active / Inactive
//                 Switch(
//                   value: _isActive,
//                   activeColor: widget.color,
//                   onChanged: (val) async {
//                     setState(() => _isActive = val);
//                     await _toggleAlarm(val);
//                   },
//                 ),
//
//                 IconButton(
//                   onPressed: widget.onDelete,
//                   icon: const Icon(Icons.delete, color: Colors.red),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // 🔹 Helper to parse date+time string into DateTime
//   DateTime _combineDateAndTime(String dateStr, String timeStr, BuildContext context) {
//     final date = DateFormat('yyyy-MM-dd').parse(dateStr);
//     final time = TimeOfDay.fromDateTime(DateFormat.jm().parse(timeStr));
//     return DateTime(date.year, date.month, date.day, time.hour, time.minute);
//   }
//
//   // 🔹 Enable / Disable alarm logic
//   Future<void> _toggleAlarm(bool enable) async {
//     // Update DB
//     final updatedAlarm = AlarmModel(
//       id: widget.id,
//       name: widget.name,
//       note: widget.note,
//       time: widget.time,
//       frequency: widget.frequency,
//       startDate: widget.startDate,
//       endDate: widget.endDate,
//       soundPath: '',
//       isActive: enable,
//     );
//     await AlarmDatabase.instance.updateAlarm(updatedAlarm);
//
//     if (enable) {
//       // Schedule alarm again
//       final scheduledDate = _combineDateAndTime(widget.startDate, widget.time, context);
//
//       final alarmSettings = AlarmSettings(
//         id: widget.id,
//         dateTime: scheduledDate.isBefore(DateTime.now())
//             ? scheduledDate.add(const Duration(days: 1))
//             : scheduledDate,
//         assetAudioPath: 'assets/testalarm.mp3',
//         loopAudio: true,
//         vibrate: true,
//         notificationSettings: NotificationSettings(
//           title: widget.name,
//           body: 'Time to take your medicine',
//         ), volumeSettings: VolumeSettings.fade(fadeDuration: Duration(seconds: 1)),
//       );
//
//       await Alarm.set(alarmSettings: alarmSettings);
//     } else {
//       // Cancel alarm
//       await Alarm.stop(widget.id);
//     }
//
//     // Refresh App Constants list (optional)
//     AppConstants.alarms = await AlarmDatabase.instance.fetchAlarms();
//   }
// }
//
//


//--------------new updated features alarm card i have addded------------------//
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../constants/app_constants.dart';
import '../database/alarm_db.dart';
import '../models/alarm_model.dart';

class AlarmCard extends StatefulWidget {
  final int id;
  final String name;
  final List<String> times;
  final String note;
  final Color color;
  final bool isActive;
  final String frequency;
  final String startDate;
  final String endDate;
  final String medicineImagePath;
  final String foodTiming;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AlarmCard({
    super.key,
    required this.id,
    required this.name,
    required this.times,
    required this.note,
    required this.color,
    required this.isActive,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.medicineImagePath,
    required this.foodTiming,
    this.onTap,
    this.onDelete,
  });

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 16)],
        ),
        child: Row(
          children: [
            // Medicine Image or Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: widget.medicineImagePath.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(widget.medicineImagePath),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(Icons.medical_services, color: widget.color, size: 28),
                ),
              )
                  : Icon(Icons.medical_services, color: widget.color, size: 28),
            ),
            const SizedBox(width: 12),

            // Medicine Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.note,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  // Food timing badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: widget.foodTiming == 'Before Food'
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.foodTiming,
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.foodTiming == 'Before Food'
                            ? Colors.orange[700]
                            : Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Right Side Controls
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Multiple times display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.times.take(2).map((time) =>
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          time,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      )).toList()
                    ..addAll([
                      if (widget.times.length > 2)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '+${widget.times.length - 2} more',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ]),
                ),
                const SizedBox(height: 4),

                // Toggle Switch for Alarm Active / Inactive
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _isActive,
                    activeColor: widget.color,
                    onChanged: (val) async {
                      setState(() => _isActive = val);
                      await _toggleAlarm(val);
                    },
                  ),
                ),

                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper to parse date+time string into DateTime - FIXED VERSION
  DateTime _combineDateAndTime(String dateStr, String timeStr, BuildContext context) {
    try {
      final date = DateFormat('yyyy-MM-dd').parse(dateStr);

      // Parse time string safely
      final parts = timeStr.split(RegExp(r'[: ]'));
      int hour = int.parse(parts[0]);
      int minute = int.parse(parts[1]);

      // Handle AM/PM
      if (timeStr.toLowerCase().contains('pm') && hour != 12) {
        hour += 12;
      } else if (timeStr.toLowerCase().contains('am') && hour == 12) {
        hour = 0;
      }

      return DateTime(date.year, date.month, date.day, hour, minute);
    } catch (e) {
      // Fallback to current time if parsing fails
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, now.hour, now.minute);
    }
  }

  // Enable / Disable alarm logic - FIXED VERSION
  Future<void> _toggleAlarm(bool enable) async {
    try {
      // Update DB
      final updatedAlarm = AlarmModel(
        id: widget.id,
        name: widget.name,
        note: widget.note,
        times: widget.times,
        frequency: widget.frequency,
        startDate: widget.startDate,
        endDate: widget.endDate,
        soundPath: '',
        medicineImagePath: widget.medicineImagePath,
        foodTiming: widget.foodTiming,
        isActive: enable,
      );

      await AlarmDatabase.instance.updateAlarm(updatedAlarm);

      if (enable) {
        // Schedule alarm again for each time
        for (int i = 0; i < widget.times.length; i++) {
          final scheduledDate = _combineDateAndTime(widget.startDate, widget.times[i], context);

          final alarmSettings = AlarmSettings(
            id: widget.id + i * 100000,
            dateTime: scheduledDate.isBefore(DateTime.now())
                ? scheduledDate.add(const Duration(days: 1))
                : scheduledDate,
            assetAudioPath: 'assets/testalarm.mp3',
            loopAudio: true,
            vibrate: true,
            notificationSettings: NotificationSettings(
              title: widget.name,
              body: 'Time to take your medicine - ${widget.foodTiming}',
            ),
            volumeSettings: VolumeSettings.fade(fadeDuration: const Duration(seconds: 1)),
          );

          await Alarm.set(alarmSettings: alarmSettings);
        }
      } else {
        // Cancel all alarms for this medicine
        for (int i = 0; i < widget.times.length; i++) {
          await Alarm.stop(widget.id + i * 100000);
        }
      }

      // Refresh App Constants list
      AppConstants.alarms = await AlarmDatabase.instance.fetchAlarms();
    } catch (e) {
      print('Error toggling alarm: $e');
      // Revert the switch if there was an error
      setState(() => _isActive = !enable);
    }
  }
}