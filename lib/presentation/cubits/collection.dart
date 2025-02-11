import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/usecases/collection.dart';

class CollectionState {
  final List<CardEntity> collection;
  final String name;
  final String description;
  final String? imageUrl;
  final bool isValid;
  
  CollectionState({
    required this.collection,
    this.name = '',
    this.description = '',
    this.imageUrl,
  }) : isValid = name.isNotEmpty && description.isNotEmpty;

  CollectionState copyWith({
    List<CardEntity>? collection,
    String? name,
    String? description,
    String? imageUrl,
  }) => CollectionState(
    collection: collection ?? this.collection,
    name: name ?? this.name,
    description: description ?? this.description,
    imageUrl: imageUrl ?? this.imageUrl,
  );
}

class CollectionCubit extends Cubit<CollectionState> {
  final AddCardToCollectionUseCase addCardUseCase;
  final RemoveCardFromCollectionUseCase removeCardUseCase;
  final FetchCollectionUseCase fetchCollectionUseCase;

  CollectionCubit({
    required this.addCardUseCase,
    required this.removeCardUseCase,
    required this.fetchCollectionUseCase,
  }) : super(CollectionState(collection: []));

  void setName(String name) => emit(state.copyWith(name: name));

  void setDescription(String description) => emit(state.copyWith(description: description));

  void setImageUrl(String? imageUrl) => emit(state.copyWith(imageUrl: imageUrl));

  Future<void> addCard() async {
    if (!state.isValid) return;
    final newCardId = _generateNewCardId();
    final newCard = CardEntity(
      cardId: newCardId,
      game: 'collection',
      name: state.name,
      imageUrl: state.imageUrl,
      description: state.description,
    );
    await addCardUseCase(newCard);
    emit(state.copyWith(collection: [...state.collection, newCard], name: '', description: '', imageUrl: null));
  }

  Future<void> removeCard(String cardId) async {
    await removeCardUseCase(cardId);
    emit(state.copyWith(
      collection: state.collection.where((card) => card.cardId != cardId).toList(),
    ));
  }

  Future<void> fetchCollection() async {
    final cards = await fetchCollectionUseCase();
    emit(state.copyWith(collection: cards));
  }

  String _generateNewCardId() {
    final existingIds = state.collection.map((card) => int.tryParse(card.cardId) ?? 0).toSet();
    int newId = 1;
    while (existingIds.contains(newId)) {
      newId++;
    }
    return newId.toString();
  }
}
