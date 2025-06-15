import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../providers/pitstop_provider.dart';
import '../models/pitstop_data.dart';
import 'exercise_summary_screen.dart';

class ExerciseTrackingScreen extends StatefulWidget {
  const ExerciseTrackingScreen({super.key});

  @override
  State<ExerciseTrackingScreen> createState() => _ExerciseTrackingScreenState();
}

class _ExerciseTrackingScreenState extends State<ExerciseTrackingScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  final List<LatLng> _polylineCoordinates = [];
  final Set<Marker> _markers = {};
  final Map<String, String> _visitedMarkers = {};
  int _totalXp = 0;

  bool _isPaused = false;
  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;
  double _totalDistance = 0;
  final Stopwatch _stopwatch = Stopwatch();
  static const LatLng _defaultLocation = LatLng(36.802935, 127.069930);

  bool _isTracking = false;
  DateTime? _startTime;
  double _distance = 0;
  int _duration = 0;
  int _calories = 0;
  int _steps = 0;
  List<LatLng> _path = [];

  @override
  void initState() {
    super.initState();
    _loadPitStop();
    _startTracking();
    _startExercise();
  }

  Future<void> _loadPitStop() async {
    await Provider.of<PitStopProvider>(context, listen: false).loadPitStop();
    _setMarkers();
  }

  void _setMarkers() {
    final pitStop = Provider.of<PitStopProvider>(context, listen: false).pitStop;
    if (pitStop != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('sunmoon_gate'),
          position: LatLng(pitStop.latitude, pitStop.longitude),
          infoWindow: InfoWindow(
            title: pitStop.name,
            snippet: pitStop.description,
          ),
        ),
      );
    }
  }

  void _startTracking() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    _stopwatch.start();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
    ).listen((Position position) {
      LatLng newPos = LatLng(position.latitude, position.longitude);

      if (_lastPosition != null) {
        double distance = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          position.latitude,
          position.longitude,
        );
        _totalDistance += distance;
      }
      _lastPosition = position;

      setState(() {
        _polylineCoordinates.add(newPos);
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(newPos),
      );

      _checkProximity(newPos);
    });
  }

  void _checkProximity(LatLng currentPosition) {
    final pitStop = Provider.of<PitStopProvider>(context, listen: false).pitStop;
    if (pitStop == null) return;

    double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      pitStop.latitude,
      pitStop.longitude,
    );

    if (distance < 30) {
      String today = DateTime.now().toIso8601String().split('T').first;
      String markerId = 'sunmoon_gate';

      if (_visitedMarkers[markerId] == today) {
        _showAlreadyVisitedAlert();
      } else {
        _visitedMarkers[markerId] = today;
        _claimPitStopReward();
      }
    }
  }

  Future<void> _claimPitStopReward() async {
    try {
      final result = await Provider.of<PitStopProvider>(context, listen: false).claimReward();
      _showRewardPopup('선문대 서문', result['reward_value']);
    } catch (e) {
      _showErrorAlert(e.toString());
    }
  }

  void _showRewardPopup(String title, String rewardValue) {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.75,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.center),
              SizedBox(height: 12),
              Text('+$rewardValue 획득',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center),
              SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () {
                  setState(() {
                    _totalXp += int.parse(rewardValue);
                  });
                  Navigator.of(context).pop();
                },
                child: Text('확인', style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorAlert(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showAlreadyVisitedAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('이미 방문한 스탑입니다.'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    int h = duration.inHours;
    int m = duration.inMinutes % 60;
    return '${h}h ${m}m';
  }

  Widget _infoItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(value),
      ],
    );
  }

  void _pauseOrResumeTracking() {
    if (_isPaused) {
      _positionStream?.resume();
      _stopwatch.start();
    } else {
      _positionStream?.pause();
      _stopwatch.stop();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _stopTracking() {
    _positionStream?.cancel();
    _stopwatch.stop();

    double totalKm = _totalDistance / 1000;
    int earnedXp = (totalKm * 500).toInt() + _totalXp;
    int earnedCoins = (_totalDistance / 100 * 50).toInt();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseSummaryScreen(
          path: _polylineCoordinates,
          totalDistance: _totalDistance,
          totalTime: _stopwatch.elapsed,
          xpEarned: earnedXp,
          coinsEarned: earnedCoins,
        ),
      ),
    );
  }

  void _startExercise() {
    setState(() {
      _isTracking = true;
      _startTime = DateTime.now();
    });
    Provider.of<ExerciseProvider>(context, listen: false).startExercise();
  }

  void _updateExerciseProgress() {
    if (!_isTracking) return;

    setState(() {
      _duration = DateTime.now().difference(_startTime!).inSeconds;
      _distance += 0.01;
      _calories = (_distance * 60).round();
      _steps += 10;
    });

    Provider.of<ExerciseProvider>(context, listen: false).updateExerciseProgress(
      distance: _distance,
      duration: _duration,
      calories: _calories,
      steps: _steps,
    );
  }

  void _endExercise() {
    setState(() {
      _isTracking = false;
    });

    Provider.of<ExerciseProvider>(context, listen: false).endExercise();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseSummaryScreen(
          path: [],
          totalDistance: _distance,
          totalTime: Duration(seconds: _duration),
          xpEarned: (_distance * 10).round(),
          coinsEarned: (_distance * 5).round(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('운동 중'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('운동 종료'),
                content: const Text('운동을 종료하시겠습니까?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('취소'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _endExercise();
                    },
                    child: const Text('종료'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _defaultLocation,
              zoom: 15,
            ),
            markers: _markers,
            polylines: {
              Polyline(
                polylineId: PolylineId('tracking_route'),
                color: Colors.red,
                width: 5,
                points: _polylineCoordinates,
              ),
            },
            onMapCreated: (controller) {
              _controller.complete(controller);
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildExerciseMetric('거리', '${_distance.toStringAsFixed(2)} km'),
                      _buildExerciseMetric('시간', '${(_duration / 60).floor()}:${(_duration % 60).toString().padLeft(2, '0')}'),
                      _buildExerciseMetric('칼로리', '$_calories kcal'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pauseOrResumeTracking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isPaused ? Colors.green : Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            _isPaused ? '운동 재개' : '운동 일시정지',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _endExercise,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            '운동 종료',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseMetric(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
