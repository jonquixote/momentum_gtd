import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/action_buttons_row.dart';
import './widgets/ai_suggestion_card.dart';
import './widgets/empty_state_widget.dart';
import './widgets/in_basket_item_card.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/two_minute_timer.dart';

class InBasketProcessing extends StatefulWidget {
  const InBasketProcessing({super.key});

  @override
  State<InBasketProcessing> createState() => _InBasketProcessingState();
}

class _InBasketProcessingState extends State<InBasketProcessing>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  bool _showTwoMinuteTimer = false;
  bool _isProcessing = false;
  bool _showAISuggestions = true;
  int _expandedSuggestionIndex = -1;

  // Mock data for in-basket items
  final List<Map<String, dynamic>> _inBasketItems = [
    {
      "id": 1,
      "title": "Follow up on project proposal",
      "content":
          "Need to check with Sarah about the Q4 marketing campaign proposal we submitted last week. Client mentioned they'd have feedback by today.",
      "source": "email",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "hasAttachment": true,
    },
    {
      "id": 2,
      "title": null,
      "content":
          "Remember to book dentist appointment for next month. Also need to call insurance about coverage for the new treatment plan.",
      "source": "voice",
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "hasAttachment": false,
    },
    {
      "id": 3,
      "title": "Meeting notes from client call",
      "content":
          "Client wants to expand the project scope to include mobile app development. Budget increase needed. Timeline might shift to Q1 next year.",
      "source": "text",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "hasAttachment": false,
    },
    {
      "id": 4,
      "title": null,
      "content":
          "Interesting article about productivity techniques and time management strategies for remote teams. Could be useful for our upcoming workshop.",
      "source": "web",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "hasAttachment": true,
    },
    {
      "id": 5,
      "title": "Expense receipt",
      "content":
          "Lunch meeting with potential client at downtown restaurant. \$85.50 total including tip. Need to submit for reimbursement.",
      "source": "photo",
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "hasAttachment": true,
    },
  ];

  // Mock AI suggestions
  final List<Map<String, dynamic>> _aiSuggestions = [
    {
      "type": "action",
      "title": "Create Next Action",
      "description":
          "Send follow-up email to Sarah about project proposal status",
      "confidence": 0.92,
      "reasoning":
          "This item requires a specific action with a clear next step. The two-minute rule doesn't apply as it involves waiting for someone else's response.",
      "actions": [
        {"label": "Email", "type": "communication"},
        {"label": "High Priority", "type": "priority"},
      ],
    },
    {
      "type": "project",
      "title": "Multi-step Project Detected",
      "description":
          "This might be part of a larger 'Q4 Marketing Campaign' project",
      "confidence": 0.78,
      "reasoning":
          "The mention of a proposal and client feedback suggests this is part of a larger initiative that may require multiple actions.",
      "actions": [
        {"label": "Create Project", "type": "project"},
        {"label": "Link Actions", "type": "organization"},
      ],
    },
    {
      "type": "context",
      "title": "Suggested Context",
      "description": "@calls - Phone context for follow-up communication",
      "confidence": 0.85,
      "reasoning":
          "Follow-up communication is often more effective via phone call for urgent matters.",
      "actions": [
        {"label": "@calls", "type": "context"},
        {"label": "Add Contact", "type": "contact"},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextItem() {
    if (_currentIndex < _inBasketItems.length - 1) {
      setState(() {
        _currentIndex++;
        _showTwoMinuteTimer = false;
        _expandedSuggestionIndex = -1;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousItem() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _showTwoMinuteTimer = false;
        _expandedSuggestionIndex = -1;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _processItem(String action) {
    setState(() {
      _isProcessing = true;
    });

    // Simulate processing
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _inBasketItems.removeAt(_currentIndex);
        _isProcessing = false;
        _showTwoMinuteTimer = false;
        _expandedSuggestionIndex = -1;

        if (_currentIndex >= _inBasketItems.length &&
            _inBasketItems.isNotEmpty) {
          _currentIndex = _inBasketItems.length - 1;
        }
      });

      // Show success feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item processed as $action'),
          backgroundColor: AppTheme.successLight,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      // Move to next item or stay on current
      if (_inBasketItems.isNotEmpty) {
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handleSwipe(DismissDirection direction) {
    HapticFeedback.mediumImpact();

    if (direction == DismissDirection.endToStart) {
      // Swipe left for reference
      _processItem('Reference Material');
    } else if (direction == DismissDirection.startToEnd) {
      // Swipe right for actionable
      _processItem('Actionable');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'In-Basket Processing',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: colorScheme.onSurface,
            size: 20,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _showAISuggestions = !_showAISuggestions;
              });
            },
            icon: CustomIconWidget(
              iconName:
                  _showAISuggestions ? 'auto_awesome' : 'auto_awesome_outlined',
              color: _showAISuggestions
                  ? colorScheme.secondary
                  : colorScheme.onSurfaceVariant,
              size: 24,
            ),
            tooltip: 'Toggle AI Suggestions',
          ),
          IconButton(
            onPressed: () {
              // Show help/tutorial
              _showHelpDialog();
            },
            icon: CustomIconWidget(
              iconName: 'help_outline',
              color: colorScheme.onSurfaceVariant,
              size: 24,
            ),
            tooltip: 'Help',
          ),
        ],
      ),
      body: _inBasketItems.isEmpty
          ? EmptyStateWidget(
              processedCount: 5, // Mock processed count
              onWeeklyReview: () {
                // Navigate to weekly review
                Navigator.pushNamed(context, '/weekly-review');
              },
              onBackToDashboard: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/dashboard',
                  (route) => false,
                );
              },
            )
          : Column(
              children: [
                // Progress indicator
                ProgressIndicatorWidget(
                  currentIndex: _currentIndex,
                  totalItems: _inBasketItems.length,
                  currentItemTitle: _inBasketItems.isNotEmpty
                      ? _inBasketItems[_currentIndex]['title'] as String?
                      : null,
                  onPrevious: _previousItem,
                  onNext: _nextItem,
                  canGoBack: _currentIndex > 0,
                  canGoForward: _currentIndex < _inBasketItems.length - 1,
                ),

                // Main content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Item cards
                        SizedBox(
                          height: 40.h,
                          child: PageView.builder(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                                _showTwoMinuteTimer = false;
                                _expandedSuggestionIndex = -1;
                              });
                            },
                            itemCount: _inBasketItems.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key:
                                    Key(_inBasketItems[index]['id'].toString()),
                                onDismissed: _handleSwipe,
                                background: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successLight,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.w),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomIconWidget(
                                            iconName: 'task_alt',
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                          SizedBox(height: 1.h),
                                          Text(
                                            'Actionable',
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                secondaryBackground: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 8.w),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomIconWidget(
                                            iconName: 'bookmark',
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                          SizedBox(height: 1.h),
                                          Text(
                                            'Reference',
                                            style: theme.textTheme.labelMedium
                                                ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                child: InBasketItemCard(
                                  item: _inBasketItems[index],
                                ),
                              );
                            },
                          ),
                        ),

                        // Two-minute timer
                        TwoMinuteTimer(
                          isVisible: _showTwoMinuteTimer,
                          onComplete: () {
                            setState(() {
                              _showTwoMinuteTimer = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text(
                                    'Time\'s up! Consider if this is truly a 2-minute task.'),
                                backgroundColor: AppTheme.warningLight,
                              ),
                            );
                          },
                          onDoItNow: () {
                            _processItem('Completed');
                          },
                        ),

                        // AI Suggestions
                        if (_showAISuggestions) ...[
                          SizedBox(height: 2.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'auto_awesome',
                                  color: colorScheme.secondary,
                                  size: 20,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  'AI Suggestions',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.secondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 1.h),
                          ..._aiSuggestions.asMap().entries.map((entry) {
                            final index = entry.key;
                            final suggestion = entry.value;
                            return AiSuggestionCard(
                              suggestion: suggestion,
                              isExpanded: _expandedSuggestionIndex == index,
                              onTap: () {
                                setState(() {
                                  _expandedSuggestionIndex =
                                      _expandedSuggestionIndex == index
                                          ? -1
                                          : index;
                                });
                              },
                            );
                          }).toList(),
                        ],

                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _inBasketItems.isNotEmpty
          ? ActionButtonsRow(
              isEnabled: !_isProcessing,
              onActionable: () {
                setState(() {
                  _showTwoMinuteTimer = true;
                });
              },
              onReference: () => _processItem('Reference Material'),
              onSomedayMaybe: () => _processItem('Someday/Maybe'),
              onTrash: () => _processItem('Trash'),
              onDelegate: () {
                // Show delegate dialog
                _showDelegateDialog();
              },
            )
          : null,
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'help_outline',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('Processing Guide'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GTD Clarification Workflow:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 1.h),
            _buildHelpItem('1. What is it?', 'Understand the item clearly'),
            _buildHelpItem(
                '2. Is it actionable?', 'Can you do something about it?'),
            _buildHelpItem('3. Two-minute rule', 'If < 2 minutes, do it now'),
            _buildHelpItem(
                '4. Delegate or defer', 'Assign or schedule for later'),
            SizedBox(height: 1.h),
            Text(
              'Swipe Shortcuts:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(height: 0.5.h),
            _buildHelpItem('→ Right swipe', 'Mark as actionable'),
            _buildHelpItem('← Left swipe', 'Save as reference'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _showDelegateDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'person_add',
              color: Theme.of(context).colorScheme.secondary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            const Text('Delegate Item'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Delegate to',
                hintText: 'Enter person\'s name or email',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Follow-up date',
                hintText: 'When to check back',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () {
                // Show date picker
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processItem('Delegated');
            },
            child: const Text('Delegate'),
          ),
        ],
      ),
    );
  }
}
