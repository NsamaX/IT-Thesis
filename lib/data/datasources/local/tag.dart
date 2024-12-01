import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/tag.dart';
import '../../models/card.dart';

abstract class TagLocalDataSource {
  Future<void> saveTagWithCard(TagModel tagModel, CardModel cardModel);
  Future<List<Map<String, dynamic>>> loadTagsWithCards();
}

class TagLocalDataSourceImpl implements TagLocalDataSource {
  static const String _tagsWithCardsKey = 'tags_with_cards';

  final SharedPreferences sharedPreferences;

  TagLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveTagWithCard(TagModel tagModel, CardModel cardModel) async {
    final List<String> tags = sharedPreferences.getStringList(_tagsWithCardsKey) ?? [];
    final Map<String, dynamic> tagWithCard = {
      'tag': tagModel.toJson(),
      'card': cardModel.toJson(),
    };
    tags.add(json.encode(tagWithCard));
    await sharedPreferences.setStringList(_tagsWithCardsKey, tags);
  }

  @override
  Future<List<Map<String, dynamic>>> loadTagsWithCards() async {
    final List<String> tags = sharedPreferences.getStringList(_tagsWithCardsKey) ?? [];
    return tags.map((tag) {
      final Map<String, dynamic> jsonData = json.decode(tag);
      return {
        'tag': TagModel.fromJson(jsonData['tag']),
        'card': CardModel.fromJson(jsonData['card']),
      };
    }).toList();
  }
}
