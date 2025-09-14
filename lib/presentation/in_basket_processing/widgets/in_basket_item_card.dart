import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class InBasketItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onActionable;
  final VoidCallback? onReference;
  final VoidCallback? onSomedayMaybe;
  final VoidCallback? onTrash;
  final VoidCallback? onDelegate;

  const InBasketItemCard({
    super.key,
    required this.item,
    this.onActionable,
    this.onReference,
    this.onSomedayMaybe,
    this.onTrash,
    this.onDelegate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 90.w,
      constraints: BoxConstraints(
        minHeight: 25.h,
        maxHeight: 35.h,
      ),
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Source indicator
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: _getSourceColor(item['source'] as String? ?? 'unknown')
                  .withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName:
                      _getSourceIcon(item['source'] as String? ?? 'unknown'),
                  color:
                      _getSourceColor(item['source'] as String? ?? 'unknown'),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  _getSourceLabel(item['source'] as String? ?? 'unknown'),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color:
                        _getSourceColor(item['source'] as String? ?? 'unknown'),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatTimestamp(
                      item['timestamp'] as DateTime? ?? DateTime.now()),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  if (item['title'] != null) ...[
                    Text(
                      item['title'] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 1.h),
                  ],

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        item['content'] as String? ?? 'No content available',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          height: 1.4,
                        ),
                        maxLines: 8,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  // Attachment indicator
                  if (item['hasAttachment'] == true) ...[
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'attach_file',
                          color: colorScheme.primary,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Has attachment',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSourceColor(String source) {
    switch (source.toLowerCase()) {
      case 'email':
        return const Color(0xFF3498DB);
      case 'voice':
        return const Color(0xFF27AE60);
      case 'photo':
        return const Color(0xFFF39C12);
      case 'text':
        return const Color(0xFF9B59B6);
      case 'web':
        return const Color(0xFFE74C3C);
      default:
        return const Color(0xFF7F8C8D);
    }
  }

  String _getSourceIcon(String source) {
    switch (source.toLowerCase()) {
      case 'email':
        return 'email';
      case 'voice':
        return 'mic';
      case 'photo':
        return 'photo_camera';
      case 'text':
        return 'text_fields';
      case 'web':
        return 'web';
      default:
        return 'inbox';
    }
  }

  String _getSourceLabel(String source) {
    switch (source.toLowerCase()) {
      case 'email':
        return 'Email';
      case 'voice':
        return 'Voice Note';
      case 'photo':
        return 'Photo';
      case 'text':
        return 'Quick Note';
      case 'web':
        return 'Web Clip';
      default:
        return 'Inbox';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
