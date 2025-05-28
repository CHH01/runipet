import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ExerciseSummaryScreen extends StatelessWidget {
  final List<LatLng> path;
  final double totalDistance; // meter 단위
  final Duration totalTime;
  final int xpEarned;
  final int coinsEarned;

  const ExerciseSummaryScreen({
    super.key,
    required this.path,
    required this.totalDistance,
    required this.totalTime,
    required this.xpEarned,
    required this.coinsEarned,
  });

  @override
  Widget build(BuildContext context) {
    final double km = totalDistance / 1000;
    final double kcal = km * 55;                     // 간단한 칼로리 계산

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
                _summaryItem('총 거리', '${km.toStringAsFixed(2)} km'),
                _summaryItem('총 시간', _formatDuration(totalTime)),
                _summaryItem('칼로리 소모', '${kcal.toStringAsFixed(0)} kcal'),
                _summaryItem('획득 경험치', '$xpEarned xp'),
                _summaryItem('획득 코인', '$coinsEarned 코인'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, {
                      'xp': xpEarned,
                      'coins': coinsEarned,
                      'buff': {
                        'type': 'exercise',
                        'duration': 120,
                        'effect': 0.4, // 40% 질병 확률 하향
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: Text('확인', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(fontSize: 16)),
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
