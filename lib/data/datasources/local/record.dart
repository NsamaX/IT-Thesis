import 'dart:convert';

import 'package:nfc_project/core/storage/sqlite.dart';

import '../../models/data.dart';
import '../../models/record.dart';

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
abstract class RecordLocalDataSource {
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
  Future<void> saveRecord(RecordModel record);

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
  Future<void> removeRecord(String recordId);

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
  Future<List<RecordModel>> fetchRecord();
}

class RecordLocalDataSourceImpl implements RecordLocalDataSource {
  final SQLiteService _sqliteService;

  static const String _recordTable = 'records';
  static const String _columnRecordId = 'recordId';
  static const String _columnCreatedAt = 'createdAt';
  static const String _columnData = 'data';

  RecordLocalDataSourceImpl(this._sqliteService);

  @override
  Future<void> saveRecord(RecordModel record) async {
    await _sqliteService.insert(
      _recordTable,
      {
        _columnRecordId: record.recordId,
        _columnCreatedAt: record.createdAt.toIso8601String(),
        _columnData: json.encode(record.data),
      },
    );
  }

  @override
  Future<void> removeRecord(String recordId) async {
    await _sqliteService.delete(
      _recordTable,
      _columnRecordId,
      recordId,
    );
  }

  @override
  Future<List<RecordModel>> fetchRecord() async {
    final result = await _sqliteService.query(_recordTable);
    return result.map((row) {
      final List<dynamic> recordDataList = json.decode(row[_columnData]);
      return RecordModel(
        recordId: row[_columnRecordId],
        createdAt: DateTime.parse(row[_columnCreatedAt]),
        data: recordDataList.map((e) => DataModel.fromJson(e)).toList(),
      );
    }).toList();
  }
}
