import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'map_summary_screen.dart';

class MapTrackingScreen extends StatefulWidget {
  const MapTrackingScreen({Key? key}) : super(key: key);

  @override
  State<MapTrackingScreen> createState() => _MapTrackingScreenState();
}

class _MapTrackingScreenState extends State<MapTrackingScreen> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  List<LatLng> _polylineCoordinates = [];
  Set<Marker> _markers = {};
  bool _isTracking = true;
  bool _isPaused = false;
  StreamSubscription<Position>? _positionStream;
  Position? _lastPosition;
  double _totalDistance = 0;
  Stopwatch _stopwatch = Stopwatch();

  static const LatLng _defaultLocation = LatLng(36.802935, 127.069930); // 수정된 기본 위치

  @override
  void initState() {
    super.initState();
    _setMarkers();
    _startTracking();
  }

  void _setMarkers() {
    _markers.add(
      Marker(
        markerId: MarkerId('special_location'),
        position: LatLng(36.802935, 127.069930), // ✅ 이벤트 지역 마커 수정
        infoWindow: InfoWindow(title: '이벤트 지역'),
      ),
    );
  }

  void _startTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('GPS 꺼져있음');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('GPS 권한 거부됨');
      }
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

      _checkProximity(newPos);
    });
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
    setState(() {
      _isTracking = false;
    });

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

  void _checkProximity(LatLng currentPosition) {
    for (var marker in _markers) {
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        marker.position.latitude,
        marker.position.longitude,
      );

      if (distance < 30) { // 30m 이내 접근 시
        _showEventDialog();
      }
    }
  }

  void _showEventDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('이벤트 발생!'),
        content: Text('마커 근처에 도착했습니다! +500xp, +아이템'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  void _moveToCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(currentLatLng),
      );
    }
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
        title: Text('운동 추적'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _defaultLocation, // 기본 지도 위치 수정
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
              _moveToCurrentLocation();
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            bottom: 30,
            left: 30,
            right: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: _pauseOrResumeTracking,
                  child: Text(_isPaused ? '운동 재개' : '운동 일시정지'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isPaused ? Colors.green : Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _stopTracking,
                  child: Text('운동 종료'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
