import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/processing/processing_bloc.dart';
import '../../blocs/processing/processing_event.dart';
import '../../blocs/processing/processing_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/auto/progress_step_list.dart';
import '../../widgets/common/prism_card.dart';
import '../results/results_screen.dart';

/// SCREEN 2: Processing. Polls the real GET /beam/uploads/:id/status
/// endpoint every ~4s via the app-level ProcessingBloc (provided above
/// AutoShell in app.dart, not created here) until the backend reports
/// completed or failed.
///
/// "Safe to navigate away" (per spec) works because the bloc outlives
/// this route: tapping "Continue in background" just pops this screen
/// while polling keeps running, and the shell's persistent Cyan-dot
/// indicator (see auto_shell.dart) stays live and can bring the user
/// back here for the same uploadId.
class ProcessingScreen extends StatefulWidget {
  final String uploadId;
  const ProcessingScreen({super.key, required this.uploadId});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProcessingBloc>();
    bloc.add(StartPolling(widget.uploadId));

    // If the user reopens this screen after it already finished in the
    // background, the listener below won't fire (it only reacts to new
    // transitions) — so check the current state once up front too.
    final current = bloc.state;
    if (current is ProcessingCompleted && current.uploadId == widget.uploadId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _goToResults(current.uploadId));
    }
  }

  void _goToResults(String uploadId) {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ResultsScreen(uploadId: uploadId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: BlocConsumer<ProcessingBloc, ProcessingState>(
        listener: (context, state) {
          if (state is ProcessingCompleted && state.uploadId == widget.uploadId) {
            _goToResults(state.uploadId);
          }
        },
        builder: (context, state) {
          if (state is ProcessingFailed && state.uploadId == widget.uploadId) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(state.message, style: AppTextStyles.bodyM.copyWith(color: AppColors.error), textAlign: TextAlign.center),
              ),
            );
          }

          final inProgress = (state is ProcessingInProgress && state.uploadId == widget.uploadId) ? state : null;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: PrismCard(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _WaveformPulse(),
                    const SizedBox(height: 24),
                    if (inProgress != null)
                      ProgressStepList(completedSteps: inProgress.completedSteps, currentStep: inProgress.step),
                    const SizedBox(height: 16),
                    Text(
                      inProgress != null ? '~${inProgress.etaSeconds}s remaining' : 'Starting…',
                      style: AppTextStyles.bodyM,
                    ),
                    if (inProgress?.delayed ?? false) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: AppColors.bgSurface,
                        child: Text(
                          "This is taking longer than usual. Still working — we'll email you the moment it's ready.",
                          style: AppTextStyles.bodyS.copyWith(color: AppColors.warning),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Continue in background', style: AppTextStyles.dataLabel.copyWith(color: AppColors.cyan)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WaveformPulse extends StatefulWidget {
  const _WaveformPulse();

  @override
  State<_WaveformPulse> createState() => _WaveformPulseState();
}

class _WaveformPulseState extends State<_WaveformPulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(12, (i) {
              final phase = (_controller.value + i / 12) % 1.0;
              final height = 8 + 32 * (0.5 + 0.5 * (phase < 0.5 ? phase * 2 : (1 - phase) * 2));
              return Container(
                width: 4,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                color: AppColors.cyan.withOpacity(0.6),
              );
            }),
          ),
        );
      },
    );
  }
}
