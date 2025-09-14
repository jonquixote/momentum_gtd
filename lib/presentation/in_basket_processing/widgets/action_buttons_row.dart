import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback? onActionable;
  final VoidCallback? onReference;
  final VoidCallback? onSomedayMaybe;
  final VoidCallback? onTrash;
  final VoidCallback? onDelegate;
  final bool isEnabled;

  const ActionButtonsRow({
    super.key,
    this.onActionable,
    this.onReference,
    this.onSomedayMaybe,
    this.onTrash,
    this.onDelegate,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary actions (thumb zone)
            Row(
              children: [
                // Actionable button (primary)
                Expanded(
                  flex: 2,
                  child: _buildPrimaryButton(
                    context: context,
                    label: 'It\'s Actionable',
                    icon: 'task_alt',
                    color: AppTheme.successLight,
                    onPressed: isEnabled
                        ? () {
                            HapticFeedback.mediumImpact();
                            onActionable?.call();
                          }
                        : null,
                  ),
                ),

                SizedBox(width: 2.w),

                // Reference button
                Expanded(
                  child: _buildSecondaryButton(
                    context: context,
                    label: 'Reference',
                    icon: 'bookmark',
                    color: colorScheme.primary,
                    onPressed: isEnabled
                        ? () {
                            HapticFeedback.lightImpact();
                            onReference?.call();
                          }
                        : null,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Secondary actions
            Row(
              children: [
                // Someday/Maybe button
                Expanded(
                  child: _buildSecondaryButton(
                    context: context,
                    label: 'Someday/Maybe',
                    icon: 'schedule',
                    color: AppTheme.warningLight,
                    onPressed: isEnabled
                        ? () {
                            HapticFeedback.lightImpact();
                            onSomedayMaybe?.call();
                          }
                        : null,
                  ),
                ),

                SizedBox(width: 2.w),

                // Delegate button
                Expanded(
                  child: _buildSecondaryButton(
                    context: context,
                    label: 'Delegate',
                    icon: 'person_add',
                    color: colorScheme.secondary,
                    onPressed: isEnabled
                        ? () {
                            HapticFeedback.lightImpact();
                            onDelegate?.call();
                          }
                        : null,
                  ),
                ),

                SizedBox(width: 2.w),

                // Trash button
                Expanded(
                  child: _buildSecondaryButton(
                    context: context,
                    label: 'Trash',
                    icon: 'delete',
                    color: AppTheme.errorLight,
                    onPressed: isEnabled
                        ? () {
                            HapticFeedback.lightImpact();
                            onTrash?.call();
                          }
                        : null,
                  ),
                ),
              ],
            ),

            SizedBox(height: 1.h),

            // Swipe hint
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color:
                    colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'swipe',
                    color: colorScheme.onSurfaceVariant,
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    'Swipe right for actionable, left for reference',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required BuildContext context,
    required String label,
    required String icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 6.h,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: color.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 3.w),
        ),
        icon: CustomIconWidget(
          iconName: icon,
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required BuildContext context,
    required String label,
    required String icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 5.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color, width: 1.5),
          backgroundColor: color.withValues(alpha: 0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 2.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 18,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
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
  }
}
