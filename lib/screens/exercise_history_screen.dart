import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exercise_provider.dart';
import '../models/exercise_record.dart';

class ExerciseHistoryScreen extends StatefulWidget {
  const ExerciseHistoryScreen({super.key});

  @override
  State<ExerciseHistoryScreen> createState() => _ExerciseHistoryScreenState();
}

class _ExerciseHistoryScreenState extends State<ExerciseHistoryScreen> {
  String _selectedPeriod = '전체';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ExerciseProvider>().loadExerciseRecords();
    });
  }

  List<ExerciseRecord> _getFilteredRecords(ExerciseProvider provider) {
    switch (_selectedPeriod) {
      case '오늘':
        return provider.getTodayExerciseRecords();
      case '이번 주':
        return provider.getThisWeekExerciseRecords();
      case '이번 달':
        return provider.getThisMonthExerciseRecords();
      default:
        return provider.exerciseRecords;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 기록'),
        backgroundColor: Colors.orange,
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.loadExerciseRecords(),
                    child: Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          final records = _getFilteredRecords(provider);

          if (records.isEmpty) {
            return Center(
              child: Text('운동 기록이 없습니다.'),
            );
          }

          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPeriodButton('전체'),
                    _buildPeriodButton('오늘'),
                    _buildPeriodButton('이번 주'),
                    _buildPeriodButton('이번 달'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.orange,
                          child: Icon(
                            Icons.directions_walk,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          '${record.startTime.year}년 ${record.startTime.month}월 ${record.startTime.day}일',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${record.startTime.hour}:${record.startTime.minute.toString().padLeft(2, '0')} - ${record.endTime.hour}:${record.endTime.minute.toString().padLeft(2, '0')}',
                            ),
                            Text(
                              '거리: ${record.distance}km | 칼로리: ${record.calories}kcal | 걸음: ${record.steps}걸음',
                            ),
                          ],
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPeriodButton(String period) {
    final isSelected = _selectedPeriod == period;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedPeriod = period;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(period),
    );
  }
} 