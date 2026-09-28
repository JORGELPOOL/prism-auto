import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'repositories/auto_repository.dart';
import 'screens/shell/auto_shell.dart';

/// PRISM AUTO root widget. Wraps the app in a single AutoRepository
/// (MockAutoRepository for this pass — screens only, mock data, no API
/// calls per the build spec) and PRISM's dark theme.
class PrismAutoApp extends StatelessWidget {
  const PrismAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AutoRepository>(
      create: (_) => MockAutoRepository(),
      child: MaterialApp(
        title: 'PRISM AUTO',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const AutoShell(),
      ),
    );
  }
}
