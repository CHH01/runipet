import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'services/challenge_service.dart';
import 'services/user_settings_service.dart';
import 'services/notification_service.dart';
import 'services/pitstop_service.dart';
import 'providers/pitstop_provider.dart';
import 'providers/leaderboard_provider.dart';
import 'services/leaderboard_service.dart';
import 'providers/inventory_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/user_settings_provider.dart';
import 'providers/challenge_provider.dart';
import 'providers/shop_provider.dart';
import 'providers/pet_provider.dart';
import 'providers/exercise_provider.dart';
import 'screens/main_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/find_id_screen.dart';
import 'screens/find_password_screen.dart';
import 'screens/reset_password_screen.dart';
import 'screens/pet_select_screen.dart';
import 'providers/social_provider.dart';
import 'providers/auth_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final secureStorage = const FlutterSecureStorage();
  final baseUrl = 'http://10.0.2.2:5000';
  final apiService = ApiService(
    baseUrl: baseUrl,
    secureStorage: secureStorage,
  );
  final challengeService = ChallengeService(
    apiService,
    secureStorage,
    baseUrl,
  );
  final userSettingsService = UserSettingsService(
    apiService,
    secureStorage,
    baseUrl,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => PetProvider(apiService),
        ),
        ChangeNotifierProvider(
          create: (_) => ChallengeProvider(challengeService),
        ),
        ChangeNotifierProvider(
          create: (_) => UserSettingsProvider(userSettingsService),
        ),
      ],
      child: MyApp(
        apiService: apiService,
        challengeService: challengeService,
        userSettingsService: userSettingsService,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ApiService apiService;
  final ChallengeService challengeService;
  final UserSettingsService userSettingsService;

  const MyApp({
    super.key,
    required this.apiService,
    required this.challengeService,
    required this.userSettingsService,
  });

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService(apiService);
    final pitStopService = PitStopService(apiService);
    final leaderboardService = LeaderboardService(apiService);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
        ChangeNotifierProvider(create: (_) => ChallengeProvider(challengeService)),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider(apiService)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(notificationService, userSettingsService)),
        ChangeNotifierProvider(create: (_) => UserSettingsProvider(userSettingsService)),
        ChangeNotifierProvider(create: (_) => PitStopProvider(pitStopService)),
        ChangeNotifierProvider(create: (_) => LeaderboardProvider(leaderboardService)),
        ChangeNotifierProvider(create: (_) => PetProvider(apiService)),
        ChangeNotifierProvider(create: (_) => ExerciseProvider(apiService)),
        ChangeNotifierProvider(create: (_) => SocialProvider(apiService)),
      ],
      child: MaterialApp(
        title: 'RuniPet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
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
