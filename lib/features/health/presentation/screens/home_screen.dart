import 'package:flutter/material.dart';
import 'package:health_tracker/features/health/presentation/widgets/home_widgets.dart/health_entry_card.dart';
import 'package:health_tracker/features/health/presentation/widgets/home_widgets.dart/home_background_grid.dart';
import 'package:health_tracker/features/health/presentation/widgets/home_widgets.dart/home_empty_state.dart';
import 'package:health_tracker/features/health/presentation/widgets/home_widgets.dart/home_header_actions.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import 'add_entry_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const Color darkBgBase = Color(0xFF0A0A0B);
    const Color darkIndigoDepth = Color(0xFF1A122E);

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
                  : theme.colorScheme.primaryContainer.withOpacity(0.25),
            ],
          ),
        ),
        child: Stack(
          children: [
            const HomeBackgroundGrid(),
            RefreshIndicator(
              displacement: 100,
              onRefresh: () => context.read<HealthProvider>().loadEntries(),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverAppBar.large(
                    backgroundColor: Colors.transparent,
                    title: const Text(
                      'My Health',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    surfaceTintColor: Colors.transparent,
                    actions: const [HomeHeaderActions()],
                  ),
                  Consumer<HealthProvider>(
                    builder: (context, provider, _) {
                      if (provider.entries.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: HomeEmptyState(),
                        );
                      }
                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => HealthEntryCard(
                              entry: provider.entries[index],
                              index: index,
                            ),
                            childCount: provider.entries.length,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          // 1. BrandPurple to DeepPurple Gradient
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF673AB7), // brandPurple
              Color(0xFF311B92), // deepPurple
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF673AB7).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddEntryScreen()),
          ),
          // 2. Make FAB background transparent to show the Container gradient
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0, // Elevation handled by Container shadow
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          icon: const Icon(Icons.add_rounded, size: 24),
          label: const Text(
            'New Entry',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }
}
