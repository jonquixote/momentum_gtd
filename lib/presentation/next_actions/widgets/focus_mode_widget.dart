import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FocusModeWidget extends StatefulWidget {
  final Map<String, dynamic> currentAction;
  final VoidCallback onComplete;
  final VoidCallback onNext;
  final VoidCallback onExit;
  final bool isHyperfocusMode;

  const FocusModeWidget({
    super.key,
    required this.currentAction,
    required this.onComplete,
    required this.onNext,
    required this.onExit,
    this.isHyperfocusMode = false,
  });

  @override
  State<FocusModeWidget> createState() => _FocusModeWidgetState();
}

class _FocusModeWidgetState extends State<FocusModeWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _timerController;
  late Animation<double> _pulseAnimation;

  int _remainingMinutes = 0;
  int _remainingSeconds = 0;
  bool _isTimerRunning = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _timerController = AnimationController(
      duration: Duration(minutes: widget.currentAction['timeEstimate'] ?? 25),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _remainingMinutes = widget.currentAction['timeEstimate'] ?? 25;
    _pulseController.repeat(reverse: true);

    if (widget.isHyperfocusMode) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() => _isTimerRunning = true);
    _timerController.forward();

    _timerController.addListener(() {
      final totalSeconds = (widget.currentAction['timeEstimate'] ?? 25) * 60;
      final elapsedSeconds = (_timerController.value * totalSeconds).round();
      final remaining = totalSeconds - elapsedSeconds;

      setState(() {
        _remainingMinutes = remaining ~/ 60;
        _remainingSeconds = remaining % 60;
      });

      if (remaining <= 0) {
        _onTimerComplete();
      }
    });
  }

  void _pauseTimer() {
    setState(() => _isTimerRunning = false);
    _timerController.stop();
  }

  void _resumeTimer() {
    setState(() => _isTimerRunning = true);
    _timerController.forward();
  }

  void _onTimerComplete() {
    HapticFeedback.heavyImpact();
    setState(() => _isTimerRunning = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'celebration',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Time\'s Up!'),
          ],
        ),
        content:
            Text('Great focus session! Ready to mark this action as complete?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onNext();
            },
            child: Text('Take a Break'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onComplete();
            },
            child: Text('Mark Complete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.primary.withValues(alpha: 0.05),
            colorScheme.surface,
          ],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Column(
            children: [
              _buildHeader(theme, colorScheme),
              SizedBox(height: 4.h),
              Expanded(
                child: _buildFocusContent(theme, colorScheme),
              ),
              _buildActionButtons(theme, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        IconButton(
          onPressed: widget.onExit,
          icon: CustomIconWidget(
            iconName: 'close',
            color: colorScheme.onSurface,
            size: 24,
          ),
          tooltip: 'Exit Focus Mode',
        ),
        Expanded(
          child: Text(
            widget.isHyperfocusMode ? 'Hyperfocus Mode' : 'Focus Mode',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        if (widget.isHyperfocusMode)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'ADHD',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                fontWeight: FontWeight.w700,
                fontSize: 10.sp,
              ),
            ),
          )
        else
          SizedBox(width: 12.w),
      ],
    );
  }

  Widget _buildFocusContent(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isHyperfocusMode) ...[
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    border: Border.all(
                      color: colorScheme.primary,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_remainingMinutes.toString().padLeft(2, '0')}:${_remainingSeconds.toString().padLeft(2, '0')}',
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                            fontSize: 24.sp,
                          ),
                        ),
                        Text(
                          'remaining',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 6.h),
        ],
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Current Focus',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                widget.currentAction['title'] as String,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.currentAction['project'] != null) ...[
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'folder_outlined',
                      color: colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      widget.currentAction['project'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 3.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoBadge(
                    theme,
                    'schedule',
                    '${widget.currentAction['timeEstimate']}min',
                    colorScheme.secondary,
                  ),
                  _buildInfoBadge(
                    theme,
                    'battery_charging_full',
                    widget.currentAction['energyLevel'] as String,
                    _getEnergyColor(
                        widget.currentAction['energyLevel'] as String),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (widget.isHyperfocusMode) ...[
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _isTimerRunning ? _pauseTimer : _resumeTimer,
                icon: CustomIconWidget(
                  iconName: _isTimerRunning ? 'pause_circle' : 'play_circle',
                  color: colorScheme.primary,
                  size: 48,
                ),
                tooltip: _isTimerRunning ? 'Pause Timer' : 'Resume Timer',
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInfoBadge(
      ThemeData theme, String icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            color: color,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onNext,
                icon: CustomIconWidget(
                  iconName: 'skip_next',
                  color: colorScheme.primary,
                  size: 20,
                ),
                label: Text('Skip'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: widget.onComplete,
                icon: CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 20,
                ),
                label: Text('Mark Complete'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ),
          ],
        ),
        if (widget.isHyperfocusMode) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'psychology',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Hyperfocus Mode minimizes distractions and provides gentle time awareness.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      fontSize: 11.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
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
}
