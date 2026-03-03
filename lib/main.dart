import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Architecture Imports
import 'features/health/data/models/health_entry.dart';
import 'features/health/data/local_data_source/health_local_datasource.dart';
import 'features/health/data/repositories/health_repository_impl.dart';
import 'features/health/presentation/providers/health_provider.dart';
import 'features/health/presentation/screens/home_screen.dart';
import 'features/health/presentation/screens/onboarding_screen.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // Ensure platform channels are ready
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 1. Initialize Hive Local Storage
    await Hive.initFlutter();

    // 2. Register Hive Adapter safely
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HealthEntryAdapter());
    }

    // 3. Handle Onboarding state with SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final bool isFirstRun = prefs.getBool('is_first_run') ?? true;

    runApp(MyApp(isFirstRun: isFirstRun));
  } catch (e) {
    debugPrint("Startup Critical Error: $e");
    // Fallback to safe state
    runApp(const MyApp(isFirstRun: true));
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;

  const MyApp({super.key, required this.isFirstRun});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 4. Dependency Injection: Data Source -> Repository -> Provider
        ChangeNotifierProvider(
          create: (_) {
            final localDataSource = HealthLocalDataSource();
            final repository = HealthRepository(
              localDataSource: localDataSource,
            );
            return HealthProvider(repository)..loadEntries();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Health Insight Tracker',
        debugShowCheckedModeBanner: false,

        // --- Theme Management from core/theme folder ---
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,

        // --- Navigation Logic ---
        home: isFirstRun ? const OnboardingScreen() : const HomeScreen(),
      ),
    );
  }
}
