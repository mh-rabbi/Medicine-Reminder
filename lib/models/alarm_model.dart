// // lib/models/alarm_model.dart
// class AlarmModel {
//   int? id;
//   String name;
//   String note;
//   String time; // Example: "08:00 AM"
//   String frequency; // Daily / Weekly / Monthly / Custom
//   String startDate; // "YYYY-MM-DD"
//   String endDate;   // "YYYY-MM-DD"
//   String soundPath; // file name or uri
//   bool isActive;
//
//   AlarmModel({
//     this.id,
//     required this.name,
//     required this.note,
//     required this.time,
//     required this.frequency,
//     required this.startDate,
//     required this.endDate,
//     required this.soundPath,
//     this.isActive = true,
//   });
//
//   // Convert class → Map (for insert/update)
//   Map<String, dynamic> toMap() => {
//     'id': id,
//     'name': name,
//     'note': note,
//     'time': time,
//     'frequency': frequency,
//     'startDate': startDate,
//     'endDate': endDate,
//     'soundPath': soundPath,
//     'isActive': isActive ? 1 : 0,
//   };
//
//   // Convert Map → class (for fetching)
//   static AlarmModel fromMap(Map<String, dynamic> map) => AlarmModel(
//     id: map['id'],
//     name: map['name'],
//     note: map['note'],
//     time: map['time'],
//     frequency: map['frequency'],
//     startDate: map['startDate'],
//     endDate: map['endDate'],
//     soundPath: map['soundPath'],
//     isActive: map['isActive'] == 1,
//   );
// }


//------------new updated model for the multiple times-----------------//
// lib/models/alarm_model.dart
class AlarmModel {
  int? id;
  String name;
  String note;
  List<String> times; // Multiple times: ["08:00 AM", "02:30 PM", "09:00 PM"]
  String frequency; // Daily / Weekly / Monthly / Custom
  String startDate; // "YYYY-MM-DD"
  String endDate; // "YYYY-MM-DD"
  String soundPath; // file name or uri
  String medicineImagePath; // Path to medicine image
  String foodTiming; // "Before Food" or "After Food"
  bool isActive;

  AlarmModel({
    this.id,
    required this.name,
    required this.note,
    required this.times,
    required this.frequency,
    required this.startDate,
    required this.endDate,
    required this.soundPath,
    this.medicineImagePath = '',
    this.foodTiming = 'Before Food',
    this.isActive = true,
  });

  // Convert class → Map (for insert/update)
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'note': note,
    'times': times.join(','), // Store as comma-separated string
    'frequency': frequency,
    'startDate': startDate,
    'endDate': endDate,
    'soundPath': soundPath,
    'medicineImagePath': medicineImagePath,
    'foodTiming': foodTiming,
    'isActive': isActive ? 1 : 0,
  };

  // Convert Map → class (for fetching)
  static AlarmModel fromMap(Map<String, dynamic> map) {
    // Handle both old single 'time' field and new 'times' field
    List<String> timesList = [];
    if (map.containsKey('times') && map['times'] != null) {
      timesList = (map['times'] as String).split(',').where((s) => s.isNotEmpty).toList();
    } else if (map.containsKey('time') && map['time'] != null) {
      timesList = [map['time']]; // Convert old single time to list
    }

    return AlarmModel(
      id: map['id'],
      name: map['name'] ?? '',
      note: map['note'] ?? '',
      times: timesList,
      frequency: map['frequency'] ?? 'Daily',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      soundPath: map['soundPath'] ?? '',
      medicineImagePath: map['medicineImagePath'] ?? '',
      foodTiming: map['foodTiming'] ?? 'Before Food',
      isActive: (map['isActive'] ?? 1) == 1,
    );
  }

  // Helper method to get formatted times display
  String get formattedTimes => times.join(', ');

  // Helper to get first time (for backward compatibility)
  String get primaryTime => times.isNotEmpty ? times.first : '';
}