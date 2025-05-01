import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class StartExerciseScreen extends StatefulWidget {
  const StartExerciseScreen({super.key});

  @override
  State<StartExerciseScreen> createState() => _StartExerciseScreenState();
}

class _StartExerciseScreenState extends State<StartExerciseScreen> {
  GoogleMapController? _mapController;
  static const LatLng _defaultLocation = LatLng(36.802935, 127.069930);
  LatLng _currentLocation = _defaultLocation;

  // 📌 예시 데이터 (이후 DB 연동 시 여기만 바꾸면 됨)
  String petName = '루니펫';
  double distanceKm = 2.13;
  Duration exerciseTime = Duration(minutes: 32);
  int kcal = 278;

  @override
  void initState() {
    super.initState();
    _moveToCurrentLocation();
  }

  void _moveToCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _currentLocation = LatLng(position.latitude, position.longitude);

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_currentLocation));
    }
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    return '$minutes분';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _defaultLocation,
              zoom: 15,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) {
              _mapController = controller;
              _moveToCurrentLocation();
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              margin: EdgeInsets.only(bottom: 20, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$petName과 지난 활동',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('거리', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text('${distanceKm.toStringAsFixed(2)} km'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('시간', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text(formatDuration(exerciseTime)),
                        ],
                      ),
                      Column(
                        children: [
                          Text('칼로리', style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text('$kcal'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/map_tracking');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text('운동 시작'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
