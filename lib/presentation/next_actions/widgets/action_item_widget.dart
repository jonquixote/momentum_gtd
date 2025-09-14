import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionItemWidget extends StatefulWidget {
  final Map<String, dynamic> action;
  final VoidCallback onComplete;
  final VoidCallback onEdit;
  final VoidCallback onDefer;
  final VoidCallback onDelegate;
  final VoidCallback onConvertToProject;
  final bool isSelected;
  final VoidCallback? onTap;

  const ActionItemWidget({
    super.key,
    required this.action,
    required this.onComplete,
    required this.onEdit,
    required this.onDefer,
    required this.onDelegate,
    required this.onConvertToProject,
    this.isSelected = false,
    this.onTap,
  });

  @override
  State<ActionItemWidget> createState() => _ActionItemWidgetState();
}

class _ActionItemWidgetState extends State<ActionItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleComplete() async {
    setState(() => _isCompleting = true);
    HapticFeedback.mediumImpact();

    await _animationController.forward();
    widget.onComplete();

    if (mounted) {
      setState(() => _isCompleting = false);
      _animationController.reset();
    }
  }

  Color _getEnergyColor(String energy) {
    switch (energy.toLowerCase()) {
      case 'high':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'medium':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'low':
        return AppTheme.lightTheme.colorScheme.primary;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isCompleting ? _scaleAnimation.value : 1.0,
          child: Opacity(
            opacity: _isCompleting ? _scaleAnimation.value : 1.0,
            child: _buildActionItem(theme, colorScheme),
          ),
        );
      },
    );
  }

  Widget _buildActionItem(ThemeData theme, ColorScheme colorScheme) {
    return Dismissible(
      key: Key(widget.action['id'].toString()),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          _handleComplete();
          return false;
        } else {
          _showActionMenu();
          return false;
        }
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Complete',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 6.w),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'more_horiz',
              color: Colors.white,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              'Options',
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: widget.onTap,
        onLongPress: () {
          HapticFeedback.mediumImpact();
          widget.onTap?.call();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? colorScheme.primary.withValues(alpha: 0.1)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: widget.isSelected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.2),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.action['title'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.action['priority'] == 'high') ...[
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'priority_high',
                      color: AppTheme.lightTheme.colorScheme.error,
                      size: 20,
                    ),
                  ],
                ],
              ),
              if (widget.action['project'] != null) ...[
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'folder_outlined',
                      color: colorScheme.primary,
                      size: 14,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      widget.action['project'] as String,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 2.h),
              Row(
                children: [
                  _buildInfoChip(
                    context,
                    'schedule',
                    '${widget.action['timeEstimate']}min',
                    colorScheme.secondary,
                  ),
                  SizedBox(width: 2.w),
                  _buildInfoChip(
                    context,
                    'battery_charging_full',
                    widget.action['energyLevel'] as String,
                    _getEnergyColor(widget.action['energyLevel'] as String),
                  ),
                  if (widget.action['dueDate'] != null) ...[
                    SizedBox(width: 2.w),
                    _buildInfoChip(
                      context,
                      'event',
                      _formatDueDate(widget.action['dueDate'] as DateTime),
                      _getDueDateColor(widget.action['dueDate'] as DateTime),
                    ),
                  ],
                  const Spacer(),
                  if (widget.isSelected)
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(
      BuildContext context, String icon, String label, Color color) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference == -1) return 'Yesterday';
    if (difference < 0) return '${difference.abs()}d ago';
    return '${difference}d';
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) return AppTheme.lightTheme.colorScheme.error;
    if (difference == 0) return AppTheme.lightTheme.colorScheme.error;
    if (difference <= 2) return AppTheme.lightTheme.colorScheme.secondary;
    return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
  }

  void _showActionMenu() {
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
            _buildMenuOption('edit', 'Edit Action', widget.onEdit),
            _buildMenuOption('schedule', 'Defer', widget.onDefer),
            _buildMenuOption('person_add', 'Delegate', widget.onDelegate),
            _buildMenuOption(
                'folder_copy', 'Convert to Project', widget.onConvertToProject),
            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(String icon, String label, VoidCallback onTap) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        label,
        style: theme.textTheme.titleMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
