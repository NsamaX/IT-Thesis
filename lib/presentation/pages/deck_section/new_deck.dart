import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import '../../cubits/deck_manager.dart';
import '../../cubits/NFC.dart';
import '../../widgets/card/grid.dart';
import '../../widgets/dialog.dart';
import '../../widgets/navigation_bar/app.dart';

class NewDeckPage extends StatefulWidget {
  @override
  State<NewDeckPage> createState() => _NewDeckPageState();
}

class _NewDeckPageState extends State<NewDeckPage> with WidgetsBindingObserver {
  late final NFCCubit _nfcCubit;
  late final NFCSessionHandler _nfcSessionHandler;

  @override
  void initState() {
    super.initState();
    final nfcCubit = context.read<NFCCubit>();
    _nfcSessionHandler = NFCSessionHandler(nfcCubit);
    _nfcSessionHandler.initNFCSessionHandler();
  }

  @override
  void dispose() {
    _nfcSessionHandler.disposeNFCSessionHandler();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _nfcSessionHandler.handleAppLifecycleState(state);
  }

  void _handleSnackBar(BuildContext context, NFCState state) {
    debugPrint('SnackBar Handler Called: $state');
    final locale = AppLocalizations.of(context);
    if (state.isOperationSuccessful) {
      debugPrint('Operation Successful');
      showSnackBar(
        context: context,
        content: locale.translate('card.dialog.write_success'),
      );
      _nfcCubit.resetOperationStatus();
    } else if (state.errorMessage != null) {
      debugPrint('Error Message: ${state.errorMessage}');
      showSnackBar(
        context: context,
        content: locale.translate('card.dialog.write_fail'),
      );
      _nfcCubit.clearErrorMessage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<DeckManagerCubit>();
    final deck = cubit.state.deck;
    final TextEditingController deckNameController =
        TextEditingController(text: deck.deckName);

    return BlocListener<NFCCubit, NFCState>(
      listener: (context, state) {
        if (state.isOperationSuccessful) {
          _handleSnackBar(context, state);
        } else if (state.errorMessage != null) {
          _handleSnackBar(context, state);
        }
      },
      child: Scaffold(
        appBar: AppBarWidget(
            menu: _buildMenu(context, cubit, locale, deckNameController)),
        body: _buildGridView(context, cubit),
      ),
    );
  }

  Map<dynamic, dynamic> _buildMenu(
    BuildContext context,
    DeckManagerCubit cubit,
    AppLocalizations locale,
    TextEditingController deckNameController,
  ) {
    final state = context.watch<DeckManagerCubit>().state;
    final bool isEditMode = state.isEditMode;
    final bool hasCards = state.deck.cards.isNotEmpty;

    if (!isEditMode && !hasCards) {
      return {
        Icons.arrow_back_ios_new_rounded: '/back',
        state.deck.deckName: null,
        locale.translate('new_deck.toggle.edit'): () => cubit.toggleEditMode(),
      };
    }

    return isEditMode
        ? {
            Icons.nfc_rounded: () => cubit.toggleNfcRead(),
            Icons.delete_outline_rounded: () =>
                _showDeleteDialog(context, cubit, locale),
            TextField(
              controller: deckNameController,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: locale.translate('new_deck.title'),
              ),
              onSubmitted: (value) =>
                  _renameDeck(cubit, deckNameController, locale, value),
            ): null,
            Icons.add_rounded: {
              'route': AppRoutes.games,
              'arguments': {'isAdd': true},
            },
            locale.translate('new_deck.toggle.save'): () {
              cubit.saveDeck();
              cubit.toggleEditMode();
            },
          }
        : {
            Icons.arrow_back_ios_new_rounded: '/back',
            Icons.ios_share_rounded: () => _toggleShare(context, cubit, locale),
            state.deck.deckName: null,
            Icons.play_arrow_rounded: AppRoutes.tracker,
            locale.translate('new_deck.toggle.edit'): () =>
                cubit.toggleEditMode(),
          };
  }

  void _showDeleteDialog(
    BuildContext context,
    DeckManagerCubit cubit,
    AppLocalizations locale,
  ) {
    showCupertinoAlertCancel(
      context: context,
      title: locale.translate('new_deck.dialog.delete.title'),
      content: locale.translate('new_deck.dialog.delete.content'),
      onConfirm: () {
        cubit.toggleDelete();
        showSnackBar(
          context: context,
          content: locale.translate('new_deck.dialog.delete.success'),
        );
      },
    );
  }

  void _renameDeck(
    DeckManagerCubit cubit,
    TextEditingController controller,
    AppLocalizations locale,
    String value,
  ) {
    final newName = value.trim().isNotEmpty
        ? value.trim()
        : locale.translate('new_deck.title');
    cubit.renameDeck(newName);
    controller.text = newName;
  }

  void _toggleShare(
      BuildContext context, DeckManagerCubit cubit, AppLocalizations locale) {
    cubit.toggleShare();
    showSnackBar(
      context: context,
      content: locale.translate('new_deck.dialog.share'),
    );
  }

  Widget _buildGridView(BuildContext context, DeckManagerCubit cubit) {
    final deckCards = cubit.state.deck.cards;

    return GridWidget(items: deckCards.entries.toList());
  }
}
