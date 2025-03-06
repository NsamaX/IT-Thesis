part of 'cubit.dart';

Ndef validateNDEF(NfcTag tag) {
  try {
    final ndef = Ndef.from(tag);
    if (ndef == null) throw Exception('[Validation] Tag does not support NDEF.');
    if (!ndef.isWritable) throw Exception('[Validation] Tag is read-only.');
    return ndef;
  } catch (e) {
    throw Exception('[Validation] Failed to validate NDEF tag: $e');
  }
}

List<String> parseNDEFRecords(Ndef ndef) {
  try {
    final message = ndef.cachedMessage;
    if (message == null || message.records.isEmpty) {
      throw Exception('[Validation] No NDEF message found.');
    }
    return message.records
        .map((record) => String.fromCharCodes(record.payload).substring(3))
        .toList();
  } catch (e) {
    throw Exception('[Validation] Failed to parse NDEF records: $e');
  }
}

TagEntity createTagEntity(NfcTag tag, List<String> records) {
  try {
    final game = records.firstWhere((r) => r.startsWith('game:'), orElse: () => 'game:').split(': ').last;
    final cardId = records.firstWhere((r) => r.startsWith('id:'), orElse: () => 'id:').split(': ').last;

    final tagId = (tag.data['nfca']?['identifier'] as List<dynamic>?)
        ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
        .join(':') ?? '';

    if (game.isEmpty || cardId.isEmpty || tagId.isEmpty) {
      throw Exception('[Validation] Incomplete tag data.');
    }

    return TagEntity(tagId: tagId, cardId: cardId, game: game);
  } catch (e) {
    throw Exception('[Validation] Failed to create tag entity: $e');
  }
}

NdefMessage createNDEFMessage(CardEntity card) {
  try {
    final records = [
      NdefRecord.createText('game: ${card.game}'),
      NdefRecord.createText('id: ${card.cardId}'),
    ];

    final message = NdefMessage(records);

    if (message.byteLength > 144) {
      throw Exception('[Validation] Data exceeds tag capacity.');
    }

    return message;
  } catch (e) {
    throw Exception('[Validation] Failed to create NDEF message: $e');
  }
}
