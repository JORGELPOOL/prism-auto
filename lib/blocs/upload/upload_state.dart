import 'package:equatable/equatable.dart';

abstract class UploadState extends Equatable {
  const UploadState();
  @override
  List<Object?> get props => [];
}

class UploadIdle extends UploadState {
  const UploadIdle();
}

class UploadFilePicked extends UploadState {
  final String filename;
  final int durationSeconds;
  const UploadFilePicked(this.filename, this.durationSeconds);
  @override
  List<Object?> get props => [filename, durationSeconds];
}

class UploadUploading extends UploadState {
  final String filename;
  final int durationSeconds;
  final double progress;
  const UploadUploading(this.filename, this.durationSeconds, this.progress);
  @override
  List<Object?> get props => [filename, durationSeconds, progress];
}

class UploadDone extends UploadState {
  final String uploadId;
  const UploadDone(this.uploadId);
  @override
  List<Object?> get props => [uploadId];
}

class UploadError extends UploadState {
  final String message;
  const UploadError(this.message);
  @override
  List<Object?> get props => [message];
}
