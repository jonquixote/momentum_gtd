import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProjectFilterSheetWidget extends StatefulWidget {
  final String selectedFilter;
  final ValueChanged<String>? onFilterChanged;

  const ProjectFilterSheetWidget({
    super.key,
    required this.selectedFilter,
    this.onFilterChanged,
  });

  @override
  State<ProjectFilterSheetWidget> createState() =>
      _ProjectFilterSheetWidgetState();
}

class _ProjectFilterSheetWidgetState extends State<ProjectFilterSheetWidget> {
  late String _selectedFilter;

  final List<Map<String, dynamic>> _filterOptions = [
    {
      'key': 'all',
      'label': 'All Projects',
      'icon': 'folder',
      'description': 'Show all projects regardless of status',
    },
    {
      'key': 'active',
      'label': 'Active',
      'icon': 'play_circle',
      'description': 'Currently active projects',
    },
    {
      'key': 'on-hold',
      'label': 'On Hold',
      'icon': 'pause_circle',
      'description': 'Projects temporarily paused',
    },
    {
      'key': 'completed',
      'label': 'Completed',
      'icon': 'check_circle',
      'description': 'Successfully completed projects',
    },
    {
      'key': 'someday',
      'label': 'Someday/Maybe',
      'icon': 'schedule',
      'description': 'Future projects to consider',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Filter Projects',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedFilter = 'all';
                    });
                  },
                  child: Text(
                    'Clear',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filter options
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _filterOptions.length,
              itemBuilder: (context, index) {
                final option = _filterOptions[index];
                final isSelected = _selectedFilter == option['key'];

                return Container(
                  margin: EdgeInsets.only(bottom: 1.h),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.3)
                            : colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    tileColor: isSelected
                        ? colorScheme.primary.withValues(alpha: 0.05)
                        : Colors.transparent,
                    leading: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primary.withValues(alpha: 0.1)
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: option['icon'] as String,
                          size: 20,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    title: Text(
                      option['label'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Text(
                      option['description'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check_circle',
                            size: 24,
                            color: colorScheme.primary,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedFilter = option['key'] as String;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: () {
                  widget.onFilterChanged?.call(_selectedFilter);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Apply Filter',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
