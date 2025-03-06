import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/usecases/collection.dart';

class CollectionState extends Equatable {
  final List<CardEntity> collection;
  final String name;
  final String description;
  final String? imageUrl;

  const CollectionState({
    this.collection = const [],
    this.name = '',
    this.description = '',
    this.imageUrl,
  });

  bool get isValid => name.isNotEmpty && description.isNotEmpty;

  CollectionState copyWith({
    List<CardEntity>? collection,
    String? name,
    String? description,
    String? imageUrl,
  }) {
    return CollectionState(
      collection: collection ?? this.collection,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [collection, name, description, imageUrl];
}

class CollectionCubit extends Cubit<CollectionState> {
  final AddCardToCollectionUseCase addCardUseCase;
  final RemoveCardFromCollectionUseCase removeCardUseCase;
  final FetchCollectionUseCase fetchCollectionUseCase;

  CollectionCubit({
    required this.addCardUseCase,
    required this.removeCardUseCase,
    required this.fetchCollectionUseCase,
  }) : super(const CollectionState());

  void safeEmit(CollectionState newState) {
    if (!isClosed && state != newState) {
      emit(newState);
    }
  }

  void setName(String name) => safeEmit(state.copyWith(name: name));

  void setDescription(String description) => safeEmit(state.copyWith(description: description));

  void setImageUrl(String? imageUrl) => safeEmit(state.copyWith(imageUrl: imageUrl));

  void clear() {
    safeEmit(const CollectionState());
  }

  Future<void> addCard() async {
    if (!state.isValid) return;

    try {
      final newCardId = await _generateNewCardId();
      final newCard = CardEntity(
        cardId: newCardId,
        game: 'my_collection',
        name: state.name,
        imageUrl: state.imageUrl,
        description: state.description,
      );

      await addCardUseCase(newCard);
      await fetchCollection();
    } catch (e) {
      print('Error adding card: $e');
    }
  }

  Future<void> removeCard(String cardId) async {
    try {
      await removeCardUseCase(cardId);
      safeEmit(state.copyWith(
        collection: state.collection.where((card) => card.cardId != cardId).toList(),
      ));
    } catch (e) {
      print('Error removing card: $e');
    }
  }

  Future<void> fetchCollection() async {
    try {
      final cards = await fetchCollectionUseCase();
      safeEmit(state.copyWith(collection: cards));
    } catch (e) {
      print('Error fetching collection: $e');
    }
  }

  Future<String> _generateNewCardId() async {
    try {
      final cards = await fetchCollectionUseCase();
      final existingIds = cards.map((card) => int.tryParse(card.cardId) ?? 0).toSet();
      int newId = 1;
      while (existingIds.contains(newId)) {
        newId++;
      }
      return newId.toString();
    } catch (e) {
      print('Error generating new card ID: $e');
      return '1';
    }
  }
}
