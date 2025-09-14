import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BatchCaptureWidget extends StatefulWidget {
  final List<Map<String, dynamic>> capturedItems;
  final Function(Map<String, dynamic>) onItemAdded;
  final Function(int) onItemRemoved;
  final Function(int, Map<String, dynamic>) onItemUpdated;
  final VoidCallback onProcessAll;
  final VoidCallback onClearAll;
  final bool isBatchMode;
  final VoidCallback onToggleBatchMode;

  const BatchCaptureWidget({
    super.key,
    required this.capturedItems,
    required this.onItemAdded,
    required this.onItemRemoved,
    required this.onItemUpdated,
    required this.onProcessAll,
    required this.onClearAll,
    required this.isBatchMode,
    required this.onToggleBatchMode,
  });

  @override
  State<BatchCaptureWidget> createState() => _BatchCaptureWidgetState();
}

class _BatchCaptureWidgetState extends State<BatchCaptureWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

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

    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    if (widget.isBatchMode) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(BatchCaptureWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isBatchMode != oldWidget.isBatchMode) {
      if (widget.isBatchMode) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        // Batch mode toggle
        _buildBatchModeToggle(colorScheme),

        // Batch items list
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return SizeTransition(
              sizeFactor: _expandAnimation,
              child: child,
            );
          },
          child: widget.isBatchMode ? _buildBatchItemsList(colorScheme) : null,
        ),
      ],
    );
  }

  Widget _buildBatchModeToggle(ColorScheme colorScheme) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Switch(
            value: widget.isBatchMode,
            onChanged: (_) => widget.onToggleBatchMode(),
            activeColor: colorScheme.secondary,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Batch Capture Mode',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  'Capture multiple items before processing',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          if (widget.capturedItems.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${widget.capturedItems.length}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBatchItemsList(ColorScheme colorScheme) {
    if (widget.capturedItems.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: 'inbox',
              color: colorScheme.onSurfaceVariant,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              'No items captured yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            Text(
              'Items will appear here as you capture them',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'inventory_2',
                  color: colorScheme.secondary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Captured Items (${widget.capturedItems.length})',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.secondary,
                        ),
                  ),
                ),
                TextButton(
                  onPressed: widget.capturedItems.isNotEmpty
                      ? widget.onClearAll
                      : null,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.lightTheme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Items list
          Container(
            constraints: BoxConstraints(maxHeight: 30.h),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.capturedItems.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
              itemBuilder: (context, index) {
                final item = widget.capturedItems[index];
                return _buildBatchItem(item, index, colorScheme);
              },
            ),
          ),

          // Action buttons
          if (widget.capturedItems.isNotEmpty)
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.onProcessAll,
                      icon: CustomIconWidget(
                        iconName: 'send',
                        color: Colors.white,
                        size: 4.w,
                      ),
                      label: Text(
                        'Process All (${widget.capturedItems.length})',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBatchItem(
      Map<String, dynamic> item, int index, ColorScheme colorScheme) {
    final text = item['text'] as String? ?? '';
    final tags = (item['tags'] as List<String>?) ?? [];
    final timestamp = item['timestamp'] as DateTime? ?? DateTime.now();

    return Dismissible(
      key: Key('batch_item_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        color: AppTheme.lightTheme.colorScheme.error,
        child: CustomIconWidget(
          iconName: 'delete',
          color: Colors.white,
          size: 6.w,
        ),
      ),
      onDismissed: (_) => widget.onItemRemoved(index),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        leading: Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
        title: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tags.isNotEmpty) ...[
              SizedBox(height: 0.5.h),
              Wrap(
                spacing: 1.w,
                children: tags
                    .map((tag) => Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
            SizedBox(height: 0.5.h),
            Text(
              _formatTimestamp(timestamp),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => widget.onItemRemoved(index),
          icon: CustomIconWidget(
            iconName: 'close',
            color: colorScheme.onSurfaceVariant,
            size: 4.w,
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
