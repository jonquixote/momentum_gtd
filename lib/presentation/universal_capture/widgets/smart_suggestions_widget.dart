import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SmartSuggestionsWidget extends StatefulWidget {
  final String inputText;
  final Function(String) onSuggestionSelected;
  final Function(String, String) onProjectAssociation;

  const SmartSuggestionsWidget({
    super.key,
    required this.inputText,
    required this.onSuggestionSelected,
    required this.onProjectAssociation,
  });

  @override
  State<SmartSuggestionsWidget> createState() => _SmartSuggestionsWidgetState();
}

class _SmartSuggestionsWidgetState extends State<SmartSuggestionsWidget> {
  List<Map<String, dynamic>> _suggestions = [];
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    if (widget.inputText.isNotEmpty) {
      _analyzeSuggestions();
    }
  }

  @override
  void didUpdateWidget(SmartSuggestionsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.inputText != oldWidget.inputText &&
        widget.inputText.isNotEmpty) {
      _analyzeSuggestions();
    }
  }

  Future<void> _analyzeSuggestions() async {
    if (widget.inputText.trim().length < 10) return;

    setState(() => _isAnalyzing = true);

    // Simulate AI analysis delay
    await Future.delayed(const Duration(milliseconds: 800));

    final suggestions = _generateSmartSuggestions(widget.inputText);

    if (mounted) {
      setState(() {
        _suggestions = suggestions;
        _isAnalyzing = false;
      });
    }
  }

  List<Map<String, dynamic>> _generateSmartSuggestions(String text) {
    final suggestions = <Map<String, dynamic>>[];
    final lowerText = text.toLowerCase();

    // Project associations
    final projects = _getProjectSuggestions(lowerText);
    suggestions.addAll(projects);

    // Next action suggestions
    final actions = _getNextActionSuggestions(lowerText);
    suggestions.addAll(actions);

    // Context suggestions
    final contexts = _getContextSuggestions(lowerText);
    suggestions.addAll(contexts);

    return suggestions;
  }

  List<Map<String, dynamic>> _getProjectSuggestions(String text) {
    final projectKeywords = {
      'website': {'project': 'Website Redesign', 'confidence': 0.85},
      'app': {'project': 'Mobile App Development', 'confidence': 0.80},
      'marketing': {'project': 'Q4 Marketing Campaign', 'confidence': 0.75},
      'report': {'project': 'Quarterly Business Review', 'confidence': 0.70},
      'presentation': {
        'project': 'Board Meeting Preparation',
        'confidence': 0.75
      },
      'client': {'project': 'Client Onboarding Process', 'confidence': 0.70},
      'budget': {'project': 'Annual Budget Planning', 'confidence': 0.80},
      'training': {'project': 'Team Training Program', 'confidence': 0.75},
    };

    final suggestions = <Map<String, dynamic>>[];

    for (final entry in projectKeywords.entries) {
      if (text.contains(entry.key)) {
        suggestions.add({
          'type': 'project',
          'title': 'Associate with ${entry.value['project']}',
          'subtitle': 'Project suggestion',
          'confidence': entry.value['confidence'],
          'action': entry.value['project'],
          'icon': 'folder',
        });
      }
    }

    return suggestions;
  }

  List<Map<String, dynamic>> _getNextActionSuggestions(String text) {
    final actionPatterns = {
      r'\bcall\b': {'action': 'Make phone call', 'confidence': 0.90},
      r'\bemail\b': {'action': 'Send email', 'confidence': 0.85},
      r'\bmeeting\b': {'action': 'Schedule meeting', 'confidence': 0.80},
      r'\bbuy\b': {'action': 'Purchase item', 'confidence': 0.75},
      r'\breview\b': {'action': 'Review document', 'confidence': 0.70},
      r'\bresearch\b': {'action': 'Conduct research', 'confidence': 0.75},
      r'\bwrite\b': {'action': 'Write document', 'confidence': 0.70},
      r'\bschedule\b': {'action': 'Schedule appointment', 'confidence': 0.80},
    };

    final suggestions = <Map<String, dynamic>>[];

    for (final entry in actionPatterns.entries) {
      final regex = RegExp(entry.key, caseSensitive: false);
      if (regex.hasMatch(text)) {
        suggestions.add({
          'type': 'action',
          'title': entry.value['action'],
          'subtitle': 'Next action suggestion',
          'confidence': entry.value['confidence'],
          'action': entry.value['action'],
          'icon': 'task_alt',
        });
      }
    }

    return suggestions;
  }

  List<Map<String, dynamic>> _getContextSuggestions(String text) {
    final contextKeywords = {
      'office': {'context': '@office', 'confidence': 0.80},
      'home': {'context': '@home', 'confidence': 0.75},
      'computer': {'context': '@computer', 'confidence': 0.85},
      'phone': {'context': '@calls', 'confidence': 0.90},
      'online': {'context': '@online', 'confidence': 0.80},
      'store': {'context': '@errands', 'confidence': 0.75},
      'meeting': {'context': '@agenda', 'confidence': 0.70},
      'read': {'context': '@read/review', 'confidence': 0.75},
    };

    final suggestions = <Map<String, dynamic>>[];

    for (final entry in contextKeywords.entries) {
      if (text.contains(entry.key)) {
        suggestions.add({
          'type': 'context',
          'title': 'Add context ${entry.value['context']}',
          'subtitle': 'Context suggestion',
          'confidence': entry.value['confidence'],
          'action': entry.value['context'],
          'icon': 'location_on',
        });
      }
    }

    return suggestions;
  }

  Color _getConfidenceColor(double confidence, ColorScheme colorScheme) {
    if (confidence >= 0.8) return AppTheme.lightTheme.colorScheme.tertiary;
    if (confidence >= 0.6) return colorScheme.secondary;
    return colorScheme.outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isAnalyzing) {
      return _buildAnalyzingIndicator(colorScheme);
    }

    if (_suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'psychology',
              color: colorScheme.primary,
              size: 5.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Smart Suggestions',
              style: theme.textTheme.titleSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        ..._suggestions
            .map((suggestion) => _buildSuggestionCard(suggestion, colorScheme)),
      ],
    );
  }

  Widget _buildAnalyzingIndicator(ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
            height: 5.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
          ),
          SizedBox(width: 3.w),
          Text(
            'Analyzing your input...',
            style: TextStyle(
              fontSize: 12.sp,
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(
      Map<String, dynamic> suggestion, ColorScheme colorScheme) {
    final confidence = suggestion['confidence'] as double;
    final confidenceColor = _getConfidenceColor(confidence, colorScheme);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (suggestion['type'] == 'project') {
              widget.onProjectAssociation(
                  widget.inputText, suggestion['action']);
            } else {
              widget.onSuggestionSelected(suggestion['action']);
            }
          },
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: confidenceColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: confidenceColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: CustomIconWidget(
                    iconName: suggestion['icon'],
                    color: confidenceColor,
                    size: 4.w,
                  ),
                ),
                SizedBox(width: 3.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        suggestion['title'],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        suggestion['subtitle'],
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                // Confidence indicator
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: confidenceColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(confidence * 100).round()}%',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: confidenceColor,
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
}
