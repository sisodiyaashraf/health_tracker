import 'package:flutter/material.dart';
import 'package:health_tracker/core/theme/GridPainter.dart';
import 'package:health_tracker/features/health/presentation/widgets/onboarding_widgets.dart/onboarding_indicator.dart';
import 'package:health_tracker/features/health/presentation/widgets/onboarding_widgets.dart/onboarding_nav_button.dart';
import 'package:health_tracker/features/health/presentation/widgets/onboarding_widgets.dart/onboarding_page_content.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  static const Color brandPurple = Color(0xFF673AB7);
  static const Color deepPurple = Color(0xFF311B92);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_first_run', false);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, anim, secAnim) => const HomeScreen(),
          transitionsBuilder: (context, anim, secAnim, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.5, -0.5),
            radius: 1.5,
            colors: [brandPurple, deepPurple],
          ),
        ),
        child: Stack(
          children: [
            _buildGridBackground(),
            _buildAppBar(isDark),
            _buildPageView(),
            _buildBottomCard(theme, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildGridBackground() {
    return Positioned.fill(
      child: Opacity(opacity: 0.05, child: CustomPaint(painter: GridPainter())),
    );
  }

  Widget _buildAppBar(bool isDark) {
    return Positioned(
      top: 40,
      right: 20,
      child: AnimatedOpacity(
        opacity: _currentPage < 2 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: InkWell(
          onTap: () => _controller.animateToPage(
            2,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutBack,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(isDark ? 0.1 : 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView(
      controller: _controller,
      onPageChanged: (index) => setState(() => _currentPage = index),
      children: const [
        OnboardingPageContent(
          title: "Log Your Daily Vitals",
          description:
              "Easily track your mood, sleep, and hydration in seconds.",
          imagePath: "assets/image/note.png",
        ),
        OnboardingPageContent(
          title: "Unlock Health Insights",
          description: "Visualize your progress with smart 7-day trends.",
          imagePath: "assets/image/barchart.png",
        ),
        OnboardingPageContent(
          title: "Your Data, Your Control",
          description:
              "Secure local storage ensures your journey remains private.",
          imagePath: "assets/image/secure.png",
        ),
      ],
    );
  }

  Widget _buildBottomCard(ThemeData theme, bool isDark) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        ),
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            OnboardingIndicator(
              count: 3,
              currentPage: _currentPage,
              activeColor: brandPurple,
            ),
            const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _currentPage == 2
                  ? ElevatedButton(
                      onPressed: _completeOnboarding,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPurple,
                        minimumSize: const Size(double.infinity, 64),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    )
                  : _buildNavigationRow(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _currentPage > 0
            ? TextButton(
                onPressed: () => _controller.previousPage(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                ),
                child: Text(
                  "Back",
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
              )
            : const SizedBox(width: 60),
        OnboardingNavButton(
          currentPage: _currentPage,
          color: brandPurple,
          onTap: () => _controller.nextPage(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          ),
        ),
      ],
    );
  }
}
