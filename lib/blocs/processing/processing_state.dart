import 'package:equatable/equatable.dart';
import '../../repositories/auto_repository.dart';

abstract class ProcessingState extends Equatable {
  const ProcessingState();
  @override
  List<Object?> get props => [];
}

/// No upload currently polling — nothing for the shell's persistent
/// indicator to show.
class ProcessingIdle extends ProcessingState {
  const ProcessingIdle();
}

class ProcessingInProgress extends ProcessingState {
  final String uploadId;
  final ProcessingStepName step;
  final int etaSeconds;
  final List<ProcessingStepName> completedSteps;
  final bool delayed;

  const ProcessingInProgress({
    required this.uploadId,
    required this.step,
    required this.etaSeconds,
    required this.completedSteps,
    this.delayed = false,
  });

  @override
  List<Object?> get props => [uploadId, step, etaSeconds, completedSteps, delayed];
}

class ProcessingCompleted extends ProcessingState {
  final String uploadId;
  const ProcessingCompleted(this.uploadId);
  @override
  List<Object?> get props => [uploadId];
}

class ProcessingFailed extends ProcessingState {
  final String message;
  final String uploadId;
  const ProcessingFailed(this.message, {required this.uploadId});
  @override
  List<Object?> get props => [message, uploadId];
}
