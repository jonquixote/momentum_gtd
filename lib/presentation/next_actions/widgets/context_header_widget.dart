import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ContextHeaderWidget extends StatelessWidget {
  final String currentContext;
  final String locationStatus;
  final String availableTime;
  final VoidCallback onSortTap;
  final VoidCallback onSearchTap;

  const ContextHeaderWidget({
    super.key,
    required this.currentContext,
    required this.locationStatus,
    required this.availableTime,
    required this.onSortTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentContext,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: locationStatus == 'Available'
                              ? 'location_on'
                              : 'location_off',
                          color: locationStatus == 'Available'
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          locationStatus,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: locationStatus == 'Available'
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                : colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: colorScheme.onSurfaceVariant,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          availableTime,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onSearchTap,
                    icon: CustomIconWidget(
                      iconName: 'search',
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    tooltip: 'Search actions',
                  ),
                  IconButton(
                    onPressed: onSortTap,
                    icon: CustomIconWidget(
                      iconName: 'sort',
                      color: colorScheme.onSurfaceVariant,
                      size: 24,
                    ),
                    tooltip: 'Sort options',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
