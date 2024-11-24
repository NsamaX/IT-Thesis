import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../core/locales/localizations.dart';
import '../../../core/routes/route.dart';
import '../../../domain/entities/deck.dart';
import '../../blocs/deck_manager.dart';
import '../../widgets/bar/app.dart';

class DeckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // ignore: unused_local_variable
    final deck = arguments?['deck'] ??
        DeckEntity(
          deckId: Uuid().v4(),
          deckName: AppLocalizations.of(context).translate('new_deck_title'),
          cards: [],
        );
    return BlocProvider(
      create: (context) => DeckMangerCubit(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBarWidget(
              menu: !context.watch<DeckMangerCubit>().state.isEditMode
                  ? {
                      Icons.window_rounded: () => Navigator.of(context).pop(),
                      Icons.upload_rounded: () =>
                          context.read<DeckMangerCubit>().toggleShare(),
                      AppLocalizations.of(context).translate('new_deck_title'):
                          null,
                      Icons.play_arrow_rounded: AppRoutes.track,
                      Icons.build_outlined: () =>
                          context.read<DeckMangerCubit>().toggleEditMode(),
                    }
                  : {
                      Icons.nfc_rounded: () =>
                          context.read<DeckMangerCubit>().toggleNfcRead(),
                      Icons.delete_rounded: () =>
                          context.read<DeckMangerCubit>().toggleDelete(),
                      AppLocalizations.of(context).translate('new_deck_title'):
                          null,
                      Icons.search_rounded: {
                        'route': AppRoutes.other,
                        'arguments': {'addCard': true}
                      },
                      Icons.build_outlined: () =>
                          context.read<DeckMangerCubit>().toggleEditMode(),
                    },
            ),
          );
        },
      ),
    );
  }
}
