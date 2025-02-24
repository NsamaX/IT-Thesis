import 'dart:convert';
import 'package:nfc_project/core/services/sqlite.dart';
import '../../models/data.dart';
import '../../models/record.dart';

abstract class RecordLocalDataSource {
  Future<void> saveRecord(RecordModel card);
  Future<void> removeRecord(String cardId);
  Future<List<RecordModel>> fetchRecord();
}

class RecordLocalDataSourceImpl implements RecordLocalDataSource {
  final SQLiteService _sqliteService;

  static const String recordTable = 'records';
  static const String columnRecordId = 'recordId';
  static const String columnCreatedAt = 'createdAt';
  static const String columnData = 'data';

  RecordLocalDataSourceImpl(this._sqliteService);

  @override
  Future<void> saveRecord(RecordModel record) async {
    await _sqliteService.insert(
      recordTable,
      {
        columnRecordId: record.recordId,
        columnCreatedAt: record.createdAt.toIso8601String(),
        columnData: json.encode(record.data),
      },
    );
  }

  @override
  Future<void> removeRecord(String recordId) async {
    await _sqliteService.delete(
      recordTable,
      columnRecordId,
      recordId,
    );
  }

  @override
  Future<List<RecordModel>> fetchRecord() async {
    final result = await _sqliteService.query(recordTable);
    return result.map((row) {
      final List<dynamic> recordDataList = json.decode(row[columnData]);
      return RecordModel(
        recordId: row[columnRecordId],
        createdAt: DateTime.parse(row[columnCreatedAt]),
        data: recordDataList.map((e) => DataModel.fromJson(e)).toList(),
      );
    }).toList();
  }
}
