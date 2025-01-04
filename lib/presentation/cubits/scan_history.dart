import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/entities/tag.dart';

class ScanHistoryState {
  final String? errorMessage;

  ScanHistoryState({this.errorMessage});

  ScanHistoryState copyWith({
    List<Map<TagEntity, CardEntity>>? savedTags,
    String? errorMessage,
  }) {
    return ScanHistoryState(errorMessage: errorMessage ?? this.errorMessage);
  }
}

class ScanHistoryCubit extends Cubit<ScanHistoryState> {
  final Logger logger = Logger();

  ScanHistoryCubit() : super(ScanHistoryState());

  Future<void> loadTags() async {}

  void clearErrorMessage() {
    emit(state.copyWith(errorMessage: null));
  }
}
