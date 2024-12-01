import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/locales/localizations.dart';
import '../../blocs/NFC.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/card/card.dart';

class MyCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.arrow_back_ios_new_rounded: '/back',
          AppLocalizations.of(context).translate('my_card.title'): null,
          null: null,
        },
      ),
      body: BlocBuilder<NFCCubit, NFCState>(
        builder: (context, state) {
          if (state.savedTags == null || state.savedTags!.isEmpty) {
            return Container();
          }

          final savedCards =
              state.savedTags!.map((map) => map.values.first).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: savedCards.length,
            itemBuilder: (context, index) {
              final card = savedCards[index];
              return CardWidget(card: card);
            },
          );
        },
      ),
    );
  }
}
