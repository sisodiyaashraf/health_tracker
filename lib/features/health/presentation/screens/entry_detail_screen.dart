import 'package:flutter/material.dart';
import 'package:health_tracker/features/health/presentation/widgets/entry_detail_widgets.dart/detail_metric_grid.dart';
import 'package:health_tracker/features/health/presentation/widgets/entry_detail_widgets.dart/detail_mood_header.dart';
import 'package:health_tracker/features/health/presentation/widgets/entry_detail_widgets.dart/detail_reflections_card.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Standardized lowercase package imports to fix Type Mismatch error
import 'package:health_tracker/features/health/data/models/health_entry.dart';
import 'package:health_tracker/features/health/presentation/providers/health_provider.dart';
import 'package:health_tracker/core/theme/app_theme.dart';

// Corrected widget imports (removed .dart from folder names)

class EntryDetailScreen extends StatelessWidget {
  final HealthEntry entry;

  const EntryDetailScreen({super.key, required this.entry});

  static const Color darkBgBase = Color(0xFF0A0A0B);
  static const Color darkIndigoDepth = Color(0xFF1A122E);

  void _confirmDelete(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        surfaceTintColor:
            Colors.transparent, // Prevents purple tint in Material 3
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text(
          "Delete Entry?",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        content: const Text(
          "This will permanently remove this health log from your journey.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<HealthProvider>().deleteEntry(entry);
                Navigator.pop(context); // Close Dialog
                Navigator.pop(context); // Go back Home
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Entry deleted successfully"),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.roseRed,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Delete"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? darkBgBase
          : Theme.of(context).colorScheme.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              isDark ? darkBgBase : Theme.of(context).colorScheme.surface,
              isDark
                  ? darkIndigoDepth.withOpacity(0.4)
                  : Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.15),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar.large(
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: isDark ? Colors.white : Colors.black,
                  size: 20,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppTheme.roseRed,
                  ),
                  onPressed: () => _confirmDelete(context),
                ),
                const SizedBox(width: 8),
              ],
              title: Text(
                DateFormat('MMMM d, yyyy').format(entry.date),
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  DetailMoodHeader(entry: entry),
                  const SizedBox(height: 48),
                  DetailMetricGrid(entry: entry),
                  const SizedBox(height: 40),
                  DetailReflectionsCard(entry: entry),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
