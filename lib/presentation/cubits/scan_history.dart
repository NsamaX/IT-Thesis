import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';
import 'package:nfc_project/domain/usecases/tag.dart';

class ScanHistoryState {
  final List<Map<TagEntity, CardEntity>>? savedTags;
  final String? errorMessage;

  ScanHistoryState({
    this.savedTags,
    this.errorMessage,
  });

  ScanHistoryState copyWith({
    List<Map<TagEntity, CardEntity>>? savedTags,
    String? errorMessage,
  }) {
    return ScanHistoryState(
      savedTags: savedTags ?? this.savedTags,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ScanHistoryCubit extends Cubit<ScanHistoryState> {
  final Logger logger = Logger();
  final LoadTagsUseCase loadTagsUseCase;

  ScanHistoryCubit({
    required this.loadTagsUseCase,
  }) : super(ScanHistoryState(savedTags: []));

  Future<void> loadTags() async {
    try {
      logger.i('Loading tags and cards...');
      final tagsWithCards = await loadTagsUseCase();
      emit(state.copyWith(savedTags: tagsWithCards));
      logger.i('Tags and cards loaded successfully.');
    } catch (e) {
      logger.e('Error loading tags and cards: $e');
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void clearErrorMessage() {
    emit(state.copyWith(errorMessage: null));
  }
}
