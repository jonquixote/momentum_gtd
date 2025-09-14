import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data structure for bottom navigation
class NavigationItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom bottom navigation bar implementing gesture-first navigation
/// Provides haptic feedback and smooth transitions for mobile productivity
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;
  final bool showLabels;

  // Hardcoded navigation items for GTD productivity app
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    NavigationItem(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'Capture',
      route: '/universal-capture',
    ),
    NavigationItem(
      icon: Icons.inbox_outlined,
      activeIcon: Icons.inbox,
      label: 'In-Basket',
      route: '/in-basket-processing',
    ),
    NavigationItem(
      icon: Icons.task_alt_outlined,
      activeIcon: Icons.task_alt,
      label: 'Next Actions',
      route: '/next-actions',
    ),
    NavigationItem(
      icon: Icons.folder_outlined,
      activeIcon: Icons.folder,
      label: 'Projects',
      route: '/projects',
    ),
  ];

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 8.0,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: elevation,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: showLabels ? 65 : 56,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildNavigationItem(
                context,
                item,
                index,
                isSelected,
                colorScheme,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    NavigationItem item,
    int index,
    bool isSelected,
    ColorScheme colorScheme,
  ) {
    final selectedColor = selectedItemColor ?? colorScheme.primary;
    final unselectedColor = unselectedItemColor ?? colorScheme.onSurfaceVariant;
    final currentColor = isSelected ? selectedColor : unselectedColor;

    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(context, index, item.route),
        borderRadius: BorderRadius.circular(12),
        splashColor: selectedColor.withValues(alpha: 0.1),
        highlightColor: selectedColor.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with smooth transition
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                child: Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  key: ValueKey(isSelected),
                  color: currentColor,
                  size: 24,
                ),
              ),

              // Label with fade transition
              if (showLabels) ...[
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: currentColor,
                    letterSpacing: 0.4,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, int index, String route) {
    // Provide haptic feedback for satisfying interaction
    HapticFeedback.lightImpact();

    // Call the onTap callback if provided
    onTap?.call(index);

    // Navigate to the selected route if it's different from current
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }
}

/// Floating bottom navigation bar variant for elevated appearance
class CustomFloatingBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;
  final EdgeInsets margin;
  final BorderRadius borderRadius;

  const CustomFloatingBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 12.0,
    this.margin = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: margin,
      child: Material(
        elevation: elevation,
        borderRadius: borderRadius,
        color: backgroundColor ?? colorScheme.surface,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: backgroundColor ?? colorScheme.surface,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                CustomBottomBar._navigationItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = index == currentIndex;

              return _buildFloatingNavigationItem(
                context,
                item,
                index,
                isSelected,
                colorScheme,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingNavigationItem(
    BuildContext context,
    NavigationItem item,
    int index,
    bool isSelected,
    ColorScheme colorScheme,
  ) {
    final selectedColor = selectedItemColor ?? colorScheme.primary;
    final unselectedColor = unselectedItemColor ?? colorScheme.onSurfaceVariant;
    final currentColor = isSelected ? selectedColor : unselectedColor;

    return Expanded(
      child: InkWell(
        onTap: () => _handleTap(context, index, item.route),
        borderRadius: BorderRadius.circular(12),
        splashColor: selectedColor.withValues(alpha: 0.1),
        highlightColor: selectedColor.withValues(alpha: 0.05),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with background highlight for selected state
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                  color: currentColor,
                  size: 24,
                ),
              ),

              const SizedBox(height: 2),

              // Compact label
              Text(
                item.label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: currentColor,
                  letterSpacing: 0.4,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, int index, String route) {
    // Provide haptic feedback for satisfying interaction
    HapticFeedback.lightImpact();

    // Call the onTap callback if provided
    onTap?.call(index);

    // Navigate to the selected route if it's different from current
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false,
      );
    }
  }
}
