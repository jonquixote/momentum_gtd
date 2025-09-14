import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/project_card_widget.dart';
import './widgets/project_detail_view_widget.dart';
import './widgets/project_filter_sheet_widget.dart';
import './widgets/project_search_bar_widget.dart';
import './widgets/project_template_sheet_widget.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> with TickerProviderStateMixin {
  String _searchQuery = '';
  String _selectedFilter = 'all';
  List<Map<String, dynamic>> _selectedProjects = [];
  bool _isSelectionMode = false;
  late AnimationController _fabAnimationController;

  // Mock projects data
  final List<Map<String, dynamic>> _allProjects = [
    {
      'id': '1',
      'title': 'Mobile App Redesign',
      'description':
          'Complete overhaul of the mobile application user interface and experience',
      'status': 'active',
      'progress': 0.65,
      'nextAction': 'Review wireframes with design team',
      'lastActivity': '2025-09-12T08:30:00.000Z',
      'nextActions': [
        {
          'id': '1',
          'title': 'Review wireframes with design team',
          'context': 'office'
        },
        {
          'id': '2',
          'title': 'Conduct user testing sessions',
          'context': 'calls'
        },
        {
          'id': '3',
          'title': 'Update design system documentation',
          'context': 'computer'
        },
      ],
      'milestones': [
        {'id': '1', 'title': 'Research Phase Complete', 'completed': true},
        {'id': '2', 'title': 'Wireframes Approved', 'completed': false},
        {'id': '3', 'title': 'Prototype Ready', 'completed': false},
      ],
      'materials': [
        {'id': '1', 'name': 'User Research Report.pdf', 'type': 'file'},
        {'id': '2', 'name': 'Design Mockups', 'type': 'photo'},
      ],
      'notes':
          'Focus on improving the onboarding flow and simplifying the navigation structure. Consider accessibility requirements throughout the design process.',
    },
    {
      'id': '2',
      'title': 'European Vacation Planning',
      'description':
          'Plan and organize a 2-week trip across Europe visiting major cities',
      'status': 'active',
      'progress': 0.35,
      'nextAction': 'Book flights to Paris',
      'lastActivity': '2025-09-11T15:45:00.000Z',
      'nextActions': [
        {'id': '4', 'title': 'Book flights to Paris', 'context': 'online'},
        {'id': '5', 'title': 'Research hotels in Rome', 'context': 'computer'},
        {'id': '6', 'title': 'Apply for travel insurance', 'context': 'calls'},
      ],
      'milestones': [
        {'id': '4', 'title': 'Itinerary Planned', 'completed': true},
        {'id': '5', 'title': 'Flights Booked', 'completed': false},
        {'id': '6', 'title': 'Accommodations Reserved', 'completed': false},
      ],
      'materials': [
        {'id': '3', 'name': 'Travel Itinerary.docx', 'type': 'file'},
        {'id': '4', 'name': 'Passport Photos', 'type': 'photo'},
      ],
      'notes':
          'Remember to check visa requirements for each country. Pack light and bring comfortable walking shoes.',
    },
    {
      'id': '3',
      'title': 'Home Office Setup',
      'description': 'Create an ergonomic and productive workspace at home',
      'status': 'on-hold',
      'progress': 0.20,
      'nextAction': 'Measure available space',
      'lastActivity': '2025-09-08T12:20:00.000Z',
      'nextActions': [
        {'id': '7', 'title': 'Measure available space', 'context': 'home'},
        {'id': '8', 'title': 'Research ergonomic chairs', 'context': 'online'},
      ],
      'milestones': [
        {'id': '7', 'title': 'Space Assessment Complete', 'completed': false},
        {'id': '8', 'title': 'Furniture Selected', 'completed': false},
      ],
      'materials': [],
      'notes':
          'Budget is \$2000. Focus on good lighting and ergonomic furniture.',
    },
    {
      'id': '4',
      'title': 'Learn Spanish',
      'description':
          'Achieve conversational fluency in Spanish within 6 months',
      'status': 'active',
      'progress': 0.45,
      'nextAction': 'Complete Lesson 15 on Duolingo',
      'lastActivity': '2025-09-12T07:15:00.000Z',
      'nextActions': [
        {
          'id': '9',
          'title': 'Complete Lesson 15 on Duolingo',
          'context': 'anywhere'
        },
        {
          'id': '10',
          'title': 'Practice conversation with tutor',
          'context': 'calls'
        },
      ],
      'milestones': [
        {'id': '9', 'title': 'Basic Grammar Mastered', 'completed': true},
        {
          'id': '10',
          'title': 'Conversational Level Reached',
          'completed': false
        },
      ],
      'materials': [
        {'id': '5', 'name': 'Spanish Grammar Guide', 'type': 'file'},
        {'id': '6', 'name': 'Vocabulary Flashcards', 'type': 'link'},
      ],
      'notes':
          'Practice speaking daily. Focus on common phrases and everyday vocabulary.',
    },
    {
      'id': '5',
      'title': 'Website Launch',
      'description':
          'Launch the new company website with improved performance and SEO',
      'status': 'completed',
      'progress': 1.0,
      'nextAction': 'Project completed',
      'lastActivity': '2025-09-05T16:30:00.000Z',
      'nextActions': [],
      'milestones': [
        {'id': '11', 'title': 'Development Complete', 'completed': true},
        {'id': '12', 'title': 'Testing Passed', 'completed': true},
        {'id': '13', 'title': 'Site Launched', 'completed': true},
      ],
      'materials': [
        {'id': '7', 'name': 'Launch Checklist', 'type': 'file'},
        {'id': '8', 'name': 'Performance Report', 'type': 'file'},
      ],
      'notes':
          'Successfully launched on schedule. Site performance improved by 40%.',
    },
    {
      'id': '6',
      'title': 'Garden Renovation',
      'description':
          'Transform the backyard into a beautiful and functional garden space',
      'status': 'someday',
      'progress': 0.0,
      'nextAction': 'Research garden design ideas',
      'lastActivity': '2025-08-28T10:00:00.000Z',
      'nextActions': [
        {
          'id': '11',
          'title': 'Research garden design ideas',
          'context': 'online'
        },
      ],
      'milestones': [],
      'materials': [],
      'notes': 'Consider this project for next spring when weather improves.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredProjects {
    List<Map<String, dynamic>> filtered = _allProjects;

    // Apply status filter
    if (_selectedFilter != 'all') {
      filtered = filtered.where((project) {
        return project['status'] == _selectedFilter;
      }).toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((project) {
        final title = (project['title'] as String).toLowerCase();
        final description =
            (project['description'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || description.contains(query);
      }).toList();
    }

    return filtered;
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
        title: Text(
          _isSelectionMode
              ? '${_selectedProjects.length} selected'
              : 'Projects',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        leading: _isSelectionMode
            ? IconButton(
                onPressed: _exitSelectionMode,
                icon: CustomIconWidget(
                  iconName: 'close',
                  size: 24,
                  color: colorScheme.onSurface,
                ),
              )
            : null,
        actions:
            _isSelectionMode ? _buildSelectionActions() : _buildNormalActions(),
      ),
      body: Column(
        children: [
          // Search bar
          ProjectSearchBarWidget(
            initialQuery: _searchQuery,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            onFilterTap: _showFilterSheet,
            selectedFilter: _selectedFilter,
          ),

          // Projects list
          Expanded(
            child: _filteredProjects.isEmpty
                ? _buildEmptyState(theme, colorScheme)
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 10.h),
                    itemCount: _filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = _filteredProjects[index];
                      final isSelected = _selectedProjects
                          .any((p) => p['id'] == project['id']);

                      return GestureDetector(
                        onLongPress: () => _toggleProjectSelection(project),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? colorScheme.primary.withValues(alpha: 0.1)
                                : Colors.transparent,
                          ),
                          child: ProjectCardWidget(
                            project: project,
                            onTap: () => _isSelectionMode
                                ? _toggleProjectSelection(project)
                                : _openProjectDetail(project),
                            onComplete: () => _markProjectComplete(project),
                            onEdit: () => _editProject(project),
                            onArchive: () => _archiveProject(project),
                            onConvertToSomeday: () =>
                                _convertToSomeday(project),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? null
          : ScaleTransition(
              scale: _fabAnimationController,
              child: FloatingActionButton(
                onPressed: _showTemplateSheet,
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                child: CustomIconWidget(
                  iconName: 'add',
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: 4, // Projects tab
        onTap: (index) {
          final routes = [
            '/dashboard',
            '/universal-capture',
            '/in-basket-processing',
            '/next-actions',
            '/projects'
          ];
          if (index != 4) {
            Navigator.pushReplacementNamed(context, routes[index]);
          }
        },
      ),
    );
  }

  List<Widget> _buildNormalActions() {
    return [
      IconButton(
        onPressed: _showBatchOperations,
        icon: CustomIconWidget(
          iconName: 'checklist',
          size: 24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        tooltip: 'Batch operations',
      ),
    ];
  }

  List<Widget> _buildSelectionActions() {
    return [
      IconButton(
        onPressed: _archiveSelectedProjects,
        icon: CustomIconWidget(
          iconName: 'archive',
          size: 24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        tooltip: 'Archive selected',
      ),
      PopupMenuButton<String>(
        icon: CustomIconWidget(
          iconName: 'more_vert',
          size: 24,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onSelected: (value) {
          switch (value) {
            case 'complete':
              _markSelectedProjectsComplete();
              break;
            case 'someday':
              _convertSelectedToSomeday();
              break;
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'complete',
            child: Text('Mark Complete'),
          ),
          const PopupMenuItem(
            value: 'someday',
            child: Text('Convert to Someday'),
          ),
        ],
      ),
    ];
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    String message;
    String actionText;

    if (_searchQuery.isNotEmpty) {
      message = 'No projects found matching "$_searchQuery"';
      actionText = 'Clear search';
    } else if (_selectedFilter != 'all') {
      message = 'No ${_selectedFilter} projects found';
      actionText = 'View all projects';
    } else {
      message = 'No projects yet. Create your first project to get started.';
      actionText = 'Create Project';
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'folder_open',
              size: 64,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 3.h),
            Text(
              message,
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton(
              onPressed: () {
                if (_searchQuery.isNotEmpty) {
                  setState(() {
                    _searchQuery = '';
                  });
                } else if (_selectedFilter != 'all') {
                  setState(() {
                    _selectedFilter = 'all';
                  });
                } else {
                  _showTemplateSheet();
                }
              },
              child: Text(actionText),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ProjectFilterSheetWidget(
        selectedFilter: _selectedFilter,
        onFilterChanged: (filter) {
          setState(() {
            _selectedFilter = filter;
          });
        },
      ),
    );
  }

  void _showTemplateSheet() {
    _fabAnimationController.forward();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: 80.h,
        child: ProjectTemplateSheetWidget(
          onTemplateSelected: _createProjectFromTemplate,
        ),
      ),
    ).whenComplete(() {
      _fabAnimationController.reverse();
    });
  }

  void _createProjectFromTemplate(Map<String, dynamic> template) {
    // Create new project from template
    final newProject = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': template['id'] == 'blank' ? 'New Project' : template['title'],
      'description': template['description'],
      'status': 'active',
      'progress': 0.0,
      'nextAction': (template['actions'] as List).isNotEmpty
          ? (template['actions'] as List).first
          : 'Define first action',
      'lastActivity': DateTime.now().toIso8601String(),
      'nextActions': (template['actions'] as List)
          .map((action) => {
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'title': action,
                'context': 'general',
              })
          .toList(),
      'milestones': [],
      'materials': [],
      'notes': '',
    };

    setState(() {
      _allProjects.insert(0, newProject);
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Project "${newProject['title']}" created successfully'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () => _openProjectDetail(newProject),
        ),
      ),
    );
  }

  void _openProjectDetail(Map<String, dynamic> project) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProjectDetailViewWidget(
          project: project,
          onBack: () => Navigator.pop(context),
          onEdit: () => _editProject(project),
          onShare: () => _shareProject(project),
        ),
      ),
    );
  }

  void _markProjectComplete(Map<String, dynamic> project) {
    setState(() {
      project['status'] = 'completed';
      project['progress'] = 1.0;
      project['lastActivity'] = DateTime.now().toIso8601String();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Project "${project['title']}" marked as complete'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _editProject(Map<String, dynamic> project) {
    // Navigate to edit project screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Edit project "${project['title']}"'),
      ),
    );
  }

  void _archiveProject(Map<String, dynamic> project) {
    setState(() {
      _allProjects.remove(project);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Project "${project['title']}" archived'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allProjects.add(project);
            });
          },
        ),
      ),
    );
  }

  void _convertToSomeday(Map<String, dynamic> project) {
    setState(() {
      project['status'] = 'someday';
      project['lastActivity'] = DateTime.now().toIso8601String();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Project "${project['title']}" moved to Someday/Maybe'),
      ),
    );
  }

  void _shareProject(Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share project "${project['title']}"'),
      ),
    );
  }

  void _showBatchOperations() {
    setState(() {
      _isSelectionMode = true;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedProjects.clear();
    });
  }

  void _toggleProjectSelection(Map<String, dynamic> project) {
    setState(() {
      final isSelected = _selectedProjects.any((p) => p['id'] == project['id']);
      if (isSelected) {
        _selectedProjects.removeWhere((p) => p['id'] == project['id']);
      } else {
        _selectedProjects.add(project);
      }

      if (_selectedProjects.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _archiveSelectedProjects() {
    setState(() {
      for (final project in _selectedProjects) {
        _allProjects.remove(project);
      }
      _selectedProjects.clear();
      _isSelectionMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selected projects archived'),
      ),
    );
  }

  void _markSelectedProjectsComplete() {
    setState(() {
      for (final project in _selectedProjects) {
        project['status'] = 'completed';
        project['progress'] = 1.0;
        project['lastActivity'] = DateTime.now().toIso8601String();
      }
      _selectedProjects.clear();
      _isSelectionMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Selected projects marked as complete'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _convertSelectedToSomeday() {
    setState(() {
      for (final project in _selectedProjects) {
        project['status'] = 'someday';
        project['lastActivity'] = DateTime.now().toIso8601String();
      }
      _selectedProjects.clear();
      _isSelectionMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selected projects moved to Someday/Maybe'),
      ),
    );
  }
}
