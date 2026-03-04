import 'package:flutter/material.dart';

class OnboardingNavButton extends StatelessWidget {
  final int currentPage;
  final VoidCallback onTap;
  final Color color;

  const OnboardingNavButton({
    super.key,
    required this.currentPage,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (currentPage + 1) / 3;

    return GestureDetector(
      onTap: onTap,
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
}
