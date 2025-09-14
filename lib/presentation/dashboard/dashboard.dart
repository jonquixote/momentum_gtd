import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/active_projects_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/in_basket_widget.dart';
import './widgets/next_actions_widget.dart';
import './widgets/today_calendar_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isEmergencyMode = false;
  bool _isDeepWorkMode = false;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.easeInOut,
    ));
    _fabAnimationController.forward();
  }

  Future<void> _handleRefresh() async {
    // Provide haptic feedback
    HapticFeedback.lightImpact();

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 1));

    // Show success feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dashboard refreshed'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _handleSearch() {
    // Implement global search functionality
    showSearch(
      context: context,
      delegate: _GTDSearchDelegate(),
    );
  }

  void _toggleEmergencyMode() {
    setState(() {
      _isEmergencyMode = !_isEmergencyMode;
    });

    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEmergencyMode
              ? 'Emergency Simplification Mode activated'
              : 'Emergency Simplification Mode deactivated',
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            _isEmergencyMode ? AppTheme.warningLight : AppTheme.successLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleQuickCapture() {
    _showQuickCaptureModal();
  }

  void _showQuickCaptureModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildQuickCaptureModal(),
    );
  }

  Widget _buildQuickCaptureModal() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 40.h,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: 3.h),

          // Title
          Text(
            "Quick Capture",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),

          SizedBox(height: 4.h),

          // Capture options
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                children: [
                  _buildCaptureOption(
                    icon: 'edit',
                    title: 'Text Note',
                    subtitle: 'Quick text capture',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/universal-capture');
                    },
                    theme: theme,
                  ),
                  SizedBox(height: 2.h),
                  _buildCaptureOption(
                    icon: 'mic',
                    title: 'Voice Note',
                    subtitle: 'Record audio memo',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/universal-capture');
                    },
                    theme: theme,
                  ),
                  SizedBox(height: 2.h),
                  _buildCaptureOption(
                    icon: 'camera_alt',
                    title: 'Photo Capture',
                    subtitle: 'Capture document or image',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/universal-capture');
                    },
                    theme: theme,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureOption({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CustomIconWidget(
                iconName: icon,
                size: 24,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              size: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: _isEmergencyMode
          ? colorScheme.surface.withValues(alpha: 0.95)
          : colorScheme.surface,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: colorScheme.primary,
        backgroundColor: colorScheme.surface,
        child: CustomScrollView(
          slivers: [
            // Sticky header
            SliverToBoxAdapter(
              child: DashboardHeaderWidget(
                onSearchTap: _handleSearch,
                onEmergencyMode: _toggleEmergencyMode,
              ),
            ),

            // Main content
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 2.h),

                  // Emergency mode notice
                  if (_isEmergencyMode) _buildEmergencyModeNotice(theme),

                  // Today's Calendar
                  if (!_isEmergencyMode ||
                      _shouldShowInEmergencyMode('calendar'))
                    const TodayCalendarWidget(),

                  // In-Basket (always visible)
                  const InBasketWidget(),

                  // Next Actions
                  if (!_isEmergencyMode ||
                      _shouldShowInEmergencyMode('actions'))
                    const NextActionsWidget(),

                  // Active Projects
                  if (!_isEmergencyMode ||
                      _shouldShowInEmergencyMode('projects'))
                    const ActiveProjectsWidget(),

                  // Bottom padding for FAB
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: _handleQuickCapture,
          icon: CustomIconWidget(
            iconName: 'add',
            size: 24,
            color: Colors.white,
          ),
          label: Text(
            'Capture',
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: colorScheme.primary,
          elevation: 6,
          heroTag: "dashboard_capture",
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // Bottom Navigation
      bottomNavigationBar: const CustomBottomBar(
        currentIndex: 0, // Dashboard is at index 0
      ),
    );
  }

  Widget _buildEmergencyModeNotice(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.warningLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.warningLight.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'priority_high',
            size: 24,
            color: AppTheme.warningLight,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emergency Simplification Mode",
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.warningLight,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "Showing only essential elements to reduce cognitive load",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _toggleEmergencyMode,
            child: Text(
              "Exit",
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppTheme.warningLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _shouldShowInEmergencyMode(String component) {
    // In emergency mode, only show critical components
    switch (component) {
      case 'calendar':
        return true; // Today's schedule is essential
      case 'actions':
        return true; // Next actions are essential
      case 'projects':
        return false; // Projects can be hidden
      default:
        return false;
    }
  }
}

// Custom search delegate for global search
class _GTDSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Search actions, projects, notes...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final theme = Theme.of(context);

    if (query.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search',
              size: 64,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 2.h),
            Text(
              'Search across all your GTD data',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    // Mock search results
    final results = [
      'Review quarterly budget proposal',
      'Call Sarah about project timeline',
      'Website Redesign project',
      'Team Training Program',
    ]
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CustomIconWidget(
            iconName: 'search',
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }
}
