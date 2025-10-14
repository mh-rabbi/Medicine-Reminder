// lib/models/alarm_model.dart
class AlarmModel {
  int? id;
  String name;
  String note;
  String time; // Example: "08:00 AM"
  String frequency; // Daily / Weekly / Monthly / Custom
  String startDate; // "YYYY-MM-DD"
  String soundPath; // file name or uri
  bool isActive;

  AlarmModel({
    this.id,
    required this.name,
    required this.note,
    required this.time,
    required this.frequency,
    required this.startDate,
    required this.soundPath,
    this.isActive = true,
  });

  // Convert class → Map (for insert/update)
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'note': note,
    'time': time,
    'frequency': frequency,
    'startDate': startDate,
    'soundPath': soundPath,
    'isActive': isActive ? 1 : 0,
  };

  // Convert Map → class (for fetching)
  static AlarmModel fromMap(Map<String, dynamic> map) => AlarmModel(
    id: map['id'],
    name: map['name'],
    note: map['note'],
    time: map['time'],
    frequency: map['frequency'],
    startDate: map['startDate'],
    soundPath: map['soundPath'],
    isActive: map['isActive'] == 1,
  );
}
