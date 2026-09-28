import 'package:equatable/equatable.dart';
import '../../models/upload_model.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();
  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {
  const LibraryInitial();
}

class LibraryLoading extends LibraryState {
  const LibraryLoading();
}

class LibraryLoaded extends LibraryState {
  final List<UploadModel> uploads;
  final bool isRefreshing;
  const LibraryLoaded(this.uploads, {this.isRefreshing = false});
  @override
  List<Object?> get props => [uploads, isRefreshing];
}

class LibraryError extends LibraryState {
  final String message;
  const LibraryError(this.message);
  @override
  List<Object?> get props => [message];
}
