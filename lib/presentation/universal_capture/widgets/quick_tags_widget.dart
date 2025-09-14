import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickTagsWidget extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;
  final Function(String) onCustomTagAdded;

  const QuickTagsWidget({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
    required this.onCustomTagAdded,
  });

  @override
  State<QuickTagsWidget> createState() => _QuickTagsWidgetState();
}

class _QuickTagsWidgetState extends State<QuickTagsWidget> {
  final TextEditingController _customTagController = TextEditingController();
  bool _showCustomTagInput = false;

  final List<String> _predefinedTags = [
    'urgent',
    'waiting-for',
    'someday',
    'project',
    'personal',
    'work',
    'call',
    'email',
    'meeting',
    'review',
    'research',
    'buy',
  ];

  void _toggleTag(String tag) {
    final updatedTags = List<String>.from(widget.selectedTags);
    if (updatedTags.contains(tag)) {
      updatedTags.remove(tag);
    } else {
      updatedTags.add(tag);
    }
    widget.onTagsChanged(updatedTags);
  }

  void _addCustomTag() {
    final customTag = _customTagController.text.trim().toLowerCase();
    if (customTag.isNotEmpty && !widget.selectedTags.contains(customTag)) {
      widget.onCustomTagAdded(customTag);
      final updatedTags = List<String>.from(widget.selectedTags);
      updatedTags.add(customTag);
      widget.onTagsChanged(updatedTags);
      _customTagController.clear();
      setState(() => _showCustomTagInput = false);
    }
  }

  void _cancelCustomTag() {
    _customTagController.clear();
    setState(() => _showCustomTagInput = false);
  }

  @override
  void dispose() {
    _customTagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Tags',
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),

        // Tags Wrap
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            // Predefined tags
            ..._predefinedTags.map((tag) => _buildTagChip(tag, colorScheme)),

            // Custom tag input or add button
            _showCustomTagInput
                ? _buildCustomTagInput(colorScheme)
                : _buildAddTagButton(colorScheme),
          ],
        ),

        // Selected tags display
        if (widget.selectedTags.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Text(
            'Selected: ${widget.selectedTags.map((tag) => '#$tag').join(', ')}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTagChip(String tag, ColorScheme colorScheme) {
    final isSelected = widget.selectedTags.contains(tag);

    return GestureDetector(
      onTap: () => _toggleTag(tag),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '#$tag',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : colorScheme.onSurface,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 3.w,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAddTagButton(ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () => setState(() => _showCustomTagInput = true),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          border: Border.all(
            color: colorScheme.secondary,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'add',
              color: colorScheme.secondary,
              size: 4.w,
            ),
            SizedBox(width: 1.w),
            Text(
              'Add Tag',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTagInput(ColorScheme colorScheme) {
    return Container(
      width: 40.w,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _customTagController,
              autofocus: true,
              style: TextStyle(fontSize: 12.sp),
              decoration: InputDecoration(
                hintText: 'Custom tag',
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: colorScheme.primary, width: 2),
                ),
                isDense: true,
              ),
              onSubmitted: (_) => _addCustomTag(),
            ),
          ),
          SizedBox(width: 1.w),
          GestureDetector(
            onTap: _addCustomTag,
            child: Container(
              padding: EdgeInsets.all(1.h),
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 3.w,
              ),
            ),
          ),
          SizedBox(width: 1.w),
          GestureDetector(
            onTap: _cancelCustomTag,
            child: Container(
              padding: EdgeInsets.all(1.h),
              decoration: BoxDecoration(
                color: colorScheme.outline,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: Colors.white,
                size: 3.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
