import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProjectTemplateSheetWidget extends StatelessWidget {
  final ValueChanged<Map<String, dynamic>>? onTemplateSelected;

  const ProjectTemplateSheetWidget({
    super.key,
    this.onTemplateSelected,
  });

  final List<Map<String, dynamic>> _templates = const [
    {
      'id': 'blank',
      'title': 'Blank Project',
      'description': 'Start from scratch with a clean slate',
      'icon': 'add_circle_outline',
      'color': 0xFF3498DB,
      'actions': [],
    },
    {
      'id': 'travel',
      'title': 'Travel Planning',
      'description': 'Organize flights, hotels, and itinerary',
      'icon': 'flight',
      'color': 0xFF27AE60,
      'actions': [
        'Research destinations',
        'Book flights',
        'Reserve accommodation',
        'Plan daily activities',
        'Prepare travel documents',
      ],
    },
    {
      'id': 'home_improvement',
      'title': 'Home Improvement',
      'description': 'Plan and execute home renovation projects',
      'icon': 'home_repair_service',
      'color': 0xFFF39C12,
      'actions': [
        'Define project scope',
        'Get contractor quotes',
        'Obtain permits if needed',
        'Purchase materials',
        'Schedule work phases',
      ],
    },
    {
      'id': 'presentation',
      'title': 'Work Presentation',
      'description': 'Create compelling business presentations',
      'icon': 'presentation',
      'color': 0xFFE74C3C,
      'actions': [
        'Define presentation objectives',
        'Research content and data',
        'Create slide outline',
        'Design visual elements',
        'Practice and rehearse',
      ],
    },
    {
      'id': 'event',
      'title': 'Event Planning',
      'description': 'Organize memorable events and gatherings',
      'icon': 'event',
      'color': 0xFF9B59B6,
      'actions': [
        'Set event date and venue',
        'Create guest list',
        'Send invitations',
        'Plan catering and menu',
        'Coordinate entertainment',
      ],
    },
    {
      'id': 'learning',
      'title': 'Learning Project',
      'description': 'Master new skills and knowledge areas',
      'icon': 'school',
      'color': 0xFF1ABC9C,
      'actions': [
        'Define learning objectives',
        'Research learning resources',
        'Create study schedule',
        'Practice and apply knowledge',
        'Assess progress and adjust',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Choose Template',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    size: 24,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Templates grid
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
                childAspectRatio: 0.85,
              ),
              itemCount: _templates.length,
              itemBuilder: (context, index) {
                final template = _templates[index];
                return _buildTemplateCard(
                    context, template, theme, colorScheme);
              },
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 2.h),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(
    BuildContext context,
    Map<String, dynamic> template,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final templateColor = Color(template['color'] as int);

    return Card(
      elevation: 2,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onTemplateSelected?.call(template);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: templateColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: template['icon'] as String,
                    size: 24,
                    color: templateColor,
                  ),
                ),
              ),

              SizedBox(height: 2.h),

              // Title
              Text(
                template['title'] as String,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 1.h),

              // Description
              Expanded(
                child: Text(
                  template['description'] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Action count indicator
              if ((template['actions'] as List).isNotEmpty) ...[
                SizedBox(height: 1.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: templateColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${(template['actions'] as List).length} actions',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: templateColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
