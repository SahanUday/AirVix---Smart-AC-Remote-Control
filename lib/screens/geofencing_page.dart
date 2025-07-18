import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';

class GeofencingPage extends StatefulWidget {
  const GeofencingPage({super.key});

  @override
  State<GeofencingPage> createState() => _GeofencingPageState();
}

class _GeofencingPageState extends State<GeofencingPage> {
  final dbRef =
      FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://airvix-ef027-default-rtdb.asia-southeast1.firebasedatabase.app/',
      ).ref();

  bool geofencingEnabled = false;
  String currentStatus = "Unknown";
  String entryAction = "AC_ON";
  String exitAction = "AC_OFF";

  double targetLat = 6.796675;
  double targetLng = 79.899982;
  double radiusMeters = 7;

  bool wasInside = false;
  Stream<Position>? positionStream;
  StreamSubscription<Position>? positionSubscription;

  final List<String> actionOptions = ["AC_ON", "AC_OFF", "cool_24", "cool_20"];

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void dispose() {
    positionSubscription?.cancel();
    super.dispose();
  }

  Future<void> _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      _showNotification("Location permission permanently denied.");
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showNotification("Location services are disabled.");
    }
  }

  void _toggleGeofencing(bool value) async {
    setState(() {
      geofencingEnabled = value;
    });

    if (value) {
      _startLocationMonitoring();
      _showNotification("Geofencing Enabled");
    } else {
      _stopLocationMonitoring();
      _showNotification("Geofencing Disabled");
    }
  }

  void _startLocationMonitoring() {
    positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      final double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        targetLat,
        targetLng,
      );

      final bool isInside = distance <= radiusMeters;

      if (!wasInside && isInside) {
        _sendCommand(entryAction);
        _showNotification("Entered Home: $entryAction");
        setState(() => currentStatus = "Home");
      } else if (wasInside && !isInside) {
        _sendCommand(exitAction);
        _showNotification("Exited Home: $exitAction");
        setState(() => currentStatus = "Away");
      }

      wasInside = isInside;
    });
  }

  void _stopLocationMonitoring() {
    positionSubscription?.cancel();
    positionSubscription = null;
  }

  Future<void> _sendCommand(String action) async {
    try {
      await dbRef.child("ac_control/current_command").set(action);
    } catch (e) {
      _showNotification("Failed to send command: $e");
    }
  }

  void _showEditAreaDialog() {
    final latController = TextEditingController(text: targetLat.toString());
    final lngController = TextEditingController(text: targetLng.toString());
    final radiusController = TextEditingController(
      text: radiusMeters.toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            "Edit Geofence Area",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: latController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Latitude"),
                style: TextStyle(color: Colors.white),
              ),
              TextField(
                controller: lngController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Longitude"),
                style: TextStyle(color: Colors.white),
              ),
              TextField(
                controller: radiusController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Radius (m)"),
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  targetLat = double.tryParse(latController.text) ?? targetLat;
                  targetLng = double.tryParse(lngController.text) ?? targetLng;
                  radiusMeters =
                      double.tryParse(radiusController.text) ?? radiusMeters;
                });
                Navigator.pop(context);
                _showNotification("Geofence area updated");
              },
              child: Text("Save", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

  void _showNotification(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Geofencing Control",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        "Geofencing",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        "Automatically control AC based on your location.",
                        style: TextStyle(color: Colors.white70),
                      ),
                      value: geofencingEnabled,
                      onChanged: _toggleGeofencing,
                      activeColor: Colors.blue,
                      contentPadding: EdgeInsets.zero,
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current Status: ${currentStatus == "Home" ? "🟢 Home" : "🔴 Away"}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _showEditAreaDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Edit Area",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Entry & Exit Actions",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: entryAction,
                      dropdownColor: Colors.grey[900],
                      decoration: InputDecoration(
                        labelText: 'When Entering "Home"',
                      ),
                      items:
                          actionOptions.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                      onChanged: (val) => setState(() => entryAction = val!),
                    ),
                    SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: exitAction,
                      dropdownColor: Colors.grey[900],
                      decoration: InputDecoration(
                        labelText: 'When Exiting "Home"',
                      ),
                      items:
                          actionOptions.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                      onChanged: (val) => setState(() => exitAction = val!),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
