import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceInputWidget extends StatefulWidget {
  final Function(String) onTranscriptionComplete;
  final VoidCallback? onRecordingStart;
  final VoidCallback? onRecordingStop;

  const VoiceInputWidget({
    super.key,
    required this.onTranscriptionComplete,
    this.onRecordingStart,
    this.onRecordingStop,
  });

  @override
  State<VoiceInputWidget> createState() => _VoiceInputWidgetState();
}

class _VoiceInputWidgetState extends State<VoiceInputWidget>
    with TickerProviderStateMixin {
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _hasPermission = false;
  String? _recordingPath;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkPermissions();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _checkPermissions() async {
    if (kIsWeb) {
      setState(() => _hasPermission = true);
      return;
    }

    final status = await Permission.microphone.status;
    if (status.isGranted) {
      setState(() => _hasPermission = true);
    } else {
      final result = await Permission.microphone.request();
      setState(() => _hasPermission = result.isGranted);
    }
  }

  Future<void> _startRecording() async {
    if (!_hasPermission) {
      await _checkPermissions();
      if (!_hasPermission) return;
    }

    try {
      if (kIsWeb) {
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: 'recording_${DateTime.now().millisecondsSinceEpoch}.wav',
        );
      } else {
        final dir = await getTemporaryDirectory();
        _recordingPath =
            '${dir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: _recordingPath!,
        );
      }

      setState(() => _isRecording = true);
      _pulseController.repeat(reverse: true);
      widget.onRecordingStart?.call();
    } catch (e) {
      _showErrorMessage('Failed to start recording');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      setState(() => _isRecording = false);
      _pulseController.stop();
      _pulseController.reset();
      widget.onRecordingStop?.call();

      if (path != null) {
        // Simulate transcription for demo purposes
        // In a real app, you would send the audio to a speech-to-text service
        await Future.delayed(const Duration(milliseconds: 500));
        final mockTranscription = _generateMockTranscription();
        widget.onTranscriptionComplete(mockTranscription);
      }
    } catch (e) {
      setState(() => _isRecording = false);
      _pulseController.stop();
      _pulseController.reset();
      _showErrorMessage('Failed to stop recording');
    }
  }

  String _generateMockTranscription() {
    final transcriptions = [
      'Call John about the project meeting tomorrow',
      'Buy groceries: milk, bread, and eggs',
      'Review the quarterly report before Friday',
      'Schedule dentist appointment for next week',
      'Research new marketing strategies for Q4',
      'Follow up with client about contract renewal',
      'Prepare presentation for board meeting',
      'Update website content and fix broken links',
    ];
    return transcriptions[DateTime.now().millisecond % transcriptions.length];
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _isRecording
            ? AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1)
            : colorScheme.primary.withValues(alpha: 0.1),
        border: Border.all(
          color: _isRecording
              ? AppTheme.lightTheme.colorScheme.error
              : colorScheme.primary,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6.w),
          onTap: _hasPermission
              ? (_isRecording ? _stopRecording : _startRecording)
              : _checkPermissions,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isRecording ? _pulseAnimation.value : 1.0,
                child: Center(
                  child: CustomIconWidget(
                    iconName: _isRecording ? 'stop' : 'mic',
                    color: _isRecording
                        ? AppTheme.lightTheme.colorScheme.error
                        : colorScheme.primary,
                    size: 6.w,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
