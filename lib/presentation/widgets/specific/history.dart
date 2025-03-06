import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import 'package:nfc_project/domain/entities/record.dart';

import '../shared/setting_label.dart';

class HistoryWidget extends StatelessWidget {
  final List<RecordEntity> records;
  final void Function(BuildContext context, String recordId)? selectRecord;

  const HistoryWidget({
    super.key,
    required this.records,
    this.selectRecord,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const SizedBox.shrink();

    return SettingLabelWidget(
      label: _buildHistoryList(context),
    );
  }

  List<Map<String, dynamic>> _buildHistoryList(
    BuildContext context,
  ) {
    final locale = AppLocalizations.of(context);
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final timeFormatter = DateFormat('HH:mm:ss');

    return [
      {
        'title': locale.translate('settings.account.label'),
        'content': records.map((record) {
          return {
            'onTap': () => selectRecord?.call(context, record.recordId),
            'text': dateFormatter.format(record.createdAt),
            'info': timeFormatter.format(record.createdAt),
            'arrow': true,
          };
        }).toList(),
      },
    ];
  }
}
