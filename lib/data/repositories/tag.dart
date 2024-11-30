import '../datasources/local/tag.dart';
import '../models/tag.dart';
import '../../domain/entities/tag.dart';

abstract class TagRepository {
  Future<void> saveTag(TagEntity tagEntity);
  Future<List<TagEntity>> loadTags();
}

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource localDataSource;

  TagRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveTag(TagEntity tagEntity) async {
    final tagModel = TagModel(
      tagId: tagEntity.tagId,
      cardId: tagEntity.cardId,
      game: tagEntity.game,
      timestamp: tagEntity.timestamp,
    );
    await localDataSource.saveTag(tagModel);
  }

  @override
  Future<List<TagEntity>> loadTags() async {
    final tagModels = await localDataSource.loadTags();
    return tagModels
        .map((tagModel) => TagEntity(
              tagId: tagModel.tagId,
              cardId: tagModel.cardId,
              game: tagModel.game,
              timestamp: tagModel.timestamp,
            ))
        .toList();
  }
}
