import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import 'exercise_tracking_screen.dart';

class StartExerciseScreen extends StatefulWidget {
  const StartExerciseScreen({super.key});

  @override
  State<StartExerciseScreen> createState() => _StartExerciseScreenState();
}

class _StartExerciseScreenState extends State<StartExerciseScreen> {
  GoogleMapController? _mapController;
  static const LatLng _defaultLocation = LatLng(36.802935, 127.069930);
  LatLng _currentLocation = _defaultLocation;

  @override
  void initState() {
    super.initState();
    _moveToCurrentLocation();
    // 운동 기록 로드
    Future.microtask(() => 
      Provider.of<ExerciseProvider>(context, listen: false).loadExerciseHistory()
    );
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
    return Consumer<ExerciseProvider>(
      builder: (context, exerciseProvider, child) {
        if (exerciseProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (exerciseProvider.error != null) {
          return Center(child: Text('에러: ${exerciseProvider.error}'));
        }

        final lastExercise = exerciseProvider.exerciseHistory.isNotEmpty 
            ? exerciseProvider.exerciseHistory.first 
            : null;

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
                        '지난 활동',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15),
                      if (lastExercise != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text('거리', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text('${(lastExercise.distance / 1000).toStringAsFixed(1)} km'),
                              ],
                            ),
                            Column(
                              children: [
                                Text('시간', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text(formatDuration(Duration(seconds: lastExercise.duration))),
                              ],
                            ),
                            Column(
                              children: [
                                Text('칼로리', style: TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 5),
                                Text('${lastExercise.calories}'),
                              ],
                            ),
                          ],
                        ),
                      ] else ...[
                        Text('아직 운동 기록이 없습니다.'),
                      ],
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ExerciseTrackingScreen()),
                            );
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
      },
    );
  }
}
