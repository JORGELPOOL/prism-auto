import 'package:equatable/equatable.dart';
import '../../repositories/auto_repository.dart';

abstract class ProcessingState extends Equatable {
  const ProcessingState();
  @override
  List<Object?> get props => [];
}

class ProcessingInProgress extends ProcessingState {
  final ProcessingStepName step;
  final int etaSeconds;
  final List<ProcessingStepName> completedSteps;
  final bool delayed;

  const ProcessingInProgress({
    required this.step,
    required this.etaSeconds,
    required this.completedSteps,
    this.delayed = false,
  });

  @override
  List<Object?> get props => [step, etaSeconds, completedSteps, delayed];
}

class ProcessingCompleted extends ProcessingState {
  final String uploadId;
  const ProcessingCompleted(this.uploadId);
  @override
  List<Object?> get props => [uploadId];
}

class ProcessingFailed extends ProcessingState {
  final String message;
  const ProcessingFailed(this.message);
  @override
  List<Object?> get props => [message];
}
