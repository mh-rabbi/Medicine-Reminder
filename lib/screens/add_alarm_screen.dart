// // import 'package:alarm/alarm.dart';
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// //
// // import '../constants/app_constants.dart';
// // import '../database/alarm_db.dart';
// // import '../models/alarm_model.dart';
// // import '../utils/app_colors.dart';
// // import '../widgets/gradient_button.dart';
// // import 'home_screen.dart';
// //
// //
// //
// // // ---------- ADD / EDIT ALARM SCREEN ----------
// // class AddAlarmScreen extends StatefulWidget {
// //   const AddAlarmScreen({super.key});
// //
// //   @override
// //   State<AddAlarmScreen> createState() => _AddAlarmScreenState();
// // }
// //
// // class _AddAlarmScreenState extends State<AddAlarmScreen> {
// //   final TextEditingController _nameCtrl = TextEditingController();
// //   final TextEditingController _doseCtrl = TextEditingController();
// //
// //   TimeOfDay _time = TimeOfDay.now();
// //   String _freq = 'Daily';
// //   DateTime _startDate = DateTime.now();
// //   DateTime? _endDate;
// //
// //   // 🔹 Helper to format TimeOfDay → DateTime for scheduling // new add
// //   DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
// //     return DateTime(date.year, date.month, date.day, time.hour, time.minute);
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: const Color(0xFFF4F5FA),
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         title: const Text('Add Medicine', style: TextStyle(color: Colors.black87)),
// //         leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, color: Colors.black87)),
// //         actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert, color: Colors.black54))],
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
// //         child: Column(
// //           children: [
// //             // top illustration
// //             Container(
// //               padding: const EdgeInsets.all(14),
// //               decoration: BoxDecoration(
// //                 color: Colors.white,
// //                 borderRadius: BorderRadius.circular(18),
// //                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 18)],
// //               ),
// //               child: Column(
// //                 children: [
// //                   SizedBox(
// //                     height: 96,
// //                     child: Image.asset('assets/medicine.png', errorBuilder: (c, e, s) => const Icon(Icons.medical_services_outlined, size: 72, color: AppColors.primary)),
// //                   ),
// //                   const SizedBox(height: 12),
// //
// //                   // Form fields
// //                   _buildTextField('Pill name', controller: _nameCtrl, hint: 'Enter the pill name'),
// //                   const SizedBox(height: 12),
// //
// //                   Row(
// //                     children: [
// //                       Expanded(child: _buildTextField('Dose', controller: _doseCtrl, hint: '0.5')),
// //                       const SizedBox(width: 8),
// //                       Expanded(
// //                         child: _buildDropdown('Frequency', _freq, ['Daily', 'Weekly', 'Monthly', 'Custom'], (val) => setState(() => _freq = val!)),
// //                       )
// //                     ],
// //                   ),
// //
// //                   const SizedBox(height: 12),
// //
// //                   Row(
// //                     children: [
// //                       Expanded(child: _buildTimePicker()),
// //                       const SizedBox(width: 8),
// //                       Expanded(child: _buildDatePicker()),
// //                     ],
// //                   ),
// //
// //                   // 🔹 NEW: End Date picker (optional)
// //                   Row(
// //                     children: [
// //                       Expanded(child: _buildEndDatePicker()),
// //                     ],
// //                   ),
// //
// //                   const SizedBox(height: 18),
// //
// //                   // sound picker placeholder
// //                   ListTile(
// //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //                     tileColor: Colors.grey[100],
// //                     leading: const Icon(Icons.music_note_outlined),
// //                     title: const Text('Alarm sound'),
// //                     subtitle: const Text('Default tone'),
// //                     trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
// //                   ),
// //
// //                   const SizedBox(height: 18),
// //
// //
// //                   // Add button
// //                   GradientButton(
// //                     text: 'Add Medicine',
// //                     onPressed: () async {
// //                       // In real app: validate and save to DB
// //
// //                       // 2. Simple validation
// //                       if (_nameCtrl.text.isEmpty ||  _freq.isEmpty || _time.toString().isEmpty || _startDate.toString().isEmpty || _doseCtrl.text.isEmpty) {
// //                         ScaffoldMessenger.of(context).showSnackBar(
// //                           SnackBar(content: Text('Please fill all required fields')),
// //                         );
// //                         return;
// //                       }
// //
// //                       //Insert into local DB first to get id
// //                       // 3. Create AlarmModel instance
// //                       final newAlarm = AlarmModel(
// //                         name: _nameCtrl.text,
// //                         note: _doseCtrl.text,
// //                         time: _time.format(context), // store human readable too
// //                         frequency: _freq.toString(),
// //                         startDate: DateFormat('yyyy-MM-dd').format(_startDate),
// //                         endDate: DateFormat('yyyy-MM-dd')
// //                             .format(_endDate ?? _startDate.add(const Duration(days: 7))),
// //                         soundPath: "",// fill if user picks sound
// //                         isActive: true,
// //                       );
// //
// //                       // 4. Insert into database // var can be chage with final keyword
// //                       var alarmData = await AlarmDatabase.instance.insertAlarm(newAlarm);
// //
// //                       // 5) Re-fetch alarms to update app-level list
// //                       AppConstants.alarms = await AlarmDatabase.instance.fetchAlarms();
// //
// //                       // newly add things for alarm
// //                       // 4) Build DateTime for first alarm occurrence
// //                       // convert TimeOfDay + startDate to DateTime
// //                       final parts = _time.format(context).split(RegExp(r'[: ]')); // fragile, better build from _time
// //                       final int hour = _time.hour;
// //                       final int minute = _time.minute;
// //                       DateTime scheduledDate = DateTime(
// //                         _startDate.year,
// //                         _startDate.month,
// //                         _startDate.day,
// //                         hour,
// //                         minute,
// //                       );
// //
// //                       // If scheduledDate is in the past, for one-time alarms push next day
// //                       if (scheduledDate.isBefore(DateTime.now())) {
// //                         // depending on frequency you might shift to next valid day — for now add 1 day
// //                         scheduledDate = scheduledDate.add(const Duration(days: 1));
// //                       }
// //
// //                       // 5) Create AlarmSettings for the alarm plugin
// //                       final alarmSettings = AlarmSettings(
// //                       id: alarmData, // important
// //                       dateTime: scheduledDate,
// //                       assetAudioPath: 'assets/testalarm.mp3', // if you ship an asset audio; else use audioPath
// //                       loopAudio: true, // keep ringing until stopped
// //                       vibrate: true,
// //                         volumeSettings: VolumeSettings.fade(fadeDuration: Duration(seconds: 1)),
// //                         notificationSettings: NotificationSettings.fromJson(
// //                           {
// //                             "title": _nameCtrl.text,
// //                             "body": "You need to take the medicine",
// //                           }
// //                         ),  // show notification if app killed
// //                       );
// //
// //                       // 6) Schedule with plugin
// //                       await Alarm.set(alarmSettings: alarmSettings);
// //
// //                       // 🔹 Schedule repeats
// //                       await _scheduleRepeats(alarmData, scheduledDate, _freq, _endDate);
// //
// //                       setState(() {
// //
// //                       });
// //
// //
// //                       // 5. Optional: refresh list or notify parent
// //
// //                       // 6. Close the add medicine screen
// //                       // Navigator.pop(context);
// //                       Navigator.pushReplacement(
// //                         context,
// //                         MaterialPageRoute(builder: (_) => HomeScreen()),
// //                       );
// //                     },
// //                   )
// //                 ],
// //               ),
// //             )
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // new add things again
// //   // 🔹 Repeating scheduler (Daily / Weekly / Monthly)
// //   Future<void> _scheduleRepeats(
// //       int id,
// //       DateTime first,
// //       String freq,
// //       DateTime? endDate,
// //       ) async {
// //     if (freq == 'Custom') return; // handle later if needed
// //     Duration interval;
// //     switch (freq) {
// //       case 'Weekly':
// //         interval = const Duration(days: 7);
// //         break;
// //       case 'Monthly':
// //         interval = const Duration(days: 30);
// //         break;
// //       default:
// //         interval = const Duration(days: 1);
// //     }
// //
// //     DateTime next = first.add(interval);
// //     final end = endDate ?? first.add(const Duration(days: 7));
// //
// //     while (next.isBefore(end)) {
// //       await Alarm.set(
// //         alarmSettings: AlarmSettings(
// //           id: id + next.millisecondsSinceEpoch % 100000, // unique-ish ID
// //           dateTime: next,
// //           assetAudioPath: 'assets/testalarm.mp3',
// //           loopAudio: true,
// //           vibrate: true,
// //           notificationSettings: NotificationSettings(
// //             title: _nameCtrl.text,
// //             body: 'Time to take your medicine',
// //           ), volumeSettings: VolumeSettings.fade(fadeDuration: Duration(seconds: 1)),
// //         ),
// //       );
// //       next = next.add(interval);
// //     }
// //   }
// //
// //
// //   Widget _buildTextField(String label, {TextEditingController? controller, String? hint}) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
// //         const SizedBox(height: 6),
// //         TextField(
// //           controller: controller,
// //           decoration: InputDecoration(
// //             hintText: hint,
// //             filled: true,
// //             fillColor: Colors.grey[100],
// //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
// //             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
// //         const SizedBox(height: 6),
// //         DropdownButtonFormField<String>(
// //           value: value,
// //           items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
// //           onChanged: onChanged,
// //           decoration: InputDecoration(
// //             filled: true,
// //             fillColor: Colors.grey[100],
// //             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
// //             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
// //           ),
// //         )
// //       ],
// //     );
// //   }
// //
// //   Widget _buildTimePicker() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Text('Time', style: TextStyle(fontSize: 12, color: Colors.black54)),
// //         const SizedBox(height: 6),
// //         GestureDetector(
// //           onTap: _pickTime,
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
// //             decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [Text(_time.format(context)), const Icon(Icons.access_time)],
// //             ),
// //           ),
// //         )
// //       ],
// //     );
// //   }
// //
// //   Widget _buildDatePicker() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Text('Start Date', style: TextStyle(fontSize: 12, color: Colors.black54)),
// //         const SizedBox(height: 6),
// //         GestureDetector(
// //           onTap: _pickDate,
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
// //             decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [Text(DateFormat.yMMMd().format(_startDate)), const Icon(Icons.calendar_today_outlined)],
// //             ),
// //           ),
// //         )
// //       ],
// //     );
// //   }
// // // 🔹 End Date Picker
// //   Widget _buildEndDatePicker() {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         const Text('End Date', style: TextStyle(fontSize: 12, color: Colors.black54)),
// //         const SizedBox(height: 6),
// //         GestureDetector(
// //           onTap: _pickEndDate,
// //           child: Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
// //             decoration:
// //             BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
// //             child: Row(
// //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //               children: [
// //                 Text(_endDate == null
// //                     ? 'Select date'
// //                     : DateFormat.yMMMd().format(_endDate!)),
// //                 const Icon(Icons.calendar_today_outlined),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ],
// //     );
// //   }
// //
// //   Future<void> _pickTime() async {
// //     final t = await showTimePicker(context: context, initialTime: _time);
// //     if (t != null) setState(() => _time = t);
// //   }
// //
// //   Future<void> _pickDate() async {
// //     final d = await showDatePicker(context: context, initialDate: _startDate, firstDate: DateTime(2020), lastDate: DateTime(2100));
// //     if (d != null) setState(() => _startDate = d);
// //   }
// //
// //
// //   Future<void> _pickEndDate() async {
// //     final d = await showDatePicker(
// //         context: context,
// //         initialDate: _endDate ?? _startDate,
// //         firstDate: _startDate,
// //         lastDate: DateTime(2100));
// //     if (d != null) setState(() => _endDate = d);
// //   }
// // }
// //
//
//
//
// //---------new features updated code----------------------//
// import 'package:alarm/alarm.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import '../constants/app_constants.dart';
// import '../database/alarm_db.dart';
// import '../models/alarm_model.dart';
// import '../utils/app_colors.dart';
// import '../widgets/gradient_button.dart';
// import 'home_screen.dart';
//
// // ---------- ADD / EDIT ALARM SCREEN ----------
// class AddAlarmScreen extends StatefulWidget {
//   final AlarmModel? existingAlarm; // For editing existing alarm
//
//   const AddAlarmScreen({super.key, this.existingAlarm});
//
//   @override
//   State<AddAlarmScreen> createState() => _AddAlarmScreenState();
// }
//
// class _AddAlarmScreenState extends State<AddAlarmScreen> {
//   final TextEditingController _nameCtrl = TextEditingController();
//   final TextEditingController _doseCtrl = TextEditingController();
//   List<TimeOfDay> _selectedTimes = []; // Multiple times
//   String _freq = 'Daily';
//   String _foodTiming = 'Before Food';
//   DateTime _startDate = DateTime.now();
//   DateTime? _endDate;
//   String _medicineImagePath = '';
//   final ImagePicker _picker = ImagePicker();
//
//   // 🔹 Helper to format TimeOfDay → DateTime for scheduling
//   DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
//     return DateTime(date.year, date.month, date.day, time.hour, time.minute);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeFields();
//   }
//
//   void _initializeFields() {
//     if (widget.existingAlarm != null) {
//       final alarm = widget.existingAlarm!;
//       _nameCtrl.text = alarm.name;
//       _doseCtrl.text = alarm.note;
//       _freq = alarm.frequency;
//       _foodTiming = alarm.foodTiming;
//       _startDate = DateFormat('yyyy-MM-dd').parse(alarm.startDate);
//       _endDate = alarm.endDate.isNotEmpty
//           ? DateFormat('yyyy-MM-dd').parse(alarm.endDate)
//           : null;
//       _medicineImagePath = alarm.medicineImagePath;
//
//       // Parse times - handle both old and new formats safely
//       _selectedTimes = [];
//       for (String timeStr in alarm.times) {
//         try {
//           // Try parsing as formatted time first
//           final parts = timeStr.trim().split(RegExp(r'[: ]'));
//           if (parts.length >= 2) {
//             int hour = int.parse(parts[0]);
//             int minute = int.parse(parts[1]);
//
//             // Handle AM/PM
//             if (timeStr.toLowerCase().contains('pm') && hour != 12) {
//               hour += 12;
//             } else if (timeStr.toLowerCase().contains('am') && hour == 12) {
//               hour = 0;
//             }
//
//             _selectedTimes.add(TimeOfDay(hour: hour, minute: minute));
//           }
//         } catch (e) {
//           // If parsing fails, add a default time
//           _selectedTimes.add(TimeOfDay.now());
//         }
//       }
//
//       // If no times were parsed, add current time
//       if (_selectedTimes.isEmpty) {
//         _selectedTimes.add(TimeOfDay.now());
//       }
//     } else {
//       // For new alarm, start with one default time
//       _selectedTimes = [TimeOfDay.now()];
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F5FA),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           widget.existingAlarm != null ? 'Edit Medicine' : 'Add Medicine',
//           style: const TextStyle(color: Colors.black87),
//         ),
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back, color: Colors.black87),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
//         child: Column(
//           children: [
//             // Top illustration and image picker
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(18),
//                 boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 18)],
//               ),
//               child: Column(
//                 children: [
//                   // Medicine Image Section
//                   GestureDetector(
//                     onTap: _pickImage,
//                     child: Container(
//                       height: 96,
//                       width: 96,
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey[300]!),
//                       ),
//                       child: _medicineImagePath.isNotEmpty
//                           ? ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.file(
//                           File(_medicineImagePath),
//                           fit: BoxFit.cover,
//                         ),
//                       )
//                           : Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.camera_alt, size: 32, color: AppColors.primary),
//                           const SizedBox(height: 4),
//                           Text('Add Photo', style: TextStyle(color: AppColors.primary, fontSize: 10)),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//
//                   // Form fields
//                   _buildTextField('Medicine name', controller: _nameCtrl, hint: 'Enter medicine name'),
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Expanded(child: _buildTextField('Dose', controller: _doseCtrl, hint: '1 tablet')),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: _buildDropdown(
//                           'Frequency',
//                           _freq,
//                           ['Daily', 'Weekly', 'Monthly', 'Custom'],
//                               (val) => setState(() => _freq = val!),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//
//                   // Food timing selection
//                   _buildFoodTimingSelector(),
//                   const SizedBox(height: 12),
//
//                   // Multiple time selection
//                   _buildMultipleTimesSection(),
//                   const SizedBox(height: 12),
//
//                   Row(
//                     children: [
//                       Expanded(child: _buildDatePicker()),
//                       const SizedBox(width: 8),
//                       Expanded(child: _buildEndDatePicker()),
//                     ],
//                   ),
//                   const SizedBox(height: 18),
//
//                   // Sound picker placeholder
//                   ListTile(
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                     tileColor: Colors.grey[100],
//                     leading: const Icon(Icons.music_note_outlined),
//                     title: const Text('Alarm sound'),
//                     subtitle: const Text('Default tone'),
//                     trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
//                   ),
//                   const SizedBox(height: 18),
//
//                   // Save button
//                   GradientButton(
//                     text: widget.existingAlarm != null ? 'Update Medicine' : 'Add Medicine',
//                     onPressed: _saveAlarm,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(String label, {TextEditingController? controller, String? hint}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
//         const SizedBox(height: 6),
//         TextField(
//           controller: controller,
//           decoration: InputDecoration(
//             hintText: hint,
//             filled: true,
//             fillColor: Colors.grey[100],
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildDropdown(String label, String value, List<String> options, ValueChanged<String?> onChanged) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
//         const SizedBox(height: 6),
//         DropdownButtonFormField<String>(
//           value: value,
//           items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
//           onChanged: onChanged,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: Colors.grey[100],
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
//             contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildFoodTimingSelector() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Food Timing', style: TextStyle(fontSize: 12, color: Colors.black54)),
//         const SizedBox(height: 8),
//         Row(
//           children: [
//             Expanded(
//               child: RadioListTile<String>(
//                 title: const Text('Before Food'),
//                 value: 'Before Food',
//                 groupValue: _foodTiming,
//                 onChanged: (value) => setState(() => _foodTiming = value!),
//                 contentPadding: EdgeInsets.zero,
//                 dense: true,
//               ),
//             ),
//             Expanded(
//               child: RadioListTile<String>(
//                 title: const Text('After Food'),
//                 value: 'After Food',
//                 groupValue: _foodTiming,
//                 onChanged: (value) => setState(() => _foodTiming = value!),
//                 contentPadding: EdgeInsets.zero,
//                 dense: true,
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMultipleTimesSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Medicine Times', style: TextStyle(fontSize: 12, color: Colors.black54)),
//             TextButton.icon(
//               onPressed: _addTime,
//               icon: const Icon(Icons.add),
//               label: const Text('Add Time'),
//               style: TextButton.styleFrom(
//                 foregroundColor: AppColors.primary,
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: _selectedTimes.isEmpty
//               ? Text('No times selected', style: TextStyle(color: Colors.grey[600]))
//               : Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             children: _selectedTimes.map((time) => _buildTimeChip(time)).toList(),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildTimeChip(TimeOfDay time) {
//     return Chip(
//       label: Text(time.format(context)),
//       deleteIcon: const Icon(Icons.close, size: 16),
//       onDeleted: () => setState(() => _selectedTimes.remove(time)),
//       backgroundColor: AppColors.primary.withOpacity(0.1),
//       labelStyle: TextStyle(color: AppColors.primary),
//     );
//   }
//
//   Widget _buildDatePicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('Start Date', style: TextStyle(fontSize: 12, color: Colors.black54)),
//         const SizedBox(height: 6),
//         GestureDetector(
//           onTap: _pickDate,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//             decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [Text(DateFormat.yMMMd().format(_startDate)), const Icon(Icons.calendar_today_outlined)],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildEndDatePicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text('End Date', style: TextStyle(fontSize: 12, color: Colors.black54)),
//         const SizedBox(height: 6),
//         GestureDetector(
//           onTap: _pickEndDate,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//             decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(_endDate == null ? 'Select date' : DateFormat.yMMMd().format(_endDate!)),
//                 const Icon(Icons.calendar_today_outlined),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future<void> _pickImage() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//     if (image != null) {
//       setState(() => _medicineImagePath = image.path);
//     }
//   }
//
//   Future<void> _addTime() async {
//     final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
//     if (time != null) {
//       // Check if this time already exists
//       bool timeExists = _selectedTimes.any((existingTime) =>
//       existingTime.hour == time.hour && existingTime.minute == time.minute);
//
//       if (!timeExists) {
//         setState(() => _selectedTimes.add(time));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('This time is already added')),
//         );
//       }
//     }
//   }
//
//   Future<void> _pickDate() async {
//     final d = await showDatePicker(
//       context: context,
//       initialDate: _startDate,
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2100),
//     );
//     if (d != null) setState(() => _startDate = d);
//   }
//
//   Future<void> _pickEndDate() async {
//     final d = await showDatePicker(
//       context: context,
//       initialDate: _endDate ?? _startDate,
//       firstDate: _startDate,
//       lastDate: DateTime(2100),
//     );
//     if (d != null) setState(() => _endDate = d);
//   }
//
//   Future<void> _saveAlarm() async {
//     try {
//       // Validation
//       if (_nameCtrl.text.isEmpty || _selectedTimes.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please fill all required fields and add at least one time')),
//         );
//         return;
//       }
//
//       // Convert times to string format
//       final timeStrings = _selectedTimes.map((time) => time.format(context)).toList();
//
//       // Create alarm model
//       final alarm = AlarmModel(
//         id: widget.existingAlarm?.id,
//         name: _nameCtrl.text,
//         note: _doseCtrl.text,
//         times: timeStrings,
//         frequency: _freq,
//         startDate: DateFormat('yyyy-MM-dd').format(_startDate),
//         endDate: DateFormat('yyyy-MM-dd').format(_endDate ?? _startDate.add(const Duration(days: 7))),
//         soundPath: '',
//         medicineImagePath: _medicineImagePath,
//         foodTiming: _foodTiming,
//         isActive: true,
//       );
//
//       int alarmId;
//       if (widget.existingAlarm != null) {
//         // Update existing alarm
//         await AlarmDatabase.instance.updateAlarm(alarm);
//         alarmId = widget.existingAlarm!.id!;
//         // Cancel existing alarms
//         for (int i = 0; i < 10; i++) {
//           await Alarm.stop(alarmId + i * 100000);
//         }
//       } else {
//         // Insert new alarm
//         alarmId = await AlarmDatabase.instance.insertAlarm(alarm);
//       }
//
//       // Schedule alarms for each time
//       await _scheduleAlarms(alarmId, timeStrings);
//
//       // Refresh global alarm list
//       AppConstants.alarms = await AlarmDatabase.instance.fetchAlarms();
//
//       // Navigate back
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (_) => const HomeScreen()),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error saving alarm: $e')),
//       );
//     }
//   }
//
//   Future<void> _scheduleAlarms(int baseId, List<String> times) async {
//     for (int i = 0; i < times.length; i++) {
//       try {
//         // Parse time string safely
//         final timeStr = times[i];
//         final parts = timeStr.split(RegExp(r'[: ]'));
//
//         int hour = int.parse(parts[0]);
//         int minute = int.parse(parts[1]);
//
//         // Handle AM/PM
//         if (timeStr.toLowerCase().contains('pm') && hour != 12) {
//           hour += 12;
//         } else if (timeStr.toLowerCase().contains('am') && hour == 12) {
//           hour = 0;
//         }
//
//         DateTime scheduledDate = DateTime(
//           _startDate.year,
//           _startDate.month,
//           _startDate.day,
//           hour,
//           minute,
//         );
//
//         if (scheduledDate.isBefore(DateTime.now())) {
//           scheduledDate = scheduledDate.add(const Duration(days: 1));
//         }
//
//         final alarmSettings = AlarmSettings(
//           id: baseId + i * 100000, // Unique ID for each time
//           dateTime: scheduledDate,
//           assetAudioPath: 'assets/testalarm.mp3',
//           loopAudio: true,
//           vibrate: true,
//           volumeSettings: VolumeSettings.fade(fadeDuration: const Duration(seconds: 1)),
//           notificationSettings: NotificationSettings(
//             title: _nameCtrl.text,
//             body: 'Time to take your medicine - $_foodTiming',
//             stopButton: 'Stop',
//             icon: 'notification_icon',
//           ),
//         );
//
//         await Alarm.set(alarmSettings: alarmSettings);
//
//         // 🔹 Schedule repeats using your original working logic
//         await _scheduleRepeats(baseId + i * 100000, scheduledDate, _freq, _endDate);
//       } catch (e) {
//         print('Error scheduling alarm for time ${times[i]}: $e');
//       }
//     }
//   }
//
//   // 🔹 Repeating scheduler (Daily / Weekly / Monthly) - FROM YOUR ORIGINAL WORKING CODE
//   Future<void> _scheduleRepeats(
//       int id,
//       DateTime first,
//       String freq,
//       DateTime? endDate,
//       ) async {
//     if (freq == 'Custom') return; // handle later if needed
//
//     Duration interval;
//     switch (freq) {
//       case 'Weekly':
//         interval = const Duration(days: 7);
//         break;
//       case 'Monthly':
//         interval = const Duration(days: 30);
//         break;
//       default:
//         interval = const Duration(days: 1);
//     }
//
//     DateTime next = first.add(interval);
//     final end = endDate ?? first.add(const Duration(days: 7));
//
//     while (next.isBefore(end)) {
//       await Alarm.set(
//         alarmSettings: AlarmSettings(
//           id: id + next.millisecondsSinceEpoch % 100000, // unique-ish ID
//           dateTime: next,
//           assetAudioPath: 'assets/testalarm.mp3',
//           loopAudio: true,
//           vibrate: true,
//           notificationSettings: NotificationSettings(
//             title: _nameCtrl.text,
//             body: 'Time to take your medicine - $_foodTiming',
//           ),
//           volumeSettings: VolumeSettings.fade(fadeDuration: const Duration(seconds: 1)),
//         ),
//       );
//       next = next.add(interval);
//     }
//   }
// }

