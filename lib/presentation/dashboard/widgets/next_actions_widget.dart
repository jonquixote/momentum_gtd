import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NextActionsWidget extends StatefulWidget {
  const NextActionsWidget({super.key});

  @override
  State<NextActionsWidget> createState() => _NextActionsWidgetState();
}

class _NextActionsWidgetState extends State<NextActionsWidget> {
  String selectedContext = "all";

  // Mock next actions data
  final List<Map<String, dynamic>> nextActions = [
    {
      "id": 1,
      "title": "Review quarterly budget proposal",
      "context": "@computer",
      "project": "Q4 Planning",
      "priority": "high",
      "estimatedTime": "45 min",
      "dueDate": "Today",
      "isAvailable": true,
      "tags": ["urgent", "review"],
    },
    {
      "id": 2,
      "title": "Call Sarah about project timeline",
      "context": "@calls",
      "project": "Website Redesign",
      "priority": "medium",
      "estimatedTime": "15 min",
      "dueDate": "Tomorrow",
      "isAvailable": true,
      "tags": ["follow-up"],
    },
    {
      "id": 3,
      "title": "Pick up office supplies",
      "context": "@errands",
      "project": "Office Management",
      "priority": "low",
      "estimatedTime": "30 min",
      "dueDate": "This week",
      "isAvailable": false,
      "tags": ["shopping"],
    },
    {
      "id": 4,
      "title": "Update project documentation",
      "context": "@computer",
      "project": "API Development",
      "priority": "medium",
      "estimatedTime": "1 hour",
      "dueDate": "Friday",
      "isAvailable": true,
      "tags": ["documentation"],
    },
  ];

  final List<Map<String, dynamic>> contexts = [
    {"id": "all", "label": "All", "icon": "view_list", "count": 4},
    {"id": "@calls", "label": "Calls", "icon": "phone", "count": 1},
    {"id": "@computer", "label": "Computer", "icon": "computer", "count": 2},
    {
      "id": "@errands",
      "label": "Errands",
      "icon": "directions_car",
      "count": 1
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filteredActions = selectedContext == "all"
        ? nextActions
        : nextActions
            .where((action) => action["context"] == selectedContext)
            .toList();

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
                "Next Actions",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/next-actions');
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

          // Context filter chips
          _buildContextChips(theme),

          SizedBox(height: 2.h),

          // Actions list
          filteredActions.isEmpty
              ? _buildEmptyState(theme)
              : _buildActionsList(filteredActions, theme),
        ],
      ),
    );
  }

  Widget _buildContextChips(ThemeData theme) {
    return SizedBox(
      height: 5.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: contexts.length,
        itemBuilder: (context, index) {
          final contextItem = contexts[index];
          final isSelected = selectedContext == contextItem["id"];

          return Container(
            margin: EdgeInsets.only(right: 2.w),
            child: FilterChip(
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedContext = contextItem["id"] as String;
                });
              },
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: contextItem["icon"] as String,
                    size: 16,
                    color: isSelected
                        ? Colors.white
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    "${contextItem["label"]} (${contextItem["count"]})",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              backgroundColor: theme.colorScheme.surface,
              selectedColor: theme.colorScheme.primary,
              checkmarkColor: Colors.white,
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
          );
        },
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
            iconName: 'task_alt',
            size: 48,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            "No actions available",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            "All caught up in this context!",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsList(
      List<Map<String, dynamic>> actions, ThemeData theme) {
    return Column(
      children: actions
          .take(3)
          .map((action) => _buildActionCard(action, theme))
          .toList(),
    );
  }

  Widget _buildActionCard(Map<String, dynamic> action, ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isAvailable = action["isAvailable"] as bool;
    final priority = action["priority"] as String;

    Color priorityColor = AppTheme.successLight;
    if (priority == "high") priorityColor = AppTheme.errorLight;
    if (priority == "medium") priorityColor = AppTheme.warningLight;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Slidable(
        key: ValueKey(action["id"]),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                // Handle complete action
              },
              backgroundColor: AppTheme.successLight,
              foregroundColor: Colors.white,
              icon: Icons.check,
              label: 'Complete',
            ),
            SlidableAction(
              onPressed: (context) {
                // Handle defer action
              },
              backgroundColor: AppTheme.warningLight,
              foregroundColor: Colors.white,
              icon: Icons.schedule,
              label: 'Defer',
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () {
              // Handle action tap
            },
            onLongPress: () {
              // Show context menu
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and priority
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          action["title"] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isAvailable
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: priorityColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Context and project
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          action["context"] as String,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        "• ${action["project"]}",
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Time estimate and due date
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'schedule',
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        action["estimatedTime"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      CustomIconWidget(
                        iconName: 'event',
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        action["dueDate"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      if (!isAvailable)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: colorScheme.outline.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Not available",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
