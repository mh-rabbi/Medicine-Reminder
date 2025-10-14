import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../database/alarm_db.dart';


// ---------- WIDGETS ----------
class AlarmCard extends StatefulWidget {
  final int id;
  final String name;
  final String time;
  final String note;
  final Color color;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const AlarmCard({super.key, required this.id, required this.name, required this.time, required this.note, required this.color, this.onTap, this.onDelete});

  @override
  State<AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<AlarmCard> {
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
              decoration: BoxDecoration(color: widget.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(Icons.medical_services, color: widget.color, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(widget.note, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(widget.time, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.more_horiz, size: 16),
                ),
                IconButton(onPressed: widget.onDelete, // ✅ Let parent handle delete
                //     () async{
                //   await AlarmDatabase.instance.deleteAlarm(widget.id);
                //   AppConstants.alarms.removeWhere((element) => element.id == widget.id);
                //   setState(() {
                //
                //   });
                // },
                    icon: Icon(Icons.delete, color: Colors.red,))
              ],
            )
          ],
        ),
      ),
    );
  }
}

