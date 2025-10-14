import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:vibration/vibration.dart';
import '../database/alarm_db.dart';
import '../models/alarm_model.dart';

class AlarmRingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  const AlarmRingScreen({super.key, required this.alarmSettings});

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  bool _stopped = false;

  @override
  void initState() {
    super.initState();
    // ensure vibration (you can also rely on plugin's vibrate but double-check)
    _startVibrate();
  }

  Future<void> _startVibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      // pattern: vibrate 500ms, pause 500ms, repeat
      Vibration.vibrate(pattern: [0, 500, 500, 500], repeat: 1);
    }
  }

  Future<void> _stopVibrate() async {
    Vibration.cancel();
  }

  Future<void> _stopAlarmAndClose({bool markTaken = false, int snoozeMinutes = 0}) async {
    if (_stopped) return;
    setState(() => _stopped = true);

    try {
      await Alarm.stop(widget.alarmSettings.id); // stop plugin audio
    } catch (_) {}
    await _stopVibrate();

    // Update DB: mark taken/missed as you want
    final id = widget.alarmSettings.id;
    if (id != null) {
      // Example: fetch alarm, update status column or create history table
      // var alarmList = await AlarmDatabase.instance.fetchAlarms();
      // find alarm and update if needed
    }

    if (snoozeMinutes > 0) {
      // Reschedule snooze:
      final snoozeTime = DateTime.now().add(Duration(minutes: snoozeMinutes));
      final snoozeSettings = widget.alarmSettings.copyWith(
        dateTime: snoozeTime,
      );
      // set new alarm for snooze (keep same id or new id)
      await Alarm.set(alarmSettings: snoozeSettings);
    }

    // close ring screen
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
    final body = widget.alarmSettings.notificationBody ?? 'Time to take medicine';

    return WillPopScope(
      onWillPop: () async => false, // prevent back button dismiss
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(body, style: const TextStyle(fontSize: 16)),
                const Spacer(),
                ElevatedButton(
                  onPressed: () => _stopAlarmAndClose(markTaken: true),
                  child: const Text('Mark as Taken'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => _stopAlarmAndClose(snoozeMinutes: 10),
                  child: const Text('Snooze 10 min'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => _stopAlarmAndClose(markTaken: false),
                  child: const Text('Skip / Missed', style: TextStyle(color: Colors.red)),
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
  get notificationTitle => null;

  get notificationBody => null;
}
