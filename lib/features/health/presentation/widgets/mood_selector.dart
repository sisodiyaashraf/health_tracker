import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String selectedMood;
  final Function(String) onSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onSelected,
  });

  static const Map<String, String> _moodEmojis = {
    'Good': '😊',
    'Okay': '😐',
    'Bad': '😔',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _moodEmojis.keys.map((mood) {
        final isSelected = selectedMood == mood;
        return ChoiceChip(
          label: Text("${_moodEmojis[mood]} $mood"),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) onSelected(mood);
          },
          selectedColor: theme.colorScheme.primaryContainer,
        );
      }).toList(),
    );
  }
}
