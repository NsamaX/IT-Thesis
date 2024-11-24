import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/locales/localizations.dart';
import '../../../domain/entities/card.dart';
import '../../blocs/deck_manager.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/card/details.dart';

class CardDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final card = arguments?['card'] as CardEntity?;
    final isAdd = arguments?['isAdd'] ?? false;
    final isCustom = arguments?['isCustom'] ?? false;
    return BlocProvider(
      create: (context) => DeckMangerCubit(),
      child: Scaffold(
        appBar: AppBarWidget(
          menu: {
            Icons.arrow_back_ios_new_rounded: '/back',
            AppLocalizations.of(context).translate('card_info_title'): null,
            if (isAdd)
              'Add': () {
                if (card != null) {
                  context.read<DeckMangerCubit>().addCard(card);
                }
              },
            if (isCustom) AppLocalizations.of(context).translate('save'): null,
            if (!isAdd && !isCustom) Icons.wifi_tethering_rounded: null,
          },
        ),
        body: CardDetailsWidget(card: card, isCustom: isCustom),
      ),
    );
  }
}
