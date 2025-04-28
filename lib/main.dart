import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/find_id_screen.dart';
import 'screens/find_password_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/start_exercise_screen.dart';
import 'screens/map_tracking_screen.dart';
import 'screens/map_summary_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuniPet',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/find_id': (context) => const FindIdScreen(),
        '/find_password': (context) => const FindPasswordScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/start_exercise': (context) => const StartExerciseScreen(),
        '/map_tracking': (context) => const MapTrackingScreen(), 
        '/map_summary': (context) => const MapSummaryScreen(  
          path: [], totalDistance: 0, totalTime: Duration.zero,
           ), 
      },
    );
  }
}
