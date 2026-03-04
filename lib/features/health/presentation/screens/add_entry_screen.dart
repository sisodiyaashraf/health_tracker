import 'package:flutter/material.dart';
import 'package:health_tracker/features/health/presentation/widgets/add_entry_widgets.dart/add_entry_form_fields.dart';
import 'package:health_tracker/features/health/presentation/widgets/add_entry_widgets.dart/add_entry_section_header.dart';
import 'package:health_tracker/features/health/presentation/widgets/add_entry_widgets.dart/mood_selector.dart';
import 'package:provider/provider.dart';
import 'package:health_tracker/features/health/data/models/health_entry.dart';
import 'package:health_tracker/features/health/presentation/providers/health_provider.dart';
import '../../../../core/theme/app_theme.dart';

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

  static const Color darkBgBase = Color(0xFF0A0A0B);
  static const Color darkIndigoDepth = Color(0xFF1A122E);
  // Brand colors for the gradient
  static const Color brandPurple = Color(0xFF673AB7);
  static const Color deepPurple = Color(0xFF311B92);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthProvider>().loadEntries();
    });
  }

  void _submitData() {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<HealthProvider>(context, listen: false);

    if (provider.hasEntryForDate(DateTime.now())) {
      _showErrorSnackBar('Today\'s entry is already locked in!');
      return;
    }

    final newEntry = HealthEntry(
      date: DateTime.now(),
      mood: _selectedMood,
      sleepHours: double.parse(_sleepController.text),
      waterIntake: double.parse(_waterController.text),
      note: _noteController.text,
    );

    provider.saveEntry(newEntry).then((success) {
      if (success && mounted) {
        Navigator.pop(context);
      } else if (mounted) {
        _showErrorSnackBar('Failed to save entry. Please try again.');
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? darkBgBase : theme.colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? darkBgBase : theme.colorScheme.surface,
              isDark
                  ? darkIndigoDepth.withOpacity(0.4)
                  : theme.colorScheme.primaryContainer.withOpacity(0.15),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar.medium(
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Log Entry',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                ),
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
                        const AddEntrySectionHeader(
                          title: "Daily Reflection",
                          subtitle: "How are you feeling right now?",
                        ),
                        const SizedBox(height: 16),
                        _buildMoodCard(isDark),
                        const SizedBox(height: 32),
                        const AddEntrySectionHeader(
                          title: "Vital Metrics",
                          subtitle: "Input your physical data for today",
                        ),
                        const SizedBox(height: 16),
                        ModernTextField(
                          controller: _sleepController,
                          label: 'Sleep Duration',
                          hint: 'Hours (e.g., 7.5)',
                          icon: Icons.bedtime_rounded,
                          suffix: 'hrs',
                          validator: (val) {
                            final n = double.tryParse(val ?? '');
                            return (n == null || n < 0 || n > 24)
                                ? 'Enter 0-24'
                                : null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ModernTextField(
                          controller: _waterController,
                          label: 'Water Intake',
                          hint: 'Liters (e.g., 2.0)',
                          icon: Icons.water_drop_rounded,
                          suffix: 'L',
                          validator: (val) {
                            final n = double.tryParse(val ?? '');
                            return (n == null || n <= 0)
                                ? 'Enter value > 0'
                                : null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ModernTextField(
                          controller: _noteController,
                          label: 'Daily Notes',
                          hint: 'Any highlights or challenges?',
                          icon: Icons.notes_rounded,
                          maxLines: 4,
                        ),
                        const SizedBox(height: 48),
                        _buildSubmitButton(),
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

  Widget _buildMoodCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.white,
        ),
      ),
      child: MoodSelector(
        selectedMood: _selectedMood,
        onSelected: (mood) => setState(() => _selectedMood = mood),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        // Applying the brand gradient
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [brandPurple, deepPurple],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: brandPurple.withOpacity(0.35),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submitData,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Save Insights',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
