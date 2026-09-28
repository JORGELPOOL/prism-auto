import 'package:equatable/equatable.dart';

abstract class ProcessingEvent extends Equatable {
  const ProcessingEvent();
  @override
  List<Object?> get props => [];
}

class StartPolling extends ProcessingEvent {
  final String uploadId;
  const StartPolling(this.uploadId);
  @override
  List<Object?> get props => [uploadId];
}
