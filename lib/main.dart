import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pet_provider.dart';
import 'providers/exercise_provider.dart';
import 'providers/challenge_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/inventory_provider.dart';
import 'providers/ranking_provider.dart';
import 'providers/notification_provider.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/find_id_screen.dart';
import 'screens/find_password_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/pet_select_screen.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
        ChangeNotifierProvider(create: (_) => ChallengeProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
        ChangeNotifierProvider(create: (_) => RankingProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'RuniPet',
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => SignUpScreen(),
          '/find_id': (context) => const FindIdScreen(),
          '/find_password': (context) => const FindPasswordScreen(),
          '/reset_password': (context) => const ResetPasswordScreen(),
          '/pet_select': (context) => const PetSelectScreen(),
          '/main': (context) => const MainScreen(),
        },
      ),
    );
  }
}
