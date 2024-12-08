import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nfc_project/core/utils/exception.dart';
import '../../models/tag.dart';
import '../../models/card.dart';

abstract class TagLocalDataSource {
  Future<List<Map<String, dynamic>>> loadTags();
  Future<void> saveTag(TagModel tagModel, CardModel cardModel);
  Future<void> deleteTags();
}

class TagLocalDataSourceImpl implements TagLocalDataSource {
  static const String _tagsWithCardsKey = 'tags';

  final SharedPreferences sharedPreferences;

  TagLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<Map<String, dynamic>>> loadTags() async {
    try {
      final List<String> tags = sharedPreferences.getStringList(_tagsWithCardsKey) ?? [];
      return tags.map((tag) {
        final Map<String, dynamic> jsonData = json.decode(tag);
        return {
          'tag': TagModel.fromJson(jsonData['tag']),
          'card': CardModel.fromJson(jsonData['card']),
        };
      }).toList();
    } catch (e) {
      throw LocalDataException('Failed to load tags with cards', details: e.toString());
    }
  }

  @override
  Future<void> saveTag(TagModel tagModel, CardModel cardModel) async {
    try {
      final List<String> tags = sharedPreferences.getStringList(_tagsWithCardsKey) ?? [];
      final Map<String, dynamic> tagWithCard = {
        'tag': tagModel.toJson(),
        'card': cardModel.toJson(),
      };
      tags.add(json.encode(tagWithCard));
      await sharedPreferences.setStringList(_tagsWithCardsKey, tags);
    } catch (e) {
      throw LocalDataException('Failed to save tag with card', details: e.toString());
    }
  }

  @override
  Future<void> deleteTags() async {
    try {
      await sharedPreferences.remove(_tagsWithCardsKey);
    } catch (e) {
      throw LocalDataException('Failed to delete tags', details: e.toString());
    }
  }
}
