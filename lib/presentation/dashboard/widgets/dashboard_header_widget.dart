import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onEmergencyMode;

  const DashboardHeaderWidget({
    super.key,
    this.onSearchTap,
    this.onEmergencyMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock data
    final DateTime now = DateTime.now();
    final String formattedDate = _formatDate(now);
    final String weatherInfo = "22°C • Partly Cloudy";
    final bool isOnline = true;
    final String stressLevel = "Low"; // Mock stress detection

    return Container(
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top row with sync status and emergency mode
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sync indicator
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isOnline
                            ? AppTheme.successLight
                            : AppTheme.errorLight,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      isOnline ? "Synced" : "Offline",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // Stress level indicator (if detected)
                if (stressLevel != "None")
                  GestureDetector(
                    onLongPress: onEmergencyMode,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color:
                            _getStressColor(stressLevel).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _getStressColor(stressLevel)
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'psychology',
                            size: 14,
                            color: _getStressColor(stressLevel),
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            "Stress: $stressLevel",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _getStressColor(stressLevel),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            SizedBox(height: 2.h),

            // Main header content
            Row(
              children: [
                // Date and weather info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        formattedDate,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'wb_sunny',
                            size: 16,
                            color: AppTheme.warningLight,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            weatherInfo,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Search button
                Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: onSearchTap,
                    icon: CustomIconWidget(
                      iconName: 'search',
                      size: 24,
                      color: colorScheme.primary,
                    ),
                    tooltip: 'Global Search',
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Quick stats row
            _buildQuickStats(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
    final colorScheme = theme.colorScheme;

    // Mock quick stats
    final List<Map<String, dynamic>> stats = [
      {
        "label": "Today's Actions",
        "value": "5",
        "icon": "today",
        "color": AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        "label": "Completed",
        "value": "12",
        "icon": "check_circle",
        "color": AppTheme.successLight,
      },
      {
        "label": "Projects",
        "value": "3",
        "icon": "folder",
        "color": AppTheme.warningLight,
      },
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 1.w),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: (stat["color"] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (stat["color"] as Color).withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                CustomIconWidget(
                  iconName: stat["icon"] as String,
                  size: 20,
                  color: stat["color"] as Color,
                ),
                SizedBox(height: 1.h),
                Text(
                  stat["value"] as String,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: stat["color"] as Color,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  stat["label"] as String,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return "$weekday, $month ${date.day}";
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  Color _getStressColor(String stressLevel) {
    switch (stressLevel.toLowerCase()) {
      case "low":
        return AppTheme.successLight;
      case "medium":
        return AppTheme.warningLight;
      case "high":
        return AppTheme.errorLight;
      default:
        return AppTheme.successLight;
    }
  }
}
