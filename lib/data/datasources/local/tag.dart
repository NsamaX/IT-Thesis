import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/tag.dart';

abstract class TagLocalDataSource {
  Future<void> saveTag(TagModel tagModel);
  Future<List<TagModel>> loadTags();
}

class TagLocalDataSourceImpl implements TagLocalDataSource {
  final SharedPreferences sharedPreferences;

  TagLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveTag(TagModel tagModel) async {
    final List<String> tags = sharedPreferences.getStringList('tags') ?? [];
    tags.add(json.encode(tagModel.toJson()));
    await sharedPreferences.setStringList('tags', tags);
  }

  @override
  Future<List<TagModel>> loadTags() async {
    final List<String> tags = sharedPreferences.getStringList('tags') ?? [];
    return tags.map((tag) => TagModel.fromJson(json.decode(tag))).toList();
  }
}
