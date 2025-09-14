import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProgressIndicatorWidget extends StatefulWidget {
  final int currentIndex;
  final int totalItems;
  final String? currentItemTitle;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final bool canGoBack;
  final bool canGoForward;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentIndex,
    required this.totalItems,
    this.currentItemTitle,
    this.onPrevious,
    this.onNext,
    this.canGoBack = true,
    this.canGoForward = true,
  });

  @override
  State<ProgressIndicatorWidget> createState() =>
      _ProgressIndicatorWidgetState();
}

class _ProgressIndicatorWidgetState extends State<ProgressIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.totalItems > 0
          ? (widget.currentIndex + 1) / widget.totalItems
          : 0.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    ));
    _progressController.forward();
  }

  @override
  void didUpdateWidget(ProgressIndicatorWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex ||
        oldWidget.totalItems != widget.totalItems) {
      _progressAnimation = Tween<double>(
        begin: _progressAnimation.value,
        end: widget.totalItems > 0
            ? (widget.currentIndex + 1) / widget.totalItems
            : 0.0,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ));
      _progressController.reset();
      _progressController.forward();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = widget.totalItems > 0
        ? (widget.currentIndex + 1) / widget.totalItems
        : 0.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header with navigation
            Row(
              children: [
                // Back button
                IconButton(
                  onPressed: widget.canGoBack && widget.currentIndex > 0
                      ? widget.onPrevious
                      : null,
                  icon: CustomIconWidget(
                    iconName: 'arrow_back_ios',
                    color: widget.canGoBack && widget.currentIndex > 0
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  tooltip: 'Previous item',
                ),

                // Progress info
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Processing In-Basket',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${widget.currentIndex + 1} of ${widget.totalItems} items',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Forward button
                IconButton(
                  onPressed: widget.canGoForward &&
                          widget.currentIndex < widget.totalItems - 1
                      ? widget.onNext
                      : null,
                  icon: CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: widget.canGoForward &&
                            widget.currentIndex < widget.totalItems - 1
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 20,
                  ),
                  tooltip: 'Next item',
                ),
              ],
            ),

            SizedBox(height: 1.5.h),

            // Progress bar
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _progressAnimation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary,
                            colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 1.h),

            // Current item title
            if (widget.currentItemTitle != null) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'article',
                      color: colorScheme.onSurfaceVariant,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        widget.currentItemTitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Progress statistics
            if (widget.totalItems > 0) ...[
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(
                    context,
                    'Remaining',
                    '${widget.totalItems - widget.currentIndex - 1}',
                    AppTheme.warningLight,
                    'pending_actions',
                  ),
                  _buildStatItem(
                    context,
                    'Processed',
                    '${widget.currentIndex + 1}',
                    AppTheme.successLight,
                    'check_circle',
                  ),
                  _buildStatItem(
                    context,
                    'Progress',
                    '${(progress * 100).round()}%',
                    colorScheme.primary,
                    'trending_up',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    Color color,
    String icon,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(1.5.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 16,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
