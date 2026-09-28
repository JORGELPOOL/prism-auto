import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auto_repository.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final AutoRepository repository;

  LibraryBloc(this.repository) : super(const LibraryInitial()) {
    on<LoadLibrary>(_onLoad);
    on<RefreshLibrary>(_onRefresh);
  }

  Future<void> _onLoad(LoadLibrary event, Emitter<LibraryState> emit) async {
    emit(const LibraryLoading());
    try {
      final uploads = await repository.getLibrary();
      emit(LibraryLoaded(uploads));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }

  Future<void> _onRefresh(RefreshLibrary event, Emitter<LibraryState> emit) async {
    final current = state;
    if (current is LibraryLoaded) {
      emit(LibraryLoaded(current.uploads, isRefreshing: true));
    }
    try {
      final uploads = await repository.getLibrary();
      emit(LibraryLoaded(uploads));
    } catch (e) {
      emit(LibraryError(e.toString()));
    }
  }
}
