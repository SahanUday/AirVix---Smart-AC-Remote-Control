import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'geofencing_page.dart';
import 'smart_control_page.dart';
import 'scheduler_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final dbRef = FirebaseDatabase.instance.ref();

  int _temperature = 24;
  String _mode = 'cool';

  bool _isPowerOn = false; // AC initially OFF

  Map<String, dynamic> sensorData = {};
  Map<String, dynamic> acControl = {};

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Container(), // Placeholder for HomePage itself
    GeofencingPage(),
    SmartControlPage(),
    SchedulerPage(),
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    dbRef.child("sensor_data").onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          sensorData = data;
        });
      } else {
        setState(() {
          sensorData = {};
        });
      }
    });

    dbRef.child("daq_data").onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists && snapshot.value != null) {
        final daq = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          sensorData['indoor_temp'] = daq['indoor_temperature'];
          sensorData['indoor_humidity'] = daq['indoor_humidity'];
        });
      }
    });

    dbRef.child("ac_control").onValue.listen((event) {
      final snapshot = event.snapshot;
      if (snapshot.exists && snapshot.value != null) {
        final data = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          acControl = data;
        });
      } else {
        setState(() {
          acControl = {};
        });
      }
    });
  }

  void _changeTemperature(int delta) {
    setState(() {
      _temperature += delta;
    });
    _sendCommand();
  }

  void _changeMode(String mode) {
    setState(() {
      _mode = mode;
    });
    _sendCommand();
  }

  void _sendCommand() {
    final command = "${_mode}_${_temperature}";
    dbRef.child("ac_control/current_command").set(command);
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Toggle power
      setState(() {
        _isPowerOn = !_isPowerOn;
      });

      final command = _isPowerOn ? "AC_ON" : "AC_OFF";
      dbRef.child("ac_control/current_command").set(command);

      _showToast(
        _isPowerOn ? "AC Turned ON" : "AC Turned OFF",
        _isPowerOn ? Colors.blue : Colors.red,
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  String formatDateOnlyDate(String isoString) {
    try {
      DateTime dt = DateTime.parse(isoString).toLocal();
      return DateFormat('MMM dd, yyyy').format(dt); // e.g. Jul 07, 2025
    } catch (_) {
      return '--';
    }
  }

  String formatDateOnlyTime(String isoString) {
    try {
      DateTime dt = DateTime.parse(isoString).toLocal();
      return DateFormat('hh:mm a').format(dt); // e.g. 09:15 AM
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

  Widget _buildTempButton(IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
        backgroundColor: Colors.grey[850],
      ),
      onPressed: onPressed,
      child: Icon(icon, size: 24, color: Colors.white),
    );
  }

  Widget _buildModeIconButton(IconData icon, String label, String mode) {
    final isSelected = _mode == mode;
    return Column(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected ? Colors.blue : Colors.grey[850],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(30),
          ),
          onPressed: () => _changeMode(mode),
          child: Icon(icon, color: Colors.white, size: 30),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  void _showToast(String msg, MaterialColor materialColor) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Living Room AC',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                          "💧 Humidity: ${sensorData['outdoor_humidity'] ?? '--'}%",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Outside ☀️ Weather: ${sensorData['weather'] ?? '--'}",
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
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.blue.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          center: Alignment.center,
                          radius: 0.8,
                        ),
                        border: Border.all(color: Colors.blue, width: 6),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$_temperature°C',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _mode[0].toUpperCase() +
                          _mode.substring(1), // Cooling, Heating, etc.
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTempButton(Icons.remove, () => _changeTemperature(-1)),
                  const SizedBox(width: 20),
                  Text(
                    'Set Temperature',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 20),
                  _buildTempButton(Icons.add, () => _changeTemperature(1)),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildModeIconButton(Icons.ac_unit, 'Cool', 'cool'),
                  _buildModeIconButton(Icons.wb_sunny, 'Heat', 'heat'),
                  _buildModeIconButton(Icons.air, 'Fan', 'fan'),
                  _buildModeIconButton(Icons.opacity, 'Dry', 'dry'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: [
          BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(
                  Icons.power_settings_new,
                  size: 30,
                  color: _isPowerOn ? Colors.blue : Colors.red,
                ),
                const SizedBox(height: 4),
                Text(
                  'Power',
                  style: TextStyle(
                    color: _isPowerOn ? Colors.blue : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            label: '', // suppress default label
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.location_on, size: 30),
            label: 'Geofencing',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy, size: 30),
            label: 'Smart AI',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.schedule, size: 30),
            label: 'Scheduler',
          ),
        ],
      ),
    );
  }
}
