import 'package:flutter/material.dart';

class OnboardingIndicator extends StatelessWidget {
  final int count;
  final int currentPage;
  final Color activeColor;

  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentPage,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 6,
          width: currentPage == index ? 30 : 10,
          decoration: BoxDecoration(
            color: currentPage == index
                ? activeColor
                : Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
