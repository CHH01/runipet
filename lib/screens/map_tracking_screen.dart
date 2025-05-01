import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'map_summary_screen.dart';

class MapTrackingScreen extends StatefulWidget {
  const MapTrackingScreen({super.key});

  @override
  State<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends State<MapTrackingScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  final List<LatLng> _polylineCoordinates = [];
  final Set<Marker> _markers = {};
  final Map<String, String> _visitedMarkers = {}; // ✅ 하루 1회 방문 체크용

  bool _isPaused = false;
  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;
  double _totalDistance = 0;
  final Stopwatch _stopwatch = Stopwatch();
  static const LatLng _defaultLocation = LatLng(36.802935, 127.069930);

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _startTracking();
  }

  void _setMarkers() {
    _markers.add(
      Marker(
        markerId: MarkerId('cheonan_stadium'),
        position: LatLng(36.819124, 127.116824),
        infoWindow: InfoWindow(title: '천안종합운동장'),
      ),
    );
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
    for (var marker in _markers) {
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        marker.position.latitude,
        marker.position.longitude,
      );

      if (distance < 30) {
        String markerId = marker.markerId.value;
        String today = DateTime.now().toIso8601String().split('T').first;

        if (_visitedMarkers[markerId] == today) {
          _showAlreadyVisitedAlert();
        } else {
          _visitedMarkers[markerId] = today;
          _showRewardPopup(marker.infoWindow.title ?? '이벤트 장소');
        }
      }
    }
  }

  void _showRewardPopup(String title) {
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
              Text('+500xp    +사료 2개 획득',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center),
              SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
                child: Text('확인', style: TextStyle(color: Colors.orange)),
              ),
            ],
          ),
        ),
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapSummaryScreen(
          path: _polylineCoordinates,
          totalDistance: _totalDistance,
          totalTime: _stopwatch.elapsed,
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
      appBar: AppBar(title: Text('운동 추적')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _defaultLocation, zoom: 15),
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
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF3E0),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoItem('뛴 거리', '${(_totalDistance / 1000).toStringAsFixed(1)}km'),
                      _infoItem('시간', _formatDuration(_stopwatch.elapsed)),
                      _infoItem('칼로리', '55kcal'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _pauseOrResumeTracking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isPaused ? Colors.green : Colors.redAccent,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text(_isPaused ? '운동 재개' : '운동 일시정지'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _stopTracking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text('운동 종료'),
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
}
