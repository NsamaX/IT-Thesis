import 'dart:convert';
import 'package:nfc_project/core/services/shared_preferences.dart';
import '../../models/tag.dart';
import '../../models/card.dart';

abstract class TagLocalDataSource {
  Future<List<Map<String, dynamic>>> loadTags();
  Future<void> saveTag(TagModel tagModel, CardModel cardModel);
  Future<void> deleteTags();
}

class TagLocalDataSourceImpl implements TagLocalDataSource {
  static const String _tagsKey = 'tags';

  final SharedPreferencesService _sharedPreferencesService;

  TagLocalDataSourceImpl(this._sharedPreferencesService);

  @override
  Future<List<Map<String, dynamic>>> loadTags() async {
    final List<String>? tagsList = _sharedPreferencesService.getStringList(_tagsKey);
    if (tagsList == null) return [];
    return tagsList.map((tag) {
      final Map<String, dynamic> jsonData = json.decode(tag);
      return {
        'tag': TagModel.fromJson(jsonData['tag']),
        'card': CardModel.fromJson(jsonData['card']),
      };
    }).toList();
  }

  @override
  Future<void> saveTag(TagModel tagModel, CardModel cardModel) async {
    final List<String>? tagsList = _sharedPreferencesService.getStringList(_tagsKey) ?? [];
    final Map<String, dynamic> tagWithCard = {
      'tag': tagModel.toJson(),
      'card': cardModel.toJson(),
    };
    tagsList?.add(json.encode(tagWithCard));
    await _sharedPreferencesService.saveStringList(_tagsKey, tagsList!);
  }

  @override
  Future<void> deleteTags() async {
    await _sharedPreferencesService.clearKey(_tagsKey);
  }
}
