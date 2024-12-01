import '../../data/repositories/tag.dart';
import '../entities/tag.dart';
import '../entities/card.dart';
import '../mappers/card.dart';
import '../mappers/tag.dart';

class SaveTagUseCase {
  final TagRepository repository;

  SaveTagUseCase(this.repository);

  Future<void> call(TagEntity tagEntity, CardEntity cardEntity) async {
    final tagModel = TagMapper.toModel(tagEntity);
    final cardModel = CardMapper.toModel(cardEntity);
    await repository.saveTagWithCard(tagModel, cardModel);
  }
}

class LoadTagsUseCase {
  final TagRepository repository;

  LoadTagsUseCase(this.repository);

  Future<List<Map<TagEntity, CardEntity>>> call() async {
    final rawTagsWithCards = await repository.loadTagsWithCards();

    return rawTagsWithCards.map((entry) {
      final tag = TagMapper.toEntity(entry['tag']);
      final card = CardMapper.toEntity(entry['card']);
      return {tag: card};
    }).toList();
  }
}
