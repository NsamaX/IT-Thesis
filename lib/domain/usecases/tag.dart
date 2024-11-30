import '../../data/repositories/tag.dart';
import '../entities/tag.dart';

class SaveTagUseCase {
  final TagRepository repository;

  SaveTagUseCase(this.repository);

  Future<void> call(TagEntity tagEntity) async {
    await repository.saveTag(tagEntity);
  }
}

class LoadTagsUseCase {
  final TagRepository repository;

  LoadTagsUseCase(this.repository);

  Future<List<TagEntity>> call() async {
    return await repository.loadTags();
  }
}
