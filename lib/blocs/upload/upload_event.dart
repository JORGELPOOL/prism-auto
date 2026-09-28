import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();
  @override
  List<Object?> get props => [];
}

class FileSelected extends UploadEvent {
  final String filename;
  final int durationSeconds;
  const FileSelected(this.filename, this.durationSeconds);
  @override
  List<Object?> get props => [filename, durationSeconds];
}

class LinkPasted extends UploadEvent {
  final String url;
  const LinkPasted(this.url);
  @override
  List<Object?> get props => [url];
}

class UploadStarted extends UploadEvent {
  const UploadStarted();
}

class UploadReset extends UploadEvent {
  const UploadReset();
}
