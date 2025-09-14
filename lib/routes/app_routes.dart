import 'package:flutter/material.dart';
import '../presentation/in_basket_processing/in_basket_processing.dart';
import '../presentation/next_actions/next_actions.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/projects/projects.dart';
import '../presentation/universal_capture/universal_capture.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String inBasketProcessing = '/in-basket-processing';
  static const String nextActions = '/next-actions';
  static const String dashboard = '/dashboard';
  static const String projects = '/projects';
  static const String universalCapture = '/universal-capture';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const InBasketProcessing(),
    inBasketProcessing: (context) => const InBasketProcessing(),
    nextActions: (context) => const NextActions(),
    dashboard: (context) => const Dashboard(),
    projects: (context) => const Projects(),
    universalCapture: (context) => const UniversalCapture(),
    // TODO: Add your other routes here
  };
}
