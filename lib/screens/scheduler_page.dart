import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SchedulerPage extends StatefulWidget {
  const SchedulerPage({super.key});

  @override
  State<SchedulerPage> createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  final dbRef = FirebaseDatabase.instance.ref();

  bool scheduleEnabled = false;
  Set<String> selectedDurations = {'1h'};
  final List<String> availableDurations = [
    '0.5min (30s)',
    '30min',
    '1h',
    '2h',
    '4h',
  ];

  final List<String> actions = ["AC_ON", "AC_OFF", "cool_24", "cool_20"];
  String selectedAction = 'AC_OFF';

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
  }

  void _initializeDefaults() async {
    // Set initial Firebase values
    await dbRef.child("ac_control/schedule_active").set(false);
    await dbRef
        .child("ac_control/time")
        .set(_calculateTotalMinutes(selectedDurations));

    final snapshot = await dbRef.child('ac_control/schedule_active').get();
    if (snapshot.exists && snapshot.value == true) {
      await dbRef.child("ac_control/current_command").set(selectedAction);
    }

    if (!mounted) return;
    setState(() {
      scheduleEnabled = false;
    });
  }

  void _toggleSchedule(bool enabled) async {
    if (!mounted) return;
    setState(() {
      scheduleEnabled = enabled;
    });

    dbRef.child("ac_control/schedule_active").set(enabled);

    if (enabled) {
      // ✅ Just write selectedAction directly to Firebase
      dbRef.child("ac_control/current_command").set(selectedAction);

      double totalMinutes = _calculateTotalMinutes(selectedDurations);
      dbRef.child("ac_control/time").set(totalMinutes);

      _showToast(
        "Schedule enabled: $totalMinutes min, action: $selectedAction",
      );
    } else {
      dbRef.child("ac_control/time").remove();
      _showToast("Schedule disabled");
    }
  }

  double _calculateTotalMinutes(Set<String> durations) {
    double total = 0;
    for (String duration in durations) {
      if (duration == '0.5min (30s)') {
        total += 0.5; // 30 seconds is 0.5 minutes
      } else if (duration == '1h') {
        total += 60;
      } else if (duration == '2h') {
        total += 120;
      } else if (duration == '4h') {
        total += 240;
      } else if (duration == '30min') {
        total += 30;
      }
    }
    return total;
  }

  void _toggleDuration(String duration) {
    if (!mounted) return;
    setState(() {
      if (selectedDurations.contains(duration)) {
        selectedDurations.remove(duration);
      } else {
        selectedDurations.add(duration);
      }
    });

    double total = _calculateTotalMinutes(selectedDurations);
    dbRef.child("ac_control/time").set(total);

    if (scheduleEnabled) {
      _showToast("Updated schedule time: $total min");
    }
  }

  void _onActionChanged(String? action) {
    if (action != null) {
      if (!mounted) return;
      setState(() {
        selectedAction = action;
      });

      if (scheduleEnabled) {
        dbRef.child("ac_control/current_command").set(action);
        _showToast("Action updated: $action");
      }
    }
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  Widget _buildDurationButton(String duration) {
    final isSelected = selectedDurations.contains(duration);
    return ChoiceChip(
      label: Text(duration),
      selected: isSelected,
      onSelected: (_) => _toggleDuration(duration),
      selectedColor: Colors.blue,
      backgroundColor: Colors.grey[800],
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  @override
  void dispose() {
    // ✅ Turn off the schedule automatically when leaving this page
    dbRef.child("ac_control/schedule_active").set(false);
    dbRef.child("ac_control/time").remove();
    _showToast("Schedule disabled (page closed)");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Schedule & Timer',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard(
                  title: "Schedule Toggle",
                  child: SwitchListTile(
                    value: scheduleEnabled,
                    onChanged: _toggleSchedule,
                    title: const Text("Enable Schedule"),
                    activeColor: Colors.blue,
                  ),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  title: "Set Timer",
                  child: Wrap(
                    spacing: 10,
                    children:
                        availableDurations.map(_buildDurationButton).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  title: "Select Action",
                  child: DropdownButton<String>(
                    value: selectedAction,
                    dropdownColor: Colors.grey[900],
                    style: const TextStyle(color: Colors.white),
                    items:
                        actions.map((String action) {
                          return DropdownMenuItem<String>(
                            value: action,
                            child: Text(action),
                          );
                        }).toList(),
                    onChanged: _onActionChanged,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
