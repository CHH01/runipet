import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSummaryScreen extends StatelessWidget {
  final List<LatLng> path;
  final double totalDistance;
  final Duration totalTime;

  const MapSummaryScreen({
    super.key,
    required this.path,
    required this.totalDistance,
    required this.totalTime,
  });

  @override
  Widget build(BuildContext context) {
    double kcal = (totalDistance / 1000) * 55;
    double expGained = 1.2; // 경험치 획득률은 임시 값
    double currentExp = 0.225; // 현재 경험치 (22.5%)

    return Scaffold(
      appBar: AppBar(title: Text('운동 기록 요약')),
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
                  color: Colors.red,
                  width: 5,
                  points: path,
                ),
              },
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),
          Container(
            width: double.infinity,
            color: Color(0xFFFFF3E0),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _summaryItem('뛴 거리', '${(totalDistance / 1000).toStringAsFixed(1)}km'),
                    _summaryItem('뛴 시간', '${totalTime.inMinutes}m'),
                    _summaryItem('소모한 칼로리', '${kcal.toStringAsFixed(0)}kcal'),
                  ],
                ),
                SizedBox(height: 20),
                Text('경험치 ${expGained.toStringAsFixed(1)}% 획득',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 10),
                LinearProgressIndicator(
                  value: currentExp,
                  minHeight: 14,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 10),
                Text('${(currentExp * 100).toStringAsFixed(1)}%',
                    style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }

}
