import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AiSuggestionCard extends StatelessWidget {
  final Map<String, dynamic> suggestion;
  final VoidCallback? onTap;
  final bool isExpanded;

  const AiSuggestionCard({
    super.key,
    required this.suggestion,
    this.onTap,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with AI badge and confidence
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'auto_awesome',
                          color: Colors.white,
                          size: 12,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'AI',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  _buildConfidenceIndicator(
                    suggestion['confidence'] as double? ?? 0.8,
                    colorScheme,
                    theme,
                  ),
                ],
              ),

              SizedBox(height: 1.5.h),

              // Suggestion type and title
              Row(
                children: [
                  CustomIconWidget(
                    iconName: _getSuggestionIcon(
                        suggestion['type'] as String? ?? 'action'),
                    color: colorScheme.secondary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      suggestion['title'] as String? ?? 'AI Suggestion',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 1.h),

              // Description
              Text(
                suggestion['description'] as String? ??
                    'No description available',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.3,
                ),
                maxLines: isExpanded ? null : 2,
                overflow: isExpanded ? null : TextOverflow.ellipsis,
              ),

              // Reasoning (if expanded)
              if (isExpanded && suggestion['reasoning'] != null) ...[
                SizedBox(height: 1.5.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'psychology',
                            color: colorScheme.onSurfaceVariant,
                            size: 14,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'AI Reasoning',
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        suggestion['reasoning'] as String,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Action buttons
              if (suggestion['actions'] != null) ...[
                SizedBox(height: 1.5.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: (suggestion['actions'] as List).map((action) {
                    return _buildActionChip(
                      action as Map<String, dynamic>,
                      colorScheme,
                      theme,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfidenceIndicator(
      double confidence, ColorScheme colorScheme, ThemeData theme) {
    final percentage = (confidence * 100).round();
    Color confidenceColor;

    if (confidence >= 0.8) {
      confidenceColor = AppTheme.successLight;
    } else if (confidence >= 0.6) {
      confidenceColor = AppTheme.warningLight;
    } else {
      confidenceColor = AppTheme.errorLight;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: confidenceColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$percentage% confident',
        style: theme.textTheme.labelSmall?.copyWith(
          color: confidenceColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionChip(
      Map<String, dynamic> action, ColorScheme colorScheme, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        action['label'] as String? ?? 'Action',
        style: theme.textTheme.labelSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getSuggestionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'action':
        return 'task_alt';
      case 'project':
        return 'folder';
      case 'context':
        return 'location_on';
      case 'reference':
        return 'bookmark';
      case 'delegate':
        return 'person_add';
      default:
        return 'lightbulb';
    }
  }
}
