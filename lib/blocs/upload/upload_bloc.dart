import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auto_repository.dart';
import 'upload_event.dart';
import 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final AutoRepository repository;

  UploadBloc(this.repository) : super(const UploadIdle()) {
    on<FileSelected>(_onFileSelected);
    on<LinkPasted>(_onLinkPasted);
    on<UploadStarted>(_onUploadStarted);
    on<UploadReset>((event, emit) => emit(const UploadIdle()));
  }

  Future<void> _onFileSelected(FileSelected event, Emitter<UploadState> emit) async {
    final remainingMinutes = repository.minutesLimit() - repository.minutesUsed();
    if (event.durationSeconds / 60 > remainingMinutes) {
      emit(const UploadError('This file exceeds your remaining minutes for this month.'));
      return;
    }
    emit(UploadFilePicked(event.filename, event.durationSeconds));
  }

  Future<void> _onLinkPasted(LinkPasted event, Emitter<UploadState> emit) async {
    emit(UploadFilePicked(event.url, 600));
  }

  Future<void> _onUploadStarted(UploadStarted event, Emitter<UploadState> emit) async {
    final current = state;
    if (current is! UploadFilePicked) return;
    await emit.forEach<double>(
      repository.uploadProgress(),
      onData: (progress) => UploadUploading(current.filename, current.durationSeconds, progress),
    );
    try {
      final upload = await repository.startUpload(current.filename, current.durationSeconds);
      emit(UploadDone(upload.id));
    } catch (e) {
      emit(UploadError(e.toString()));
    }
  }
}
