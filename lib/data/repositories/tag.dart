import '../datasources/local/tag.dart';
import '../models/tag.dart';
import '../models/card.dart';

abstract class TagRepository {
  Future<void> saveTagWithCard(TagModel tagEntity, CardModel cardEntity);
  Future<List<Map<String, dynamic>>> loadTagsWithCards();
}

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource localDataSource;

  TagRepositoryImpl(this.localDataSource);

  @override
  Future<void> saveTagWithCard(TagModel tagModel, CardModel cardModel) async {
    await localDataSource.saveTagWithCard(tagModel, cardModel);
  }

  @override
  Future<List<Map<String, dynamic>>> loadTagsWithCards() async {
    return await localDataSource.loadTagsWithCards();
  }
}
