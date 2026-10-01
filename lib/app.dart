import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/processing/processing_bloc.dart';
import 'core/theme/app_theme.dart';
import 'repositories/auto_repository.dart';
import 'repositories/live_auto_repository.dart';
import 'screens/shell/auto_shell.dart';

/// PRISM AUTO root widget.
///
/// AutoRepository is now LiveAutoRepository: Screen 2 (Processing) calls
/// the real backend from the Final Master Spec v2; every other screen
/// still runs on LiveAutoRepository's inherited mock data until it's
/// wired up next.
///
/// ProcessingBloc is provided here, above MaterialApp, rather than inside
/// ProcessingScreen — a single instance lives for the whole app session
/// so polling survives navigation, and AutoShell's persistent indicator
/// can read its state from anywhere.
class PrismAutoApp extends StatelessWidget {
  const PrismAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AutoRepository>(
      create: (_) => LiveAutoRepository(),
      child: BlocProvider<ProcessingBloc>(
        create: (context) => ProcessingBloc(context.read<AutoRepository>()),
        child: MaterialApp(
          title: 'PRISM AUTO',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: const AutoShell(),
        ),
      ),
    );
  }
}