//------------------ Handdling time for app close but alarm rings -----------------//
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../constants/app_constants.dart';
import '../database/alarm_db.dart';
import '../models/alarm_model.dart';
import '../utils/app_colors.dart';
import '../widgets/gradient_button.dart';
import 'home_screen.dart';

// ---------- ADD / EDIT ALARM SCREEN ----------
class AddAlarmScreen extends StatefulWidget {
  final AlarmModel? existingAlarm; // For editing existing alarm

  const AddAlarmScreen({super.key, this.existingAlarm});

  @override
  State<AddAlarmScreen> createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _doseCtrl = TextEditingController();
  List<TimeOfDay> _selectedTimes = []; // Multiple times
  String _freq = 'Daily';
  String _foodTiming = 'Before Food';
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  String _medicineImagePath = '';
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    if (widget.existingAlarm != null) {
      final alarm = widget.existingAlarm!;
      _nameCtrl.text = alarm.name;
      _doseCtrl.text = alarm.note;
      _freq = alarm.frequency;
      _foodTiming = alarm.foodTiming;
      _startDate = DateFormat('yyyy-MM-dd').parse(alarm.startDate);
      _endDate = alarm.endDate.isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(alarm.endDate)
          : null;
      _medicineImagePath = alarm.medicineImagePath;

      // Parse times - handle both old and new formats safely
      _selectedTimes = [];
      for (String timeStr in alarm.times) {
        try {
          // Try parsing as formatted time first
          final parts = timeStr.trim().split(RegExp(r'[: ]'));
          if (parts.length >= 2) {
            int hour = int.parse(parts[0]);
            int minute = int.parse(parts[1]);

            // Handle AM/PM
            if (timeStr.toLowerCase().contains('pm') && hour != 12) {
              hour += 12;
            } else if (timeStr.toLowerCase().contains('am') && hour == 12) {
              hour = 0;
            }

            _selectedTimes.add(TimeOfDay(hour: hour, minute: minute));
          }
        } catch (e) {
          // If parsing fails, add a default time
          _selectedTimes.add(TimeOfDay.now());
        }
      }

      // If no times were parsed, add current time
      if (_selectedTimes.isEmpty) {
        _selectedTimes.add(TimeOfDay.now());
      }
    } else {
      // For new alarm, start with one default time
      _selectedTimes = [TimeOfDay.now()];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F5FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.existingAlarm != null ? 'Edit Medicine' : 'Add Medicine',
          style: const TextStyle(color: Colors.black87),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        child: Column(
          children: [
            // Top illustration and image picker
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 18)],
              ),
              child: Column(
                children: [
                  // Medicine Image Section
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 96,
                      width: 96,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: _medicineImagePath.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_medicineImagePath),
                          fit: BoxFit.cover,
                        ),
                      )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 32, color: AppColors.primary),
                          const SizedBox(height: 4),
                          Text('Add Photo', style: TextStyle(color: AppColors.primary, fontSize: 10)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Form fields
                  _buildTextField('Medicine name', controller: _nameCtrl, hint: 'Enter medicine name'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Dose', controller: _doseCtrl, hint: '1 tablet')),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDropdown(
                          'Frequency',
                          _freq,
                          ['Daily', 'Weekly', 'Monthly', 'Custom'],
                              (val) => setState(() => _freq = val!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Food timing selection
                  _buildFoodTimingSelector(),
                  const SizedBox(height: 12),

                  // Multiple time selection
                  _buildMultipleTimesSection(),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(child: _buildDatePicker()),
                      const SizedBox(width: 8),
                      Expanded(child: _buildEndDatePicker()),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Sound picker placeholder
                  ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    tileColor: Colors.grey[100],
                    leading: const Icon(Icons.music_note_outlined),
                    title: const Text('Alarm sound'),
                    subtitle: const Text('Default tone'),
                    trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.chevron_right)),
                  ),
                  const SizedBox(height: 18),

                  // Save button
                  GradientButton(
                    text: widget.existingAlarm != null ? 'Update Medicine' : 'Add Medicine',
                    onPressed: _saveAlarm,
                  ),
                ],
              ),
            ),
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
        ),
      ],
    );
  }

  Widget _buildFoodTimingSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Food Timing', style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Before Food'),
                value: 'Before Food',
                groupValue: _foodTiming,
                onChanged: (value) => setState(() => _foodTiming = value!),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('After Food'),
                value: 'After Food',
                groupValue: _foodTiming,
                onChanged: (value) => setState(() => _foodTiming = value!),
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMultipleTimesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Medicine Times', style: TextStyle(fontSize: 12, color: Colors.black54)),
            TextButton.icon(
              onPressed: _addTime,
              icon: const Icon(Icons.add),
              label: const Text('Add Time'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: _selectedTimes.isEmpty
              ? Text('No times selected', style: TextStyle(color: Colors.grey[600]))
              : Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTimes.map((time) => _buildTimeChip(time)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeChip(TimeOfDay time) {
    return Chip(
      label: Text(time.format(context)),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: () => setState(() => _selectedTimes.remove(time)),
      backgroundColor: AppColors.primary.withOpacity(0.1),
      labelStyle: TextStyle(color: AppColors.primary),
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
        ),
      ],
    );
  }

  Widget _buildEndDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('End Date', style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickEndDate,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_endDate == null ? 'Select date' : DateFormat.yMMMd().format(_endDate!)),
                const Icon(Icons.calendar_today_outlined),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _medicineImagePath = image.path);
    }
  }

  Future<void> _addTime() async {
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time != null) {
      // Check if this time already exists
      bool timeExists = _selectedTimes.any((existingTime) =>
      existingTime.hour == time.hour && existingTime.minute == time.minute);

      if (!timeExists) {
        setState(() => _selectedTimes.add(time));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('This time is already added')),
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _startDate = d);
  }

  Future<void> _pickEndDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _endDate = d);
  }

  Future<void> _saveAlarm() async {
    try {
      // Validation
      if (_nameCtrl.text.isEmpty || _selectedTimes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields and add at least one time')),
        );
        return;
      }

      // Convert times to string format
      final timeStrings = _selectedTimes.map((time) => time.format(context)).toList();

      // Create alarm model
      final alarm = AlarmModel(
        id: widget.existingAlarm?.id,
        name: _nameCtrl.text,
        note: _doseCtrl.text,
        times: timeStrings,
        frequency: _freq,
        startDate: DateFormat('yyyy-MM-dd').format(_startDate),
        endDate: DateFormat('yyyy-MM-dd').format(_endDate ?? _startDate.add(const Duration(days: 7))),
        soundPath: '',
        medicineImagePath: _medicineImagePath,
        foodTiming: _foodTiming,
        isActive: true,
      );

      int alarmId;
      if (widget.existingAlarm != null) {
        // Update existing alarm
        await AlarmDatabase.instance.updateAlarm(alarm);
        alarmId = widget.existingAlarm!.id!;
        // Cancel existing alarms
        for (int i = 0; i < 10; i++) {
          await Alarm.stop(alarmId + i * 100000);
        }
      } else {
        // Insert new alarm
        alarmId = await AlarmDatabase.instance.insertAlarm(alarm);
      }

      // Schedule alarms for each time
      await _scheduleAlarms(alarmId, timeStrings);

      // Refresh global alarm list
      AppConstants.alarms = await AlarmDatabase.instance.fetchAlarms();

      // Navigate back
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving alarm: $e')),
      );
    }
  }

  Future<void> _scheduleAlarms(int baseId, List<String> times) async {
    for (int i = 0; i < times.length; i++) {
      try {
        // Parse time string safely
        final timeStr = times[i];
        final parts = timeStr.split(RegExp(r'[: ]'));

        int hour = int.parse(parts[0]);
        int minute = int.parse(parts[1]);

        // Handle AM/PM
        if (timeStr.toLowerCase().contains('pm') && hour != 12) {
          hour += 12;
        } else if (timeStr.toLowerCase().contains('am') && hour == 12) {
          hour = 0;
        }

        DateTime scheduledDate = DateTime(
          _startDate.year,
          _startDate.month,
          _startDate.day,
          hour,
          minute,
        );

        if (scheduledDate.isBefore(DateTime.now())) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
        }

        // CORRECTED ALARM SETTINGS FOR YOUR PLUGIN VERSION
        final alarmSettings = AlarmSettings(
          id: baseId + i * 100000, // Unique ID for each time
          dateTime: scheduledDate,
          assetAudioPath: 'assets/testalarm.mp3',
          loopAudio: true,
          vibrate: true,
          volumeSettings:  VolumeSettings.fade(fadeDuration: Duration(seconds: 1)),
          notificationSettings: NotificationSettings(
            title: _nameCtrl.text,
            body: 'Time to take your medicine - $_foodTiming',
            stopButton: 'Stop',
            icon: 'notification_icon',
          ),
        );

        await Alarm.set(alarmSettings: alarmSettings);

        // Schedule repeats using your original working logic
        await _scheduleRepeats(baseId + i * 100000, scheduledDate, _freq, _endDate);
      } catch (e) {
        print('Error scheduling alarm for time ${times[i]}: $e');
      }
    }
  }

  // Repeating scheduler (Daily / Weekly / Monthly) - CORRECTED VERSION
  Future<void> _scheduleRepeats(
      int id,
      DateTime first,
      String freq,
      DateTime? endDate,
      ) async {
    if (freq == 'Custom') return; // handle later if needed

    Duration interval;
    switch (freq) {
      case 'Weekly':
        interval = const Duration(days: 7);
        break;
      case 'Monthly':
        interval = const Duration(days: 30);
        break;
      default:
        interval = const Duration(days: 1);
    }

    DateTime next = first.add(interval);
    final end = endDate ?? first.add(const Duration(days: 30)); // 30 days by default

    int repeatCount = 0;
    while (next.isBefore(end) && repeatCount < 50) { // Max 50 repeats to avoid too many alarms
      await Alarm.set(
        alarmSettings: AlarmSettings(
          id: id + next.millisecondsSinceEpoch % 100000, // unique-ish ID
          dateTime: next,
          assetAudioPath: 'assets/testalarm.mp3',
          loopAudio: true,
          vibrate: true,
          volumeSettings:  VolumeSettings.fade(fadeDuration: Duration(seconds: 1)),
          notificationSettings: NotificationSettings(
            title: _nameCtrl.text,
            body: 'Time to take your medicine - $_foodTiming',
            stopButton: 'Stop',
            icon: 'notification_icon',
          ),
        ),
      );
      next = next.add(interval);
      repeatCount++;
    }
  }
}