import 'package:flutter/material.dart';
import 'package:health_tracker/features/health/presentation/providers/theme_provider.dart';
import 'package:health_tracker/features/health/presentation/screens/analytics_screen.dart';
import 'package:provider/provider.dart';

class HomeHeaderActions extends StatelessWidget {
  const HomeHeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            final isDark =
                themeProvider.themeMode == ThemeMode.dark ||
                (themeProvider.themeMode == ThemeMode.system &&
                    theme.brightness == Brightness.dark);

            return IconButton(
              onPressed: () => themeProvider.toggleTheme(!isDark),
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => RotationTransition(
                  turns: anim,
                  child: FadeTransition(opacity: anim, child: child),
                ),
                child: Icon(
                  isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                  key: ValueKey(isDark),
                  color: isDark
                      ? Colors.orangeAccent
                      : theme.colorScheme.primary,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
          ),
          child: Hero(
            tag: 'analytics_icon',
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                ),
              ),
              child: Icon(
                Icons.insights_rounded,
                color: theme.colorScheme.primary,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
