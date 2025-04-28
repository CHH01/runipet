import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSummaryScreen extends StatelessWidget {
  final List<LatLng> path;
  final double totalDistance;
  final Duration totalTime;

  const MapSummaryScreen({
    Key? key,
    required this.path,
    required this.totalDistance,
    required this.totalTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double kcal = (totalDistance / 1000) * 55; // 간단한 칼로리 계산
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 기록 요약'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: path.isNotEmpty ? path.first : LatLng(0, 0),
                zoom: 16,
              ),
              polylines: {
                Polyline(
                  polylineId: PolylineId('summary_route'),
                  color: Colors.blue,
                  width: 5,
                  points: path,
                ),
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text('총 거리: ${(totalDistance/1000).toStringAsFixed(2)} km'),
                SizedBox(height: 10),
                Text('총 시간: ${_formatDuration(totalTime)}'),
                SizedBox(height: 10),
                Text('칼로리 소모: ${kcal.toStringAsFixed(0)} kcal'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return "${d.inHours}:$minutes:$seconds";
  }
}
