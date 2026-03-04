import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Standardized Package Imports
import 'package:health_tracker/features/health/data/models/health_entry.dart';
import 'package:health_tracker/features/health/data/local_data_source/health_local_datasource.dart';
import 'package:health_tracker/features/health/data/repositories/health_repository_impl.dart';
import 'package:health_tracker/features/health/presentation/providers/health_provider.dart';
import 'package:health_tracker/features/health/presentation/providers/theme_provider.dart';
import 'package:health_tracker/features/health/presentation/screens/home_screen.dart';
import 'package:health_tracker/features/health/presentation/screens/onboarding_screen.dart';
import 'package:health_tracker/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();

    // Register Hive Adapter
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HealthEntryAdapter());
    }

    final prefs = await SharedPreferences.getInstance();
    // Use 'is_first_run' to check if we show Onboarding
    final bool isFirstRun = prefs.getBool('is_first_run') ?? true;

    runApp(MyApp(isFirstRun: isFirstRun));
  } catch (e) {
    debugPrint("Startup Critical Error: $e");
    runApp(const MyApp(isFirstRun: true));
  }
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;

  // Constructor with required named parameter
  const MyApp({super.key, required this.isFirstRun});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (context) {
            // Logic moved into a clean variable for readability
            final localDataSource = HealthLocalDataSource();
            final repository = HealthRepository(
              localDataSource: localDataSource,
            );

            // Returns provider and immediately starts loading data
            return HealthProvider(repository)..loadEntries();
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Health Insight Tracker',
            debugShowCheckedModeBanner: false,

            // Dynamic theme switching
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            // Select starting screen based on first-run logic
            home: isFirstRun ? const OnboardingScreen() : const HomeScreen(),
          );
        },
      ),
    );
  }
}
