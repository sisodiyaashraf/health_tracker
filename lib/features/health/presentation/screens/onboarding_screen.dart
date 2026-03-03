import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/GridPainter.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    try {
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
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    }
  }

  void _skipToLastPage() {
    _controller.animateToPage(
      2,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const Color brandPurple = Color(0xFF673AB7);
    const Color deepPurple = Color(0xFF311B92);

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
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: CustomPaint(painter: GridPainter()),
              ),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  AnimatedOpacity(
                    opacity: _currentPage < 2 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: InkWell(
                        onTap: _currentPage < 2 ? _skipToLastPage : null,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            // Glass effect optimized for background visibility
                            color: Colors.white.withOpacity(
                              isDark ? 0.1 : 0.15,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
              body: Stack(
                children: [
                  PageView(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    children: [
                      _buildPage(
                        "Log Your Daily Vitals",
                        "Easily track your mood, sleep, and hydration in seconds.",
                        "assets/image/note.png",
                      ),
                      _buildPage(
                        "Unlock Health Insights",
                        "Visualize your progress with smart 7-day trends.",
                        "assets/image/barchart.png",
                      ),
                      _buildPage(
                        "Your Data, Your Control",
                        "Secure local storage ensures your journey remains private.",
                        "assets/image/secure.png",
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 250,
                      decoration: BoxDecoration(
                        // Adapt to theme surface for Dark Mode support
                        color: theme.colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
                        boxShadow: [
                          if (isDark)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 20,
                              offset: const Offset(0, -10),
                            ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 32,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => _buildIndicator(index, brandPurple),
                            ),
                          ),
                          const Spacer(),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            child: _currentPage == 2
                                ? ElevatedButton(
                                    key: const ValueKey('cta_btn'),
                                    onPressed: _completeOnboarding,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: brandPurple,
                                      minimumSize: const Size(
                                        double.infinity,
                                        64,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      elevation: 10,
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
                                : _buildNavigationRow(brandPurple, theme),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationRow(Color color, ThemeData theme) {
    return Row(
      key: const ValueKey('nav_row'),
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
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
              )
            : const SizedBox(width: 60),
        Row(
          children: [
            Text(
              "Next",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 12),
            _buildModernNextButton(color),
          ],
        ),
      ],
    );
  }

  Widget _buildModernNextButton(Color color) {
    double progress = (_currentPage + 1) / 3;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _controller.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 75,
            width: 75,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Container(
            height: 59,
            width: 59,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index, Color activeColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 6,
      width: _currentPage == index ? 30 : 10,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? activeColor
            : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildPage(String title, String description, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            padding: const EdgeInsets.all(30),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.85),
              height: 1.6,
            ),
          ),
          // Using a spacer or flexible spacing is safer for varied screen heights
          const SizedBox(height: 280),
        ],
      ),
    );
  }
}
