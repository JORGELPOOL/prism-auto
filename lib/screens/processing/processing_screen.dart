import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/processing/processing_bloc.dart';
import '../../blocs/processing/processing_event.dart';
import '../../blocs/processing/processing_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../repositories/auto_repository.dart';
import '../../widgets/auto/progress_step_list.dart';
import '../../widgets/common/prism_card.dart';
import '../results/results_screen.dart';

/// SCREEN 2: Processing. The highest-trust screen in the product — a
/// subtle animated waveform instead of a generic spinner, named sequential
/// steps, a live ETA, and a non-alarming delay message if this runs long.
class ProcessingScreen extends StatelessWidget {
  final String uploadId;
  const ProcessingScreen({super.key, required this.uploadId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProcessingBloc(context.read<AutoRepository>())..add(StartPolling(uploadId)),
      child: Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: BlocConsumer<ProcessingBloc, ProcessingState>(
          listener: (context, state) {
            if (state is ProcessingCompleted) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (_) => ResultsScreen(uploadId: state.uploadId),
              ));
            }
          },
          builder: (context, state) {
            if (state is ProcessingFailed) {
              return Center(
                child: Text(state.message, style: AppTextStyles.bodyM.copyWith(color: AppColors.error)),
              );
            }
            final inProgress = state is ProcessingInProgress ? state : null;
            final delayed = inProgress?.delayed ?? false;

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
                        inProgress != null ? '~${inProgress.etaSeconds}s remaining' : '',
                        style: AppTextStyles.bodyM,
                      ),
                      if (delayed) ...[
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
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
