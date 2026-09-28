import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auto_repository.dart';
import 'processing_event.dart';
import 'processing_state.dart';

class ProcessingBloc extends Bloc<ProcessingEvent, ProcessingState> {
  final AutoRepository repository;

  ProcessingBloc(this.repository)
      : super(const ProcessingInProgress(
          step: ProcessingStepName.transcribing,
          etaSeconds: 45,
          completedSteps: [],
        )) {
    on<StartPolling>(_onStartPolling);
  }

  Future<void> _onStartPolling(StartPolling event, Emitter<ProcessingState> emit) async {
    final completed = <ProcessingStepName>[];
    try {
      await emit.forEach<ProcessingStep>(
        repository.processingSteps(event.uploadId),
        onData: (step) {
          completed.add(step.step);
          return ProcessingInProgress(
            step: step.step,
            etaSeconds: step.etaSeconds,
            completedSteps: List.of(completed),
          );
        },
      );
      emit(ProcessingCompleted(event.uploadId));
    } catch (e) {
      emit(ProcessingFailed(e.toString()));
    }
  }
}
