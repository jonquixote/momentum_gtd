import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TodayCalendarWidget extends StatelessWidget {
  const TodayCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock calendar events data
    final List<Map<String, dynamic>> todayEvents = [
      {
        "id": 1,
        "title": "Team Standup",
        "time": "09:00 AM",
        "duration": "30 min",
        "type": "meeting",
        "location": "@office",
        "isTimeBlocked": true,
        "color": AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        "id": 2,
        "title": "Client Presentation",
        "time": "02:00 PM",
        "duration": "1 hour",
        "type": "presentation",
        "location": "@conference-room",
        "isTimeBlocked": true,
        "color": AppTheme.warningLight,
      },
      {
        "id": 3,
        "title": "Code Review Session",
        "time": "04:30 PM",
        "duration": "45 min",
        "type": "review",
        "location": "@computer",
        "isTimeBlocked": false,
        "color": AppTheme.successLight,
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Calendar",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.secondary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${todayEvents.length} events",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Calendar Events List
          todayEvents.isEmpty
              ? _buildEmptyState(theme)
              : _buildEventsList(todayEvents, theme),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'calendar_today',
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            "No events scheduled",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Your calendar is clear for today",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Map<String, dynamic>> events, ThemeData theme) {
    return Column(
      children: events.map((event) => _buildEventCard(event, theme)).toList(),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final eventColor = event["color"] as Color;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Card(
        elevation: 2,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            // Handle event tap
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                // Time block indicator
                Container(
                  width: 4,
                  height: 12.h,
                  decoration: BoxDecoration(
                    color: eventColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                SizedBox(width: 4.w),

                // Event details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and time blocking badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event["title"] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (event["isTimeBlocked"] == true) ...[
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: AppTheme.successLight
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Blocked",
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppTheme.successLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Time and duration
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'access_time',
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "${event["time"]} • ${event["duration"]}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Location context
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'location_on',
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            event["location"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action button
                IconButton(
                  onPressed: () {
                    // Handle more actions
                  },
                  icon: CustomIconWidget(
                    iconName: 'more_vert',
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  splashRadius: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
