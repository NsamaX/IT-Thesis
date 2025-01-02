import '../datasources/local/tag.dart';
import '../models/tag.dart';
import '../models/card.dart';

abstract class TagRepository {
  /// ดึงข้อมูลแท็กทั้งหมดที่บันทึกไว้
  Future<List<Map<String, dynamic>>> loadTags();

  /// บันทึกแท็กใหม่พร้อมการ์ดที่เชื่อมโยง
  Future<void> saveTag(TagModel tagEntity, CardModel cardEntity);

  /// ลบข้อมูลแท็กทั้งหมดที่บันทึกไว้
  Future<void> deleteTags();
}

class TagRepositoryImpl implements TagRepository {
  final TagLocalDataSource localDataSource;

  TagRepositoryImpl(this.localDataSource);

  @override
  Future<List<Map<String, dynamic>>> loadTags() async {
    return await localDataSource.loadTags();
  }

  @override
  Future<void> saveTag(TagModel tagModel, CardModel cardModel) async {
    await localDataSource.saveTag(tagModel, cardModel);
  }

  @override
  Future<void> deleteTags() async {
    await localDataSource.deleteTags();
  }
}
