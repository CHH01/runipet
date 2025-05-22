// lib/core/constants/image_paths.dart

String getPetImagePath({
  required int stage,       // 1~5 (알~노년기)
  required String status,   // '행복', '배고픔', '우울', '고열', '감기', '배탈'
  required String type,     // 'dog', 'cat', 'rabbit'
}) {
  final stageNames = ['egg', 'hatch', 'child', 'adult', 'elder'];
  if (stage < 1 || stage > 5) return 'assets/images/pet/default.png';

  final folder = 'stage_${stage}_${stageNames[stage - 1]}';

  final imageName = switch (status) {
    '배고픔' => 'hungry',
    '우울' => 'sad',
    '고열' || '감기' || '배탈' => 'sick',
    _ => 'normal',
  };

  return 'assets/images/pet/$type/$folder/$imageName.png';
}
