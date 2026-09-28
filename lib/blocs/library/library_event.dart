import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();
  @override
  List<Object?> get props => [];
}

class LoadLibrary extends LibraryEvent {
  const LoadLibrary();
}

class RefreshLibrary extends LibraryEvent {
  const RefreshLibrary();
}
