import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import 'package:nfc_project/domain/entities/record.dart';

import '../shared/general_label.dart';

class GameHistoryWidget extends StatelessWidget {
  final List<RecordEntity> records;
  final void Function(BuildContext context, String recordId)? selectRecord;

  const GameHistoryWidget({
    super.key,
    required this.records,
    this.selectRecord,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) return const SizedBox.shrink();

    return GeneralLabelWidget(
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
