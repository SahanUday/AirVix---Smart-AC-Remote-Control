import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SmartControlPage extends StatefulWidget {
  const SmartControlPage({super.key});

  @override
  State<SmartControlPage> createState() => _SmartControlPageState();
}

class _SmartControlPageState extends State<SmartControlPage> {
  final dbRef = FirebaseDatabase.instance.ref();

  Map<String, dynamic> sensorData = {};
  bool smartACControl = false;
  bool occupancyAuto = false;

  String feedback = 'comfortable';
  String activity = 'relaxing';

  @override
  void initState() {
    super.initState();
    fetchSensorData();
  }

  void fetchSensorData() {
    dbRef.onValue.listen((event) async {
      final data = event.snapshot.value as Map?;
      if (data == null) return;

      final sensorMap = Map<String, dynamic>.from(data['sensor_data'] ?? {});
      final daqMap = Map<String, dynamic>.from(data['daq_data'] ?? {});

      final newSensorData = {
        ...sensorMap,
        'indoor_temp': daqMap['indoor_temperature'],
        'indoor_humidity': daqMap['indoor_humidity'],
      };

      final String? aiTemp = newSensorData['ai_set_temp'];
      final String? occupancy = newSensorData['occupancy'];

      if (aiTemp == null || occupancy == null) {
        setState(() => sensorData = newSensorData);
        return;
      }

      if (occupancyAuto) {
        if (occupancy.toLowerCase() == "occupied") {
          await dbRef.child("ac_control/current_command").set(aiTemp);
        } else {
          await dbRef.child("ac_control/current_command").set("AC_off");
        }
      } else if (smartACControl) {
        await dbRef.child("ac_control/current_command").set(aiTemp);
      }

      setState(() => sensorData = newSensorData);
    });
  }

  void toggleSmartACControl(bool value) async {
    setState(() {
      smartACControl = value;
    });

    // Write the toggle state to Firebase
    await dbRef.child("ac_control/smart_active").set(value);

    if (value && sensorData['ai_set_temp'] != null) {
      await dbRef
          .child("ac_control/current_command")
          .set(sensorData['ai_set_temp']);
      showToast("Smart AC Control Enabled");
    } else {
      showToast("Smart AC Control Disabled");
    }
  }

  void toggleOccupancyAuto(bool value) async {
    setState(() {
      occupancyAuto = value;
    });

    // Write the toggle state to Firebase
    await dbRef.child("ac_control/occupancy_active").set(value);

    if (value) {
      if (sensorData['occupancy'].toString().toLowerCase() == "occupied") {
        await dbRef
            .child("ac_control/current_command")
            .set(sensorData['ai_set_temp']);
        showToast("AC Turned ON (Occupancy Detected)");
      } else {
        await dbRef.child("ac_control/current_command").set("AC_off");
        showToast("AC Turned OFF (Room Empty)");
      }
    } else {
      showToast("Occupancy Auto Control Disabled");
    }
  }

  void updateFeedback(String value) async {
    setState(() {
      feedback = value;
    });

    await dbRef.child("user_feedback/status").set(value);
    await dbRef
        .child("user_feedback/timestamp")
        .set(DateTime.now().toIso8601String());

    showToast("Feedback sent: $value");
  }

  void updateActivity(String value) async {
    setState(() {
      activity = value;
    });

    await dbRef.child("user_feedback/activity_type").set(value);
    await dbRef
        .child("user_feedback/timestamp")
        .set(DateTime.now().toIso8601String());

    showToast("Activity updated: $value");
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  String formatDateOnlyDate(String isoString) {
    try {
      DateTime dt = DateTime.parse(isoString).toLocal();
      return DateFormat('MMM dd, yyyy').format(dt);
    } catch (_) {
      return '--';
    }
  }

  String formatDateOnlyTime(String isoString) {
    try {
      DateTime dt = DateTime.parse(isoString).toLocal();
      return DateFormat('hh:mm a').format(dt);
    } catch (_) {
      return '--';
    }
  }

  String _formatDouble(dynamic value) {
    if (value == null) return '--';
    try {
      final doubleVal =
          value is double ? value : double.parse(value.toString());
      return doubleVal.toStringAsFixed(1);
    } catch (_) {
      return '--';
    }
  }

  @override
  void dispose() {
    // Turn off Smart AC Control on page exit
    smartACControl = false;
    dbRef.child("ac_control/smart_active").set(false);
    super.dispose();

    occupancyAuto = false;
    dbRef.child("ac_control/occupancy_active").set(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Smart Control",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AI Temperature Info
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                      children: [
                        const TextSpan(text: "AI Determined Set Temperature: "),
                        TextSpan(
                          text:
                              "${sensorData['ai_set_temp']?.split('_')[1] ?? '--'}°C",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "📅 ${formatDateOnlyDate(sensorData['timestamp'] ?? '__')}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "⏰ ${formatDateOnlyTime(sensorData['timestamp'] ?? '__')}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Room 🌡️ Temperature: ${_formatDouble(sensorData['indoor_temp'])}°C",
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        "💧 Humidity: ${_formatDouble(sensorData['indoor_humidity'])}%",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Outside 🌡️ Temperature: ${sensorData['outdoor_temp'] ?? '--'}°C",
                        style: const TextStyle(fontSize: 13),
                      ),
                      Text(
                        "🧍 ${sensorData['occupancy'] ?? '--'}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Smart AC Toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: SwitchListTile(
                title: const Text(
                  "Smart AC Control",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "AI adjusts settings for comfort and savings.",
                ),
                value: smartACControl,
                onChanged: toggleSmartACControl,
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 8),

            // Occupancy Auto Toggle
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(20),
              child: SwitchListTile(
                title: const Text(
                  "Occupancy Auto-ON/Off",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  "AC control based on occupancy detection.",
                ),
                value: occupancyAuto,
                onChanged: toggleOccupancyAuto,
                activeColor: Colors.blue,
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(height: 16),

            // Feedback Section
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Feedback", style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: feedback,
                    isExpanded: true,
                    dropdownColor: Colors.grey[850],
                    items:
                        ['too_hot', 'too_cold', 'comfortable']
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value.replaceAll('_', ' ').toUpperCase(),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) updateFeedback(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Current Activity",
                    style: TextStyle(fontSize: 16),
                  ),
                  DropdownButton<String>(
                    value: activity,
                    isExpanded: true,
                    dropdownColor: Colors.grey[850],
                    items:
                        ['sleeping', 'working', 'relaxing', 'cooking']
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value.toUpperCase()),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) updateActivity(value);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
