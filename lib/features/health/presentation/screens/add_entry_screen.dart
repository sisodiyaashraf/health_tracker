import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/health_entry.dart';
import '../providers/health_provider.dart';
import '../widgets/mood_selector.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedMood = 'Good';
  final _sleepController = TextEditingController();
  final _waterController = TextEditingController();
  final _noteController = TextEditingController();

  void _submitData() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<HealthProvider>(context, listen: false);
    final today = DateTime.now();

    final alreadyExists = provider.entries.any(
      (e) =>
          e.date.year == today.year &&
          e.date.month == today.month &&
          e.date.day == today.day,
    );

    if (alreadyExists) {
      _showErrorSnackBar('Today\'s entry is already locked in!');
      return;
    }

    final newEntry = HealthEntry(
      date: today,
      mood: _selectedMood,
      sleepHours: double.parse(_sleepController.text),
      waterIntake: double.parse(_waterController.text),
      note: _noteController.text,
    );

    provider.saveEntry(newEntry);
    Navigator.pop(context);
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppTheme.roseRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.primaryContainer.withOpacity(0.15),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // FIXED APPBAR
            SliverAppBar.medium(
              pinned: true, // Keeps the title visible when scrolled
              floating: false,
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor:
                  theme.colorScheme.surface, // Material 3 elevation tint
              elevation: 0,
              title: const Text(
                'Log Entry',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          theme,
                          "Daily Reflection",
                          "How are you feeling right now?",
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white),
                          ),
                          child: MoodSelector(
                            selectedMood: _selectedMood,
                            onSelected: (mood) =>
                                setState(() => _selectedMood = mood),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildSectionHeader(
                          theme,
                          "Vital Metrics",
                          "Input your physical data for today",
                        ),
                        const SizedBox(height: 16),
                        _buildModernField(
                          controller: _sleepController,
                          label: 'Sleep Duration',
                          hint: 'Hours (e.g., 7.5)',
                          icon: Icons.bedtime_rounded,
                          suffix: 'hrs',
                          validator: (val) {
                            final n = double.tryParse(val ?? '');
                            if (n == null || n < 0 || n > 24)
                              return 'Enter 0-24';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildModernField(
                          controller: _waterController,
                          label: 'Water Intake',
                          hint: 'Liters (e.g., 2.0)',
                          icon: Icons.water_drop_rounded,
                          suffix: 'L',
                          validator: (val) {
                            final n = double.tryParse(val ?? '');
                            if (n == null || n <= 0) return 'Enter value > 0';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildModernField(
                          controller: _noteController,
                          label: 'Daily Notes',
                          hint: 'Any highlights or challenges?',
                          icon: Icons.notes_rounded,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 48),
                        _buildSubmitButton(theme),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitData,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.brandPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Save Insights',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildModernField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? suffix,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: maxLines > 1
              ? TextInputType.multiline
              : TextInputType.numberWithOptions(decimal: true),
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppTheme.brandPurple),
            suffixText: suffix,
            filled: true,
            fillColor: Colors.white.withOpacity(0.6),
            contentPadding: const EdgeInsets.all(20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
