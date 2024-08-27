import 'package:capacitaciones/views/list_trainings.dart';
import 'package:flutter/material.dart';
import 'package:capacitaciones/views/details_training.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => ListTraining(),
};

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/details':
      final args = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => DetailsTraining(parameter: args),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => ListTraining(),
      );
  }
}
