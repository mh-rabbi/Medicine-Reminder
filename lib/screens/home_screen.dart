
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder/constants/app_constants.dart';

import '../database/alarm_db.dart';
import '../models/alarm_model.dart';
import '../utils/app_colors.dart';
import '../widgets/alarm_card.dart';
import 'add_alarm_screen.dart';



// ---------- HOME SCREEN ----------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime _now = DateTime.now();
  int _selectedDayIndex = 0; // 0..6 for the week bar

  // sample alarms list (placeholder)

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /// first call local DB here and assign it to alarms
    assignData();
  }

  // @override
  // didChangeDependencies() {
  //   super.didChangeDependencies();
  //   assignData();
  // }

  Future<void> assignData() async{
    AppConstants.alarms = await AlarmDatabase.instance.fetchAlarms();

    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    final String greeting = 'Hello';
    final weekDays = _buildWeekDays();

    return Scaffold(
      // floating plus button in center bottom
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          // open add alarm screen with hero animation
          await Navigator.of(context).push(_bottomUpRoute(const AddAlarmScreen()));
          // after return, refresh data in real app
        },
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.home_outlined)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_today_outlined)),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
          child: Column(
            children: [
              // Top greeting + small profile avatar
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/profile.png'),
                    // fallback
                    onBackgroundImageError: (_, __) {},
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting, Mr. Rabbi',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Create new schedule',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        )
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {
                  }, icon: const Icon(Icons.calendar_month))
                ],
              ),

              const SizedBox(height: 18),

              // Card with week selector and quick start
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 18),
                  ],
                ),
                child: Column(
                  children: [
                    // week day selector
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: weekDays.length,
                        itemBuilder: (context, index) {
                          final day = weekDays[index];
                          final selected = index == _selectedDayIndex;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedDayIndex = index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? AppColors.primary : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: selected
                                    ? [BoxShadow(color: AppColors.primary.withOpacity(0.18), blurRadius: 16)]
                                    : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(child: Text(day['label'] ?? "Day",
                                      style: TextStyle(
                                          color: selected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600))),
                                  const SizedBox(height: 6),
                                  Expanded(child: Text(day['date'] ?? "Date", style: TextStyle(fontSize: 12, color: selected ? Colors.white70 : Colors.black45))),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Quick start button bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Today', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          onPressed: () {},
                          child: const Text('Start'),
                        )
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Alarms list
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: AppConstants.alarms.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final alarm = AppConstants.alarms[AppConstants.alarms.length - 1 - index];
                    return AlarmCard(
                      id: alarm.id ?? 0,
                      name: alarm.name,
                      time: alarm.time,
                      note: alarm.note,
                      color: Colors.red,
                      onTap: () async {
                        // navigate to edit screen
                        await Navigator.of(context).push(_bottomUpRoute(const AddAlarmScreen()));
                      },
                      onDelete: () async{
                        await AlarmDatabase.instance.deleteAlarm(alarm.id ?? 0);
                        AppConstants.alarms = await AlarmDatabase.instance.fetchAlarms();
                        setState(() {

                        });
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _buildWeekDays() {
    final now = _now;
    // show 7 days starting from today
    return List.generate(7, (i) {
      final d = now.add(Duration(days: i));
      return {
        'label': DateFormat.E().format(d),
        'date': DateFormat.d().format(d),
      };
    });
  }
}

// Bottom-up modal route for add/edit screen
Route _bottomUpRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      final curve = Curves.easeOutCubic;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}


