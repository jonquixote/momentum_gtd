import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InBasketWidget extends StatelessWidget {
  const InBasketWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Mock in-basket data
    final int inBasketCount = 7;
    final String urgencyLevel = _getUrgencyLevel(inBasketCount);
    final Color urgencyColor = _getUrgencyColor(inBasketCount);

    final List<Map<String, dynamic>> recentItems = [
      {
        "id": 1,
        "title": "Email from client about project requirements",
        "type": "email",
        "timestamp": "2 hours ago",
        "source": "Gmail",
      },
      {
        "id": 2,
        "title": "Meeting notes from strategy session",
        "type": "note",
        "timestamp": "4 hours ago",
        "source": "Voice capture",
      },
      {
        "id": 3,
        "title": "Research article on productivity methods",
        "type": "link",
        "timestamp": "Yesterday",
        "source": "Web capture",
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 3,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/in-basket-processing');
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with count and urgency badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'inbox',
                          size: 24,
                          color: colorScheme.primary,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          "In-Basket",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    _buildUrgencyBadge(
                        inBasketCount, urgencyLevel, urgencyColor, theme),
                  ],
                ),

                SizedBox(height: 3.h),

                // Count display
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: urgencyColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        inBasketCount.toString(),
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: urgencyColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            inBasketCount == 1
                                ? "item to process"
                                : "items to process",
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            _getProcessingMessage(inBasketCount),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 3.h),

                // Recent items preview
                if (recentItems.isNotEmpty) ...[
                  Text(
                    "Recent captures:",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...recentItems
                      .take(2)
                      .map((item) => _buildRecentItem(item, theme)),
                ],

                SizedBox(height: 2.h),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/in-basket-processing');
                    },
                    icon: CustomIconWidget(
                      iconName: 'play_arrow',
                      size: 20,
                      color: Colors.white,
                    ),
                    label: Text(
                      inBasketCount > 0 ? "Start Processing" : "View In-Basket",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: inBasketCount > 0
                          ? urgencyColor
                          : colorScheme.primary,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  Widget _buildUrgencyBadge(
      int count, String urgencyLevel, Color urgencyColor, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: urgencyColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: urgencyColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: urgencyColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            urgencyLevel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: urgencyColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItem(Map<String, dynamic> item, ThemeData theme) {
    final colorScheme = theme.colorScheme;

    IconData typeIcon = Icons.inbox;
    switch (item["type"]) {
      case "email":
        typeIcon = Icons.email;
        break;
      case "note":
        typeIcon = Icons.note;
        break;
      case "link":
        typeIcon = Icons.link;
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: typeIcon.toString().split('.').last,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "${item["timestamp"]} • ${item["source"]}",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getUrgencyLevel(int count) {
    if (count == 0) return "Clear";
    if (count <= 3) return "Low";
    if (count <= 7) return "Medium";
    if (count <= 15) return "High";
    return "Critical";
  }

  Color _getUrgencyColor(int count) {
    if (count == 0) return AppTheme.successLight;
    if (count <= 3) return AppTheme.successLight;
    if (count <= 7) return AppTheme.warningLight;
    if (count <= 15) return AppTheme.errorLight;
    return AppTheme.errorLight;
  }

  String _getProcessingMessage(int count) {
    if (count == 0)
      return "Your in-basket is clear! Great job staying on top of things.";
    if (count <= 3) return "Just a few items to process. You're doing great!";
    if (count <= 7)
      return "A manageable amount to process. Take it one item at a time.";
    if (count <= 15)
      return "Your in-basket needs attention. Consider a processing session.";
    return "Time for a focused processing session to clear your mind.";
  }
}
