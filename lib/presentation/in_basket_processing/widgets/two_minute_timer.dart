import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TwoMinuteTimer extends StatefulWidget {
  final VoidCallback? onComplete;
  final VoidCallback? onDoItNow;
  final bool isVisible;

  const TwoMinuteTimer({
    super.key,
    this.onComplete,
    this.onDoItNow,
    this.isVisible = true,
  });

  @override
  State<TwoMinuteTimer> createState() => _TwoMinuteTimerState();
}

class _TwoMinuteTimerState extends State<TwoMinuteTimer>
    with TickerProviderStateMixin {
  Timer? _timer;
  int _secondsRemaining = 120; // 2 minutes
  bool _isRunning = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _secondsRemaining = 120;
    });

    _pulseController.stop();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _stopTimer();
          widget.onComplete?.call();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = 120;
    });

    if (widget.isVisible) {
      _pulseController.repeat(reverse: true);
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsRemaining = 120;
    });

    if (widget.isVisible) {
      _pulseController.repeat(reverse: true);
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = (_secondsRemaining / 120.0);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.warningLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.warningLight.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Two-minute rule header
          Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _isRunning ? 1.0 : _pulseAnimation.value,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.warningLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CustomIconWidget(
                        iconName: 'timer',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Two-Minute Rule',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.warningLight,
                      ),
                    ),
                    Text(
                      'Can this be done in 2 minutes or less?',
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

          // Timer display
          if (_isRunning) ...[
            // Circular progress indicator
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 4,
                      backgroundColor:
                          colorScheme.outline.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress > 0.5
                            ? AppTheme.successLight
                            : progress > 0.25
                                ? AppTheme.warningLight
                                : AppTheme.errorLight,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(_secondsRemaining),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'remaining',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),

            // Timer controls
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: _stopTimer,
                  icon: CustomIconWidget(
                    iconName: 'stop',
                    color: AppTheme.errorLight,
                    size: 16,
                  ),
                  label: Text(
                    'Stop',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.errorLight,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _resetTimer,
                  icon: CustomIconWidget(
                    iconName: 'refresh',
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  label: Text(
                    'Reset',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Start timer button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _startTimer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.warningLight,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: CustomIconWidget(
                  iconName: 'play_arrow',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Start 2-Minute Timer',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],

          SizedBox(height: 1.h),

          // Do it now button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.onDoItNow,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.successLight,
                side: BorderSide(color: AppTheme.successLight),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successLight,
                size: 20,
              ),
              label: Text(
                'Do It Now',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.successLight,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
