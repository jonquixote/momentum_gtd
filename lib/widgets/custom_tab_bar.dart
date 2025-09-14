import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tab item data structure for custom tab navigation
class TabItem {
  final String label;
  final IconData? icon;
  final Widget? content;
  final String? route;

  const TabItem({
    required this.label,
    this.icon,
    this.content,
    this.route,
  });
}

/// Custom tab bar implementing contextual organization with cognitive minimalism
/// Provides smooth transitions and haptic feedback for enhanced user experience
class CustomTabBar extends StatefulWidget {
  final List<TabItem> tabs;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final double indicatorWeight;
  final TabBarIndicatorSize indicatorSize;
  final EdgeInsets padding;
  final bool isScrollable;
  final bool showIcons;
  final double tabHeight;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.indicatorWeight = 2.0,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.isScrollable = false,
    this.showIcons = false,
    this.tabHeight = 48.0,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      final newIndex = _tabController.index;
      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
        });

        // Provide haptic feedback
        HapticFeedback.lightImpact();

        // Call the callback
        widget.onTabChanged?.call(newIndex);

        // Navigate if route is provided
        final tab = widget.tabs[newIndex];
        if (tab.route != null) {
          Navigator.pushNamed(context, tab.route!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        tabs: _buildTabs(),
        labelColor: widget.selectedColor ?? colorScheme.primary,
        unselectedLabelColor:
            widget.unselectedColor ?? colorScheme.onSurfaceVariant,
        indicatorColor: widget.indicatorColor ?? colorScheme.secondary,
        indicatorWeight: widget.indicatorWeight,
        indicatorSize: widget.indicatorSize,
        isScrollable: widget.isScrollable,
        tabAlignment:
            widget.isScrollable ? TabAlignment.start : TabAlignment.fill,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        splashFactory: InkRipple.splashFactory,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return (widget.selectedColor ?? colorScheme.primary)
                .withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.hovered)) {
            return (widget.selectedColor ?? colorScheme.primary)
                .withValues(alpha: 0.05);
          }
          return null;
        }),
      ),
    );
  }

  List<Widget> _buildTabs() {
    return widget.tabs.map((tab) {
      return SizedBox(
        height: widget.tabHeight,
        child: Tab(
          icon: widget.showIcons && tab.icon != null
              ? Icon(tab.icon, size: 20)
              : null,
          text: tab.label,
          iconMargin: widget.showIcons && tab.icon != null
              ? const EdgeInsets.only(bottom: 4)
              : EdgeInsets.zero,
        ),
      );
    }).toList();
  }
}

/// Custom tab view that works with CustomTabBar for complete tab navigation
class CustomTabView extends StatefulWidget {
  final List<TabItem> tabs;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final double indicatorWeight;
  final TabBarIndicatorSize indicatorSize;
  final EdgeInsets tabBarPadding;
  final bool isScrollable;
  final bool showIcons;
  final double tabHeight;
  final EdgeInsets contentPadding;

  const CustomTabView({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.indicatorWeight = 2.0,
    this.indicatorSize = TabBarIndicatorSize.label,
    this.tabBarPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.isScrollable = false,
    this.showIcons = false,
    this.tabHeight = 48.0,
    this.contentPadding = EdgeInsets.zero,
  });

  @override
  State<CustomTabView> createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = TabController(
      length: widget.tabs.length,
      initialIndex: widget.initialIndex,
      vsync: this,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      final newIndex = _tabController.index;
      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
        });

        // Provide haptic feedback
        HapticFeedback.lightImpact();

        // Call the callback
        widget.onTabChanged?.call(newIndex);

        // Navigate if route is provided
        final tab = widget.tabs[newIndex];
        if (tab.route != null) {
          Navigator.pushNamed(context, tab.route!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Tab Bar
        Container(
          padding: widget.tabBarPadding,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: TabBar(
            controller: _tabController,
            tabs: _buildTabs(),
            labelColor: widget.selectedColor ?? colorScheme.primary,
            unselectedLabelColor:
                widget.unselectedColor ?? colorScheme.onSurfaceVariant,
            indicatorColor: widget.indicatorColor ?? colorScheme.secondary,
            indicatorWeight: widget.indicatorWeight,
            indicatorSize: widget.indicatorSize,
            isScrollable: widget.isScrollable,
            tabAlignment:
                widget.isScrollable ? TabAlignment.start : TabAlignment.fill,
            labelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
            splashFactory: InkRipple.splashFactory,
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return (widget.selectedColor ?? colorScheme.primary)
                    .withValues(alpha: 0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return (widget.selectedColor ?? colorScheme.primary)
                    .withValues(alpha: 0.05);
              }
              return null;
            }),
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabs.map((tab) {
              return Container(
                padding: widget.contentPadding,
                child: tab.content ??
                    Center(
                      child: Text(
                        'Content for ${tab.label}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTabs() {
    return widget.tabs.map((tab) {
      return SizedBox(
        height: widget.tabHeight,
        child: Tab(
          icon: widget.showIcons && tab.icon != null
              ? Icon(tab.icon, size: 20)
              : null,
          text: tab.label,
          iconMargin: widget.showIcons && tab.icon != null
              ? const EdgeInsets.only(bottom: 4)
              : EdgeInsets.zero,
        ),
      );
    }).toList();
  }
}

/// Segmented control style tab bar for compact spaces
class CustomSegmentedTabBar extends StatefulWidget {
  final List<TabItem> tabs;
  final int initialIndex;
  final ValueChanged<int>? onTabChanged;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius borderRadius;
  final double height;

  const CustomSegmentedTabBar({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.padding = const EdgeInsets.all(4),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.height = 40.0,
  });

  @override
  State<CustomSegmentedTabBar> createState() => _CustomSegmentedTabBarState();
}

class _CustomSegmentedTabBarState extends State<CustomSegmentedTabBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final backgroundColor =
        widget.backgroundColor ?? colorScheme.surfaceContainerHighest;
    final selectedColor = widget.selectedColor ?? colorScheme.primary;
    final unselectedColor =
        widget.unselectedColor ?? colorScheme.onSurfaceVariant;

    return Container(
      margin: widget.margin,
      height: widget.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: widget.borderRadius,
      ),
      padding: widget.padding,
      child: Row(
        children: widget.tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == _currentIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => _handleTabTap(index, tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor : Colors.transparent,
                  borderRadius: widget.borderRadius.subtract(
                    BorderRadius.circular(widget.padding.horizontal / 2),
                  ),
                ),
                child: Center(
                  child: Text(
                    tab.label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? Colors.white : unselectedColor,
                      letterSpacing: 0.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _handleTabTap(int index, TabItem tab) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      // Provide haptic feedback
      HapticFeedback.lightImpact();

      // Call the callback
      widget.onTabChanged?.call(index);

      // Navigate if route is provided
      if (tab.route != null) {
        Navigator.pushNamed(context, tab.route!);
      }
    }
  }
}
