import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/record.dart';
import 'labels/setting.dart';

class HistoryWidget extends StatelessWidget {
  final List<RecordEntity> records;
  final void Function(BuildContext context, String recordId)? selectRecord;

  const HistoryWidget({
    Key? key,
    required this.records,
    this.selectRecord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final dateFormatter = DateFormat('yyyy-MM-dd');
    final timeFormatter = DateFormat('HH:mm:ss');

    return SettingLabelWidget(
      label: [
        {
          'title': locale.translate('settings.account.label'),
          'content': records.map((record) => {
            'onTap': () => selectRecord?.call(context, record.recordId),
            'text': dateFormatter.format(record.createdAt),
            'info': timeFormatter.format(record.createdAt),
            'arrow': true,
          }).toList(),
        },
      ],
    );
  }
}
