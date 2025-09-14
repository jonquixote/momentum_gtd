import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../projects/projects.dart';

class ActiveProjectsWidget extends StatelessWidget {
  const ActiveProjectsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock active projects data
    final List<Map<String, dynamic>> activeProjects = [
      {
        "id": 1,
        "title": "Website Redesign",
        "description": "Complete overhaul of company website with new branding",
        "progress": 0.65,
        "nextAction": "Review wireframes with design team",
        "dueDate": "Dec 15, 2024",
        "totalActions": 12,
        "completedActions": 8,
        "status": "on-track",
        "priority": "high",
        "color": AppTheme.lightTheme.colorScheme.secondary,
      },
      {
        "id": 2,
        "title": "Q4 Budget Planning",
        "description":
            "Prepare and finalize budget allocations for next quarter",
        "progress": 0.40,
        "nextAction": "Gather department budget requests",
        "dueDate": "Dec 20, 2024",
        "totalActions": 8,
        "completedActions": 3,
        "status": "at-risk",
        "priority": "high",
        "color": AppTheme.warningLight,
      },
      {
        "id": 3,
        "title": "Team Training Program",
        "description":
            "Implement new skill development program for engineering team",
        "progress": 0.25,
        "nextAction": "Schedule training sessions",
        "dueDate": "Jan 10, 2025",
        "totalActions": 15,
        "completedActions": 4,
        "status": "on-track",
        "priority": "medium",
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
                "Active Projects",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/projects');
                },
                child: Text(
                  "View All",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Projects list
          activeProjects.isEmpty
              ? _buildEmptyState(theme)
              : _buildProjectsList(activeProjects, theme, context),
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
            iconName: 'folder_open',
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            "No active projects",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "Start a new project to see it here",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList(
      List<Map<String, dynamic>> projects, ThemeData theme, BuildContext context) {
    return Column(
      children: projects
          .take(3)
          .map((project) => _buildProjectCard(project, theme, context))
          .toList(),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, ThemeData theme, BuildContext context) {
    final colorScheme = theme.colorScheme;
    final projectColor = project["color"] as Color;
    final progress = project["progress"] as double;
    final status = project["status"] as String;
    final priority = project["priority"] as String;

    Color statusColor = AppTheme.successLight;
    if (status == "at-risk") statusColor = AppTheme.warningLight;
    if (status == "delayed") statusColor = AppTheme.errorLight;

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
            Navigator.pushNamed(context, '/projects');
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and status
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project["title"] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            project["description"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status.replaceAll('-', ' ').toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (priority == "high") ...[
                          SizedBox(height: 0.5.h),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.errorLight,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Progress bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Progress",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "${(progress * 100).toInt()}%",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor:
                          colorScheme.outline.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(projectColor),
                      minHeight: 6,
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Next action and stats
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Next Action:",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            project["nextAction"] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Footer with actions count and due date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'task',
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          "${project["completedActions"]}/${project["totalActions"]} actions",
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'event',
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          project["dueDate"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}