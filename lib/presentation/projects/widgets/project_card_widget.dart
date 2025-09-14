import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectCardWidget extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onConvertToSomeday;

  const ProjectCardWidget({
    super.key,
    required this.project,
    this.onTap,
    this.onComplete,
    this.onEdit,
    this.onArchive,
    this.onConvertToSomeday,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String status = project['status'] as String? ?? 'active';
    final double progress = (project['progress'] as num?)?.toDouble() ?? 0.0;
    final String title = project['title'] as String? ?? 'Untitled Project';
    final String nextAction =
        project['nextAction'] as String? ?? 'No next action';
    final DateTime lastActivity = project['lastActivity'] != null
        ? DateTime.parse(project['lastActivity'] as String)
        : DateTime.now();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(project['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onComplete?.call(),
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: Colors.white,
              icon: Icons.check_circle,
              label: 'Complete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _showContextMenu(context),
              backgroundColor: colorScheme.surfaceContainerHighest,
              foregroundColor: colorScheme.onSurface,
              icon: Icons.more_horiz,
              label: 'More',
              borderRadius: BorderRadius.circular(12),
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
            onTap: onTap,
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
                        child: Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      _buildStatusBadge(status, colorScheme),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Progress indicator
                  _buildProgressIndicator(progress, colorScheme),

                  SizedBox(height: 2.h),

                  // Next action preview
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        size: 16,
                        color: colorScheme.primary,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          nextAction,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.h),

                  // Last activity timestamp
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'access_time',
                        size: 14,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        _formatLastActivity(lastActivity),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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

  Widget _buildStatusBadge(String status, ColorScheme colorScheme) {
    Color badgeColor;
    String badgeText;

    switch (status.toLowerCase()) {
      case 'active':
        badgeColor = AppTheme.lightTheme.colorScheme.tertiary;
        badgeText = 'Active';
        break;
      case 'on-hold':
        badgeColor = AppTheme.warningLight;
        badgeText = 'On Hold';
        break;
      case 'completed':
        badgeColor = AppTheme.lightTheme.colorScheme.tertiary;
        badgeText = 'Completed';
        break;
      case 'someday':
        badgeColor = colorScheme.surfaceContainerHighest;
        badgeText = 'Someday';
        break;
      default:
        badgeColor = colorScheme.surfaceContainerHighest;
        badgeText = 'Unknown';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        badgeText,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
          color: badgeColor,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(double progress, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              colorScheme.primary,
            ),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  String _formatLastActivity(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                size: 24,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: const Text('Edit Project'),
              onTap: () {
                Navigator.pop(context);
                onEdit?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'archive',
                size: 24,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                onArchive?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'schedule',
                size: 24,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: const Text('Convert to Someday'),
              onTap: () {
                Navigator.pop(context);
                onConvertToSomeday?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
