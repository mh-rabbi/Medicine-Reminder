import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_constants.dart';
import '../database/alarm_db.dart';
import '../models/alarm_model.dart';
import '../utils/app_colors.dart';
import '../widgets/gradient_button.dart';
import 'home_screen.dart';



// ---------- ADD / EDIT ALARM SCREEN ----------
class AddAlarmScreen extends StatefulWidget {
  const AddAlarmScreen({super.key});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _doseCtrl = TextEditingController();

  TimeOfDay _time = TimeOfDay.now();
  String _freq = 'Daily';
  DateTime _startDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Add Medicine', style: TextStyle(color: Colors.black87)),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.black87)),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: Colors.black54))],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          children: [
            // top illustration
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 18)],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 96,
                    child: Image.asset('assets/medicine.png', errorBuilder: (c, e, s) => const Icon(Icons.medical_services_outlined, size: 72, color: AppColors.primary)),
                  ),
                  const SizedBox(height: 12),

                  // Form fields
                  _buildTextField('Pill name', controller: _nameCtrl, hint: 'Enter the pill name'),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _buildTextField('Dose', controller: _doseCtrl, hint: '0.5')),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDropdown('Frequency', _freq, ['Daily', 'Weekly', 'Monthly', 'Custom'], (val) => setState(() => _freq = val!)),
                      )
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _buildTimePicker()),
                      const SizedBox(width: 8),
                      Expanded(child: _buildDatePicker()),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // sound picker placeholder
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tileColor: Colors.grey[100],
                    leading: const Icon(Icons.music_note_outlined),
                    title: const Text('Alarm sound'),
                    subtitle: const Text('Default tone'),
                    trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
                  ),

                  const SizedBox(height: 18),


                  // Add button
                  GradientButton(
                    text: 'Add Medicine',
                    onPressed: () async {
                      // In real app: validate and save to DB

                      // 2. Simple validation
                      if (_nameCtrl.text.isEmpty ||  _freq.isEmpty || _time.toString().isEmpty || _startDate.toString().isEmpty || _doseCtrl.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all required fields')),
                        );
                        return;
                      }

                      //Insert into local DB first to get id
                      // 3. Create AlarmModel instance
                      final newAlarm = AlarmModel(
                        name: _nameCtrl.text,
                        note: _doseCtrl.text,
                        time: _time.format(context), // store human readable too
                        frequency: _freq.toString(),
                        startDate: DateFormat('yyyy-MM-dd').format(_startDate),
                        soundPath: "",// fill if user picks sound
                        isActive: true,
                      );

                      // 4. Insert into database // var can be chage with final keyword
                      var alarmData = await AlarmDatabase.instance.insertAlarm(newAlarm);

                      // 5) Re-fetch alarms to update app-level list
                      AppConstants.alarms = await AlarmDatabase.instance.fetchAlarms();

                      // newly add things for alarm
                      // 4) Build DateTime for first alarm occurrence
                      // convert TimeOfDay + startDate to DateTime
                      final parts = _time.format(context).split(RegExp(r'[: ]')); // fragile, better build from _time
                      final int hour = _time.hour;
                      final int minute = _time.minute;
                      DateTime scheduledDate = DateTime(
                        _startDate.year,
                        _startDate.month,
                        _startDate.day,
                        hour,
                        minute,
                      );

                      // If scheduledDate is in the past, for one-time alarms push next day
                      if (scheduledDate.isBefore(DateTime.now())) {
                        // depending on frequency you might shift to next valid day — for now add 1 day
                        scheduledDate = scheduledDate.add(const Duration(days: 1));
                      }

                      // 5) Create AlarmSettings for the alarm plugin
                      final alarmSettings = AlarmSettings(
                      id: alarmData, // important
                      dateTime: scheduledDate,
                      assetAudioPath: 'assets/testalarm.mp3', // if you ship an asset audio; else use audioPath
                      loopAudio: true, // keep ringing until stopped
                      vibrate: true,
                        volumeSettings: VolumeSettings.fade(fadeDuration: Duration(seconds: 1)),
                        notificationSettings: NotificationSettings.fromJson(
                          {
                            "title": _nameCtrl.text,
                            "body": "I want to wake up",
                          }
                        ),  // show notification if app killed
                      );

                      // 6) Schedule with plugin
                      await Alarm.set(alarmSettings: alarmSettings);

                      setState(() {

                      });


                      // 5. Optional: refresh list or notify parent

                      // 6. Close the add medicine screen
                      // Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                      );
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {TextEditingController? controller, String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        )
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Time', style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickTime,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(_time.format(context)), const Icon(Icons.access_time)],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Start Date', style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(DateFormat.yMMMd().format(_startDate)), const Icon(Icons.calendar_today_outlined)],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _time);
    if (t != null) setState(() => _time = t);
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(context: context, initialDate: _startDate, firstDate: DateTime(2020), lastDate: DateTime(2100));
    if (d != null) setState(() => _startDate = d);
  }
}