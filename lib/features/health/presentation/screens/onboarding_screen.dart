import 'package:flutter/material.dart';
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
      if (mounted)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
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
    const Color brandPurple = Color(0xFF673AB7);
    const Color deepPurple = Color(0xFF311B92); // Darker shade for gradient

    return Scaffold(
      body: Container(
        // 1. Premium Radial Gradient Background
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.5, -0.5),
            radius: 1.5,
            colors: [brandPurple, deepPurple],
          ),
        ),
        child: Stack(
          children: [
            // 2. Subtle Background Pattern Layer
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: CustomPaint(painter: GridPainter()),
              ),
            ),

            Scaffold(
              backgroundColor: Colors.transparent, // Let gradient show through
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  AnimatedOpacity(
                    opacity: _currentPage < 2 ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: TextButton(
                      onPressed: _currentPage < 2 ? _skipToLastPage : null,
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              body: Stack(
                children: [
                  PageView(
                    controller: _controller,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
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

                  // Bottom Panel
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 240,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(40),
                        ),
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
                              (index) => _buildIndicator(index),
                            ),
                          ),
                          const Spacer(),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _currentPage == 2
                                ? ElevatedButton(
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
                                    ),
                                    child: const Text(
                                      "Get Started",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : _buildModernNextButton(brandPurple),
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

  Widget _buildModernNextButton(Color color) {
    return GestureDetector(
      onTap: () => _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutQuart,
      ),
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(
          Icons.chevron_right_rounded,
          size: 36,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    bool isSelected = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 6,
      width: isSelected ? 30 : 10,
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF673AB7) : Colors.grey.shade300,
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
            height: 220,
            width: 220,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24, width: 2),
            ),
            padding: const EdgeInsets.all(30),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => const Icon(
                Icons.spa_rounded,
                size: 100,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(height: 50),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              color: Colors.white.withOpacity(0.85),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

// 3. Custom Painter for the background pattern
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset(i.toDouble(), size.height),
        paint,
      );
    }
    for (var i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i.toDouble()),
        Offset(size.width, i.toDouble()),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
