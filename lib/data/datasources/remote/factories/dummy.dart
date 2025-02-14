import '../../../models/card.dart';
import '../game_factory.dart';

class DummyApi implements GameApi {
  @override
  Future<CardModel> fetchCardsById(String id) async {
    throw Exception('Dummy API does not support fetching cards.');
  }

  @override
  Future<List<CardModel>> fetchCardsPage(int page) async {
    throw Exception('Dummy API does not support pagination.');
  }
}
