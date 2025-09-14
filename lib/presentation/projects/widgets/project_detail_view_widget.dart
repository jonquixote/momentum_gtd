import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProjectDetailViewWidget extends StatefulWidget {
  final Map<String, dynamic> project;
  final VoidCallback? onBack;
  final VoidCallback? onEdit;
  final VoidCallback? onShare;

  const ProjectDetailViewWidget({
    super.key,
    required this.project,
    this.onBack,
    this.onEdit,
    this.onShare,
  });

  @override
  State<ProjectDetailViewWidget> createState() =>
      _ProjectDetailViewWidgetState();
}

class _ProjectDetailViewWidgetState extends State<ProjectDetailViewWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: widget.onBack,
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            size: 20,
            color: colorScheme.onSurface,
          ),
        ),
        title: Text(
          widget.project['title'] as String? ?? 'Project Details',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: widget.onShare,
            icon: CustomIconWidget(
              iconName: 'share',
              size: 24,
              color: colorScheme.onSurface,
            ),
          ),
          IconButton(
            onPressed: widget.onEdit,
            icon: CustomIconWidget(
              iconName: 'edit',
              size: 24,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Project header
          _buildProjectHeader(theme, colorScheme),

          // Tab bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Actions'),
                Tab(text: 'Materials'),
                Tab(text: 'Notes'),
              ],
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(theme, colorScheme),
                _buildActionsTab(theme, colorScheme),
                _buildMaterialsTab(theme, colorScheme),
                _buildNotesTab(theme, colorScheme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectHeader(ThemeData theme, ColorScheme colorScheme) {
    final progress = (widget.project['progress'] as num?)?.toDouble() ?? 0.0;
    final status = widget.project['status'] as String? ?? 'active';

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          if (widget.project['description'] != null) ...[
            Text(
              widget.project['description'] as String,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 3.h),
          ],

          // Progress and status
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${(progress * 100).toInt()}% Complete',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(status).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(ThemeData theme, ColorScheme colorScheme) {
    final nextActions = (widget.project['nextActions'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];
    final milestones =
        (widget.project['milestones'] as List?)?.cast<Map<String, dynamic>>() ??
            [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Next actions preview
          _buildSectionHeader('Next Actions', theme, colorScheme),
          SizedBox(height: 2.h),
          nextActions.isEmpty
              ? _buildEmptyState('No next actions defined', theme, colorScheme)
              : Column(
                  children: nextActions.take(3).map((action) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'radio_button_unchecked',
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              action['title'] as String? ?? 'Untitled Action',
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

          SizedBox(height: 4.h),

          // Milestones
          _buildSectionHeader('Milestones', theme, colorScheme),
          SizedBox(height: 2.h),
          milestones.isEmpty
              ? _buildEmptyState('No milestones set', theme, colorScheme)
              : Column(
                  children: milestones.map((milestone) {
                    final isCompleted =
                        milestone['completed'] as bool? ?? false;
                    return Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? colorScheme.tertiary.withValues(alpha: 0.1)
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: isCompleted
                                ? 'check_circle'
                                : 'radio_button_unchecked',
                            size: 20,
                            color: isCompleted
                                ? colorScheme.tertiary
                                : colorScheme.onSurfaceVariant,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              milestone['title'] as String? ??
                                  'Untitled Milestone',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildActionsTab(ThemeData theme, ColorScheme colorScheme) {
    final nextActions = (widget.project['nextActions'] as List?)
            ?.cast<Map<String, dynamic>>() ??
        [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next Actions',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Add new action
                },
                icon: CustomIconWidget(
                  iconName: 'add',
                  size: 20,
                  color: colorScheme.primary,
                ),
                label: Text(
                  'Add Action',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          nextActions.isEmpty
              ? _buildEmptyState(
                  'No actions yet. Add your first action to get started.',
                  theme,
                  colorScheme)
              : ReorderableListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: nextActions.length,
                  onReorder: (oldIndex, newIndex) {
                    // Handle reordering
                  },
                  itemBuilder: (context, index) {
                    final action = nextActions[index];
                    return Container(
                      key: ValueKey(action['id']),
                      margin: EdgeInsets.only(bottom: 1.h),
                      child: Card(
                        child: ListTile(
                          leading: CustomIconWidget(
                            iconName: 'drag_handle',
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          title: Text(
                              action['title'] as String? ?? 'Untitled Action'),
                          subtitle: action['context'] != null
                              ? Text('@${action['context']}')
                              : null,
                          trailing: PopupMenuButton(
                            icon: CustomIconWidget(
                              iconName: 'more_vert',
                              size: 20,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem(
                                value: 'complete',
                                child: Text('Mark Complete'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildMaterialsTab(ThemeData theme, ColorScheme colorScheme) {
    final materials =
        (widget.project['materials'] as List?)?.cast<Map<String, dynamic>>() ??
            [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Support Materials',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Add material
                },
                icon: CustomIconWidget(
                  iconName: 'add',
                  size: 20,
                  color: colorScheme.primary,
                ),
                label: Text(
                  'Add Material',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          materials.isEmpty
              ? _buildEmptyState('No materials added yet.', theme, colorScheme)
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: materials.length,
                  itemBuilder: (context, index) {
                    final material = materials[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 1.h),
                      child: Card(
                        child: ListTile(
                          leading: CustomIconWidget(
                            iconName: _getMaterialIcon(
                                material['type'] as String? ?? 'file'),
                            size: 24,
                            color: colorScheme.primary,
                          ),
                          title: Text(material['name'] as String? ??
                              'Untitled Material'),
                          subtitle: Text(
                              material['type'] as String? ?? 'Unknown type'),
                          trailing: PopupMenuButton(
                            icon: CustomIconWidget(
                              iconName: 'more_vert',
                              size: 20,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'open',
                                child: Text('Open'),
                              ),
                              const PopupMenuItem(
                                value: 'share',
                                child: Text('Share'),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildNotesTab(ThemeData theme, ColorScheme colorScheme) {
    final notes = widget.project['notes'] as String? ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Project Notes',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  // Edit notes
                },
                icon: CustomIconWidget(
                  iconName: 'edit',
                  size: 20,
                  color: colorScheme.primary,
                ),
                label: Text(
                  'Edit',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          notes.isEmpty
              ? _buildEmptyState('No notes added yet.', theme, colorScheme)
              : Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    notes,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      height: 1.6,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, ThemeData theme, ColorScheme colorScheme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
    );
  }

  Widget _buildEmptyState(
      String message, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'inbox',
            size: 48,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          SizedBox(height: 2.h),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'on-hold':
        return AppTheme.warningLight;
      case 'completed':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'someday':
        return AppTheme.lightTheme.colorScheme.surfaceContainerHighest;
      default:
        return AppTheme.lightTheme.colorScheme.surfaceContainerHighest;
    }
  }

  String _getMaterialIcon(String type) {
    switch (type.toLowerCase()) {
      case 'file':
        return 'description';
      case 'photo':
        return 'photo';
      case 'link':
        return 'link';
      case 'voice':
        return 'mic';
      default:
        return 'description';
    }
  }
}
