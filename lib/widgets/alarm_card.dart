// import 'package:flutter/material.dart';
//
// import '../constants/app_constants.dart';
// import '../database/alarm_db.dart';
//
//
// // ---------- WIDGETS ----------
// class AlarmCard extends StatefulWidget {
//
//   final int id;
//   final String name;
//   final String time;
//   final String note;
//   final Color color;
//   final bool isActive; // 🔹 Added field
//   final String frequency; // 🔹 Needed for re-scheduling
//   final VoidCallback? onTap;
//   final VoidCallback? onDelete;
//
//
//   const AlarmCard({super.key, required this.id, required this.name, required this.time, required this.note, required this.color,required this.frequency, required this.isActive, this.onTap, this.onDelete});
//
//   @override
//   State<AlarmCard> createState() => _AlarmCardState();
// }
//
// class _AlarmCardState extends State<AlarmCard> {
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
//               decoration: BoxDecoration(color: widget.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
//               child: Icon(Icons.medical_services, color: widget.color, size: 28),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w600)),
//                   const SizedBox(height: 4),
//                   Text(widget.note, style: const TextStyle(fontSize: 12, color: Colors.black54)),
//                 ],
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(widget.time, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
//                 const SizedBox(height: 6),
//                 Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//                   decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
//                   child: const Icon(Icons.more_horiz, size: 16),
//                 ),
//                 IconButton(onPressed: widget.onDelete, // ✅ Let parent handle delete
//                 //     () async{
//                 //   await AlarmDatabase.instance.deleteAlarm(widget.id);
//                 //   AppConstants.alarms.removeWhere((element) => element.id == widget.id);
//                 //   setState(() {
//                 //
//                 //   });
//                 // },
//                     icon: Icon(Icons.delete, color: Colors.red,))
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//


// --------------------------------new alarm card for toggle --------------
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_constants.dart';
import '../database/alarm_db.dart';
import '../models/alarm_model.dart';

class AlarmCard extends StatefulWidget {
  final int id;
  final String name;
  final String time;
  final String note;
  final Color color;
  final bool isActive; // 🔹 Added field
  final String frequency; // 🔹 Needed for re-scheduling
  final String startDate;
  final String endDate;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AlarmCard({
    super.key,
    required this.id,
    required this.name,
    required this.time,
    required this.note,
    required this.color,
    required this.isActive, // 🔹 required
    required this.frequency,
    required this.startDate,
    required this.endDate,
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
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.medical_services, color: widget.color, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(widget.note,
                      style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),

            // 🔹 Right Side Controls
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.time,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 4),

                // 🔹 Toggle Switch for Alarm Active / Inactive
                Switch(
                  value: _isActive,
                  activeColor: widget.color,
                  onChanged: (val) async {
                    setState(() => _isActive = val);
                    await _toggleAlarm(val);
                  },
                ),

                IconButton(
                  onPressed: widget.onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper to parse date+time string into DateTime
  DateTime _combineDateAndTime(String dateStr, String timeStr, BuildContext context) {
    final date = DateFormat('yyyy-MM-dd').parse(dateStr);
    final time = TimeOfDay.fromDateTime(DateFormat.jm().parse(timeStr));
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // 🔹 Enable / Disable alarm logic
  Future<void> _toggleAlarm(bool enable) async {
    // Update DB
    final updatedAlarm = AlarmModel(
      id: widget.id,
      name: widget.name,
      note: widget.note,
      time: widget.time,
      frequency: widget.frequency,
      startDate: widget.startDate,
      endDate: widget.endDate,
      soundPath: '',
      isActive: enable,
    );
    await AlarmDatabase.instance.updateAlarm(updatedAlarm);

    if (enable) {
      // Schedule alarm again
      final scheduledDate = _combineDateAndTime(widget.startDate, widget.time, context);

      final alarmSettings = AlarmSettings(
        id: widget.id,
        dateTime: scheduledDate.isBefore(DateTime.now())
            ? scheduledDate.add(const Duration(days: 1))
            : scheduledDate,
        assetAudioPath: 'assets/testalarm.mp3',
        loopAudio: true,
        vibrate: true,
        notificationSettings: NotificationSettings(
          title: widget.name,
          body: 'Time to take your medicine',
        ), volumeSettings: VolumeSettings.fade(fadeDuration: Duration(seconds: 1)),
      );

      await Alarm.set(alarmSettings: alarmSettings);
    } else {
      // Cancel alarm
      await Alarm.stop(widget.id);
    }

    // Refresh App Constants list (optional)
    AppConstants.alarms = await AlarmDatabase.instance.fetchAlarms();
  }
}


