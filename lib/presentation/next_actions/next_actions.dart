import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_item_widget.dart';
import './widgets/context_chip_widget.dart';
import './widgets/context_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/focus_mode_widget.dart';

class NextActions extends StatefulWidget {
  const NextActions({super.key});

  @override
  State<NextActions> createState() => _NextActionsState();
}

class _NextActionsState extends State<NextActions>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedContext = '@office';
  String _sortBy = 'priority';
  bool _isSearchVisible = false;
  bool _isFocusMode = false;
  bool _isHyperfocusMode = false;
  bool _isSelectionMode = false;
  int _currentFocusIndex = 0;

  final TextEditingController _searchController = TextEditingController();
  final List<String> _selectedActionIds = [];

  // Mock data for contexts
  final List<Map<String, dynamic>> _contexts = [
    {
      'id': '@office',
      'label': 'Office',
      'icon': 'business',
      'taskCount': 8,
      'isLocationAvailable': true,
    },
    {
      'id': '@calls',
      'label': 'Calls',
      'icon': 'phone',
      'taskCount': 3,
      'isLocationAvailable': true,
    },
    {
      'id': '@computer',
      'label': 'Computer',
      'icon': 'computer',
      'taskCount': 12,
      'isLocationAvailable': true,
    },
    {
      'id': '@errands',
      'label': 'Errands',
      'icon': 'directions_car',
      'taskCount': 5,
      'isLocationAvailable': false,
    },
    {
      'id': '@home',
      'label': 'Home',
      'icon': 'home',
      'taskCount': 6,
      'isLocationAvailable': false,
    },
  ];

  // Mock data for actions
  final List<Map<String, dynamic>> _allActions = [
    {
      'id': '1',
      'title': 'Review quarterly budget proposal',
      'context': '@office',
      'project': 'Q4 Planning',
      'timeEstimate': 45,
      'energyLevel': 'High',
      'priority': 'high',
      'dueDate': DateTime.now().add(const Duration(days: 1)),
      'isCompleted': false,
    },
    {
      'id': '2',
      'title': 'Call client about project timeline',
      'context': '@calls',
      'project': 'Website Redesign',
      'timeEstimate': 15,
      'energyLevel': 'Medium',
      'priority': 'medium',
      'dueDate': DateTime.now(),
      'isCompleted': false,
    },
    {
      'id': '3',
      'title': 'Update project documentation',
      'context': '@computer',
      'project': 'API Development',
      'timeEstimate': 30,
      'energyLevel': 'Medium',
      'priority': 'medium',
      'dueDate': null,
      'isCompleted': false,
    },
    {
      'id': '4',
      'title': 'Schedule team meeting for next week',
      'context': '@office',
      'project': null,
      'timeEstimate': 10,
      'energyLevel': 'Low',
      'priority': 'low',
      'dueDate': DateTime.now().add(const Duration(days: 3)),
      'isCompleted': false,
    },
    {
      'id': '5',
      'title': 'Research new productivity tools',
      'context': '@computer',
      'project': 'Team Efficiency',
      'timeEstimate': 60,
      'energyLevel': 'High',
      'priority': 'low',
      'dueDate': null,
      'isCompleted': false,
    },
    {
      'id': '6',
      'title': 'Pick up office supplies',
      'context': '@errands',
      'project': null,
      'timeEstimate': 20,
      'energyLevel': 'Low',
      'priority': 'medium',
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'isCompleted': false,
    },
    {
      'id': '7',
      'title': 'Prepare presentation slides',
      'context': '@computer',
      'project': 'Client Presentation',
      'timeEstimate': 90,
      'energyLevel': 'High',
      'priority': 'high',
      'dueDate': DateTime.now().add(const Duration(days: 5)),
      'isCompleted': false,
    },
    {
      'id': '8',
      'title': 'Follow up with vendor quotes',
      'context': '@calls',
      'project': 'Office Renovation',
      'timeEstimate': 25,
      'energyLevel': 'Medium',
      'priority': 'medium',
      'dueDate': DateTime.now().add(const Duration(days: 1)),
      'isCompleted': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredActions {
    List<Map<String, dynamic>> actions = _allActions
        .where((action) =>
            action['context'] == _selectedContext && !action['isCompleted'])
        .toList();

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      actions = actions
          .where((action) =>
              (action['title'] as String).toLowerCase().contains(searchTerm) ||
              (action['project'] as String?)
                      ?.toLowerCase()
                      .contains(searchTerm) ==
                  true)
          .toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'priority':
        actions.sort((a, b) {
          const priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
          return (priorityOrder[a['priority']] ?? 3)
              .compareTo(priorityOrder[b['priority']] ?? 3);
        });
        break;
      case 'time':
        actions.sort((a, b) =>
            (a['timeEstimate'] as int).compareTo(b['timeEstimate'] as int));
        break;
      case 'energy':
        actions.sort((a, b) {
          const energyOrder = {'High': 0, 'Medium': 1, 'Low': 2};
          return (energyOrder[a['energyLevel']] ?? 3)
              .compareTo(energyOrder[b['energyLevel']] ?? 3);
        });
        break;
      case 'due':
        actions.sort((a, b) {
          final aDate = a['dueDate'] as DateTime?;
          final bDate = b['dueDate'] as DateTime?;
          if (aDate == null && bDate == null) return 0;
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          return aDate.compareTo(bDate);
        });
        break;
    }

    return actions;
  }

  String get _currentLocationStatus {
    final context = _contexts.firstWhere((c) => c['id'] == _selectedContext);
    return context['isLocationAvailable'] ? 'Available' : 'Not Available';
  }

  String get _availableTime {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour < 12) return '4h 30m until lunch';
    if (hour < 17) return '${17 - hour}h until end of day';
    return 'Evening time';
  }

  void _handleContextChange(String contextId) {
    setState(() {
      _selectedContext = contextId;
      _isSelectionMode = false;
      _selectedActionIds.clear();
    });
    HapticFeedback.lightImpact();
  }

  void _handleSortTap() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Sort Actions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 2.h),
            _buildSortOption('priority', 'Priority', 'priority_high'),
            _buildSortOption('time', 'Time Required', 'schedule'),
            _buildSortOption('energy', 'Energy Level', 'battery_charging_full'),
            _buildSortOption('due', 'Due Date', 'event'),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String value, String label, String icon) {
    final theme = Theme.of(context);
    final isSelected = _sortBy == value;

    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurfaceVariant,
        size: 24,
      ),
      title: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      trailing: isSelected
          ? CustomIconWidget(
              iconName: 'check',
              color: theme.colorScheme.primary,
              size: 20,
            )
          : null,
      onTap: () {
        setState(() => _sortBy = value);
        Navigator.pop(context);
        HapticFeedback.lightImpact();
      },
    );
  }

  void _handleSearchTap() {
    setState(() => _isSearchVisible = !_isSearchVisible);
    if (!_isSearchVisible) {
      _searchController.clear();
    }
  }

  void _handleActionComplete(String actionId) {
    setState(() {
      final actionIndex = _allActions.indexWhere((a) => a['id'] == actionId);
      if (actionIndex != -1) {
        _allActions[actionIndex]['isCompleted'] = true;
      }
      _selectedActionIds.remove(actionId);
    });

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action completed! 🎉'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleActionEdit(String actionId) {
    // Navigate to edit screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit action functionality'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleActionDefer(String actionId) {
    // Show defer options
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Defer action functionality'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleActionDelegate(String actionId) {
    // Show delegate options
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Delegate action functionality'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleActionConvertToProject(String actionId) {
    // Convert to project
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Convert to project functionality'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleActionTap(String actionId) {
    if (_isSelectionMode) {
      setState(() {
        if (_selectedActionIds.contains(actionId)) {
          _selectedActionIds.remove(actionId);
          if (_selectedActionIds.isEmpty) {
            _isSelectionMode = false;
          }
        } else {
          _selectedActionIds.add(actionId);
        }
      });
      HapticFeedback.lightImpact();
    }
  }

  void _handleActionLongPress(String actionId) {
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedActionIds.add(actionId);
      });
      HapticFeedback.mediumImpact();
    }
  }

  void _enterFocusMode() {
    final actions = _filteredActions;
    if (actions.isNotEmpty) {
      setState(() {
        _isFocusMode = true;
        _currentFocusIndex = 0;
      });
    }
  }

  void _enterHyperfocusMode() {
    final actions = _filteredActions;
    if (actions.isNotEmpty) {
      setState(() {
        _isFocusMode = true;
        _isHyperfocusMode = true;
        _currentFocusIndex = 0;
      });
    }
  }

  void _exitFocusMode() {
    setState(() {
      _isFocusMode = false;
      _isHyperfocusMode = false;
      _currentFocusIndex = 0;
    });
  }

  void _nextFocusAction() {
    final actions = _filteredActions;
    if (_currentFocusIndex < actions.length - 1) {
      setState(() => _currentFocusIndex++);
    } else {
      _exitFocusMode();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All actions completed! Great work! 🎉'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void _handleBulkComplete() {
    for (final actionId in _selectedActionIds) {
      _handleActionComplete(actionId);
    }
    setState(() {
      _isSelectionMode = false;
      _selectedActionIds.clear();
    });
  }

  void _handleBulkDefer() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bulk defer ${_selectedActionIds.length} actions'),
        duration: const Duration(seconds: 1),
      ),
    );
    setState(() {
      _isSelectionMode = false;
      _selectedActionIds.clear();
    });
  }

  void _handleBulkChangeContext() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Bulk change context for ${_selectedActionIds.length} actions'),
        duration: const Duration(seconds: 1),
      ),
    );
    setState(() {
      _isSelectionMode = false;
      _selectedActionIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isFocusMode) {
      final actions = _filteredActions;
      if (actions.isNotEmpty && _currentFocusIndex < actions.length) {
        return Scaffold(
          body: FocusModeWidget(
            currentAction: actions[_currentFocusIndex],
            onComplete: () {
              _handleActionComplete(actions[_currentFocusIndex]['id']);
              _nextFocusAction();
            },
            onNext: _nextFocusAction,
            onExit: _exitFocusMode,
            isHyperfocusMode: _isHyperfocusMode,
          ),
        );
      }
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          if (_isSearchVisible) _buildSearchBar(),
          _buildContextChips(),
          _buildContextHeader(),
          Expanded(child: _buildActionsList()),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);

    if (_isSelectionMode) {
      return AppBar(
        title: Text('${_selectedActionIds.length} selected'),
        leading: IconButton(
          onPressed: () {
            setState(() {
              _isSelectionMode = false;
              _selectedActionIds.clear();
            });
          },
          icon: CustomIconWidget(
            iconName: 'close',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _handleBulkComplete,
            icon: CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 24,
            ),
            tooltip: 'Mark Complete',
          ),
          IconButton(
            onPressed: _handleBulkDefer,
            icon: CustomIconWidget(
              iconName: 'schedule',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Defer',
          ),
          IconButton(
            onPressed: _handleBulkChangeContext,
            icon: CustomIconWidget(
              iconName: 'swap_horiz',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            tooltip: 'Change Context',
          ),
        ],
      );
    }

    return AppBar(
      title: Text('Next Actions'),
      actions: [
        IconButton(
          onPressed: _enterFocusMode,
          icon: CustomIconWidget(
            iconName: 'center_focus_strong',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
          tooltip: 'Focus Mode',
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'hyperfocus':
                _enterHyperfocusMode();
                break;
              case 'voice':
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Voice navigation activated')),
                );
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'hyperfocus',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'psychology',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text('Hyperfocus Mode'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'voice',
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'mic',
                    color: theme.colorScheme.onSurface,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text('Voice Navigation'),
                ],
              ),
            ),
          ],
          icon: CustomIconWidget(
            iconName: 'more_vert',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search actions or projects...',
          prefixIcon: CustomIconWidget(
            iconName: 'search',
            color: theme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildContextChips() {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        itemCount: _contexts.length,
        itemBuilder: (context, index) {
          final contextData = _contexts[index];
          return ContextChipWidget(
            label: contextData['label'],
            icon: contextData['icon'],
            isSelected: _selectedContext == contextData['id'],
            taskCount: contextData['taskCount'],
            isLocationAvailable: contextData['isLocationAvailable'],
            onTap: () => _handleContextChange(contextData['id']),
          );
        },
      ),
    );
  }

  Widget _buildContextHeader() {
    final contextData =
        _contexts.firstWhere((c) => c['id'] == _selectedContext);

    return ContextHeaderWidget(
      currentContext: contextData['label'],
      locationStatus: _currentLocationStatus,
      availableTime: _availableTime,
      onSortTap: _handleSortTap,
      onSearchTap: _handleSearchTap,
    );
  }

  Widget _buildActionsList() {
    final actions = _filteredActions;

    if (actions.isEmpty) {
      final contextData =
          _contexts.firstWhere((c) => c['id'] == _selectedContext);
      return EmptyStateWidget(
        currentContext: contextData['label'],
        onSwitchContext: () {
          // Switch to context with most actions
          final contextWithMostActions = _contexts
              .where((c) => c['taskCount'] > 0)
              .reduce((a, b) => a['taskCount'] > b['taskCount'] ? a : b);
          _handleContextChange(contextWithMostActions['id']);
        },
        onCaptureNew: () => Navigator.pushNamed(context, '/universal-capture'),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Actions refreshed'),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: ListView.builder(
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return ActionItemWidget(
            action: action,
            isSelected: _selectedActionIds.contains(action['id']),
            onComplete: () => _handleActionComplete(action['id']),
            onEdit: () => _handleActionEdit(action['id']),
            onDefer: () => _handleActionDefer(action['id']),
            onDelegate: () => _handleActionDelegate(action['id']),
            onConvertToProject: () =>
                _handleActionConvertToProject(action['id']),
            onTap: () {
              if (_isSelectionMode) {
                _handleActionTap(action['id']);
              } else {
                _handleActionLongPress(action['id']);
              }
            },
          );
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, '/universal-capture'),
      tooltip: 'Quick Capture',
      child: CustomIconWidget(
        iconName: 'add',
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
