import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TwoMinuteRuleWidget extends StatefulWidget {
  final String inputText;
  final VoidCallback onDoNow;
  final VoidCallback onCaptureLater;
  final bool isVisible;

  const TwoMinuteRuleWidget({
    super.key,
    required this.inputText,
    required this.onDoNow,
    required this.onCaptureLater,
    required this.isVisible,
  });

  @override
  State<TwoMinuteRuleWidget> createState() => _TwoMinuteRuleWidgetState();
}

class _TwoMinuteRuleWidgetState extends State<TwoMinuteRuleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(TwoMinuteRuleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  bool _isSimpleTask(String text) {
    final simpleTaskPatterns = [
      r'\bcall\s+\w+',
      r'\bemail\s+\w+',
      r'\btext\s+\w+',
      r'\bbuy\s+\w+',
      r'\bcheck\s+\w+',
      r'\bsend\s+\w+',
      r'\breply\s+to',
      r'\bconfirm\s+\w+',
      r'\bschedule\s+\w+',
      r'\bbook\s+\w+',
    ];

    final lowerText = text.toLowerCase();
    return simpleTaskPatterns.any(
        (pattern) => RegExp(pattern, caseSensitive: false).hasMatch(lowerText));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible || !_isSimpleTask(widget.inputText)) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 50),
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 1.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.1),
                    AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(1.5.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: CustomIconWidget(
                          iconName: 'timer',
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                          size: 4.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2-Minute Rule',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.tertiary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'This looks like a quick task!',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Description
                  Text(
                    'If this task takes less than 2 minutes, consider doing it now instead of capturing it.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: widget.onDoNow,
                          icon: CustomIconWidget(
                            iconName: 'play_arrow',
                            color: Colors.white,
                            size: 4.w,
                          ),
                          label: Text(
                            'Do Now',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.tertiary,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: widget.onCaptureLater,
                          icon: CustomIconWidget(
                            iconName: 'bookmark_add',
                            color: colorScheme.primary,
                            size: 4.w,
                          ),
                          label: Text(
                            'Capture',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.primary,
                            side: BorderSide(color: colorScheme.primary),
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
