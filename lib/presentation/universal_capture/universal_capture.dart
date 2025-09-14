import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/batch_capture_widget.dart';
import './widgets/camera_capture_widget.dart';
import './widgets/quick_tags_widget.dart';
import './widgets/smart_suggestions_widget.dart';
import './widgets/two_minute_rule_widget.dart';
import './widgets/voice_input_widget.dart';

class UniversalCapture extends StatefulWidget {
  const UniversalCapture({super.key});

  @override
  State<UniversalCapture> createState() => _UniversalCaptureState();
}

class _UniversalCaptureState extends State<UniversalCapture>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  List<String> _selectedTags = [];
  List<String> _customTags = [];
  XFile? _capturedImage;
  bool _includeLocation = false;
  bool _isBatchMode = false;
  bool _showTwoMinuteRule = false;
  List<Map<String, dynamic>> _batchItems = [];

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _setupTextListener();

    // Auto-focus text input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _textFocusNode.requestFocus();
    });
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideController.forward();
    _fadeController.forward();
  }

  void _setupTextListener() {
    _textController.addListener(() {
      final text = _textController.text.trim();
      final shouldShowRule =
          text.isNotEmpty && text.length > 10 && !_isBatchMode;

      if (shouldShowRule != _showTwoMinuteRule) {
        setState(() => _showTwoMinuteRule = shouldShowRule);
      }
    });
  }

  void _handleCapture() {
    final text = _textController.text.trim();
    if (text.isEmpty && _capturedImage == null) {
      _showMessage('Please enter some text or capture an image');
      return;
    }

    final captureItem = {
      'text': text,
      'tags': List<String>.from(_selectedTags),
      'image': _capturedImage?.path,
      'location': _includeLocation ? 'Current Location' : null,
      'timestamp': DateTime.now(),
    };

    if (_isBatchMode) {
      setState(() {
        _batchItems.add(captureItem);
        _clearCurrentInput();
      });
      _showMessage('Item added to batch (${_batchItems.length} items)');
    } else {
      _processSingleItem(captureItem);
    }
  }

  void _processSingleItem(Map<String, dynamic> item) {
    // Simulate processing
    HapticFeedback.lightImpact();
    _showMessage('Item captured successfully!');

    // Navigate back or clear input
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      _clearCurrentInput();
    }
  }

  void _clearCurrentInput() {
    _textController.clear();
    setState(() {
      _selectedTags.clear();
      _capturedImage = null;
      _includeLocation = false;
      _showTwoMinuteRule = false;
    });
  }

  void _handleCancel() {
    if (_textController.text.isNotEmpty ||
        _capturedImage != null ||
        _batchItems.isNotEmpty) {
      _showUnsavedChangesDialog();
    } else {
      _navigateBack();
    }
  }

  void _navigateBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
            'You have unsaved content. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateBack();
            },
            child: Text(
              'Leave',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleVoiceTranscription(String transcription) {
    setState(() {
      _textController.text = transcription;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: transcription.length),
      );
    });
  }

  void _handleImageCapture(XFile image) {
    setState(() => _capturedImage = image);
    _showMessage('Image captured successfully');
  }

  void _handleTagsChanged(List<String> tags) {
    setState(() => _selectedTags = tags);
  }

  void _handleCustomTagAdded(String tag) {
    if (!_customTags.contains(tag)) {
      setState(() => _customTags.add(tag));
    }
  }

  void _handleSuggestionSelected(String suggestion) {
    final currentText = _textController.text;
    final newText =
        currentText.isEmpty ? suggestion : '$currentText\n$suggestion';
    setState(() {
      _textController.text = newText;
      _textController.selection = TextSelection.fromPosition(
        TextPosition(offset: newText.length),
      );
    });
  }

  void _handleProjectAssociation(String text, String project) {
    _showMessage('Associated with project: $project');
    // In a real app, this would save the association
  }

  void _handleDoNow() {
    _showMessage('Great! Mark as completed when done.');
    _navigateBack();
  }

  void _handleCaptureLater() {
    setState(() => _showTwoMinuteRule = false);
  }

  void _handleBatchItemAdded(Map<String, dynamic> item) {
    setState(() => _batchItems.add(item));
  }

  void _handleBatchItemRemoved(int index) {
    setState(() => _batchItems.removeAt(index));
  }

  void _handleBatchItemUpdated(int index, Map<String, dynamic> item) {
    setState(() => _batchItems[index] = item);
  }

  void _handleProcessAllBatch() {
    if (_batchItems.isEmpty) return;

    // Simulate batch processing
    HapticFeedback.mediumImpact();
    _showMessage('Processing ${_batchItems.length} items...');

    // Clear batch and navigate
    setState(() {
      _batchItems.clear();
      _isBatchMode = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      _showMessage('All items processed successfully!');
      _navigateBack();
    });
  }

  void _handleClearAllBatch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Items'),
        content: Text(
            'Are you sure you want to clear all ${_batchItems.length} items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _batchItems.clear());
              _showMessage('All items cleared');
            },
            child: Text(
              'Clear All',
              style: TextStyle(color: AppTheme.lightTheme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _handleToggleBatchMode() {
    setState(() => _isBatchMode = !_isBatchMode);
    if (_isBatchMode) {
      _showMessage('Batch mode enabled - capture multiple items');
    } else {
      _showMessage('Batch mode disabled');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _textFocusNode.dispose();
    _scrollController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Universal Capture',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: _handleCancel,
          icon: CustomIconWidget(
            iconName: 'close',
            color: colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _handleCapture,
            child: Text(
              _isBatchMode ? 'Add' : 'Capture',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main input area
                        _buildMainInputArea(colorScheme),

                        SizedBox(height: 3.h),

                        // Input controls
                        _buildInputControls(),

                        SizedBox(height: 3.h),

                        // Captured image preview
                        if (_capturedImage != null)
                          _buildImagePreview(colorScheme),

                        // Location toggle
                        _buildLocationToggle(colorScheme),

                        SizedBox(height: 3.h),

                        // Quick tags
                        QuickTagsWidget(
                          selectedTags: _selectedTags,
                          onTagsChanged: _handleTagsChanged,
                          onCustomTagAdded: _handleCustomTagAdded,
                        ),

                        SizedBox(height: 3.h),

                        // Smart suggestions
                        SmartSuggestionsWidget(
                          inputText: _textController.text,
                          onSuggestionSelected: _handleSuggestionSelected,
                          onProjectAssociation: _handleProjectAssociation,
                        ),

                        SizedBox(height: 2.h),

                        // Two-minute rule
                        TwoMinuteRuleWidget(
                          inputText: _textController.text,
                          onDoNow: _handleDoNow,
                          onCaptureLater: _handleCaptureLater,
                          isVisible: _showTwoMinuteRule,
                        ),

                        SizedBox(height: 3.h),

                        // Batch capture
                        BatchCaptureWidget(
                          capturedItems: _batchItems,
                          onItemAdded: _handleBatchItemAdded,
                          onItemRemoved: _handleBatchItemRemoved,
                          onItemUpdated: _handleBatchItemUpdated,
                          onProcessAll: _handleProcessAllBatch,
                          onClearAll: _handleClearAllBatch,
                          isBatchMode: _isBatchMode,
                          onToggleBatchMode: _handleToggleBatchMode,
                        ),

                        SizedBox(height: 10.h), // Extra space for keyboard
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainInputArea(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _textFocusNode.hasFocus
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.3),
          width: _textFocusNode.hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _textController,
        focusNode: _textFocusNode,
        maxLines: null,
        minLines: 4,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'What\'s on your mind? Capture anything...',
          hintStyle: TextStyle(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            fontSize: 16.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(4.w),
        ),
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  Widget _buildInputControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Voice input
        VoiceInputWidget(
          onTranscriptionComplete: _handleVoiceTranscription,
          onRecordingStart: () => _showMessage('Recording started...'),
          onRecordingStop: () => _showMessage('Processing audio...'),
        ),

        // Camera capture
        CameraCaptureWidget(
          onImageCaptured: _handleImageCapture,
          onCameraOpen: () => _showMessage('Camera opened'),
          onCameraClose: () => _showMessage('Camera closed'),
        ),

        // File attachment (placeholder)
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
            border: Border.all(
              color: Theme.of(context).colorScheme.tertiary,
              width: 2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(6.w),
              onTap: () => _showMessage('File attachment coming soon'),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'attach_file',
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 6.w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePreview(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 20.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomImageWidget(
                imageUrl: _capturedImage!.path,
                width: double.infinity,
                height: 20.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 1.h,
            right: 1.h,
            child: GestureDetector(
              onTap: () => setState(() => _capturedImage = null),
              child: Container(
                padding: EdgeInsets.all(1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'close',
                  color: Colors.white,
                  size: 4.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationToggle(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Switch(
            value: _includeLocation,
            onChanged: (value) => setState(() => _includeLocation = value),
            activeColor: colorScheme.primary,
          ),
          SizedBox(width: 2.w),
          CustomIconWidget(
            iconName: 'location_on',
            color: _includeLocation
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
            size: 5.w,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              'Include current location',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _includeLocation
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
