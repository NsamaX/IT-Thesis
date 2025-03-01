part of 'cubit.dart';

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
Ndef validateNDEF(NfcTag tag) {
  final ndef = Ndef.from(tag);
  if (ndef == null) {
    throw Exception('[Validation] Tag does not support NDEF.');
  }
  if (!ndef.isWritable) {
    throw Exception('[Validation] Tag is read-only.');
  }
  return ndef;
}

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
List<String> parseNDEFRecords(Ndef ndef) {
  final message = ndef.cachedMessage;
  if (message == null || message.records.isEmpty) {
    throw Exception('[Validation] No NDEF message found.');
  }
  return message.records.map((record) => String.fromCharCodes(record.payload).substring(3)).toList();
}

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
TagEntity createTagEntity(NfcTag tag, List<String> records) {
  final game = records.firstWhere((r) => r.startsWith('game:'), orElse: () => '').split(': ').last;
  final cardId = records.firstWhere((r) => r.startsWith('id:'), orElse: () => '').split(': ').last;
  final tagId = (tag.data['nfca']?['identifier'] as List<dynamic>?)
              ?.map((e) => e.toRadixString(16).padLeft(2, '0'))
              .join(':') ?? '';
  if (game.isEmpty || cardId.isEmpty || tagId.isEmpty) {
    throw Exception('[Validation] Incomplete tag data.');
  }
  return TagEntity(tagId: tagId, cardId: cardId, game: game);
}

/*--------------------------------------------------------------------------------
 |
 |
 |
 |
 |
 |
 |
 |
 |
 |
 *-------------------------------------------------------------------------------*/
NdefMessage createNDEFMessage(CardEntity card) {
  final message = NdefMessage([
    NdefRecord.createText('game: ${card.game}'),
    NdefRecord.createText('id: ${card.cardId}'),
  ]);
  if (message.byteLength > 144) {
    throw Exception('[Validation] Data exceeds tag capacity.');
  }
  return message;
}
