import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import '../cubits/deck_manager.dart';
import '../cubits/NFC.dart';
import '../widgets/grid.dart';
import '../widgets/app_bar.dart';
import '../widgets/notifications.dart';

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
    _nfcCubit = context.read<NFCCubit>();
    _nfcSessionHandler = NFCSessionHandler(_nfcCubit);
    _nfcSessionHandler.initNFCSessionHandler();
  }

  @override
  void dispose() {
    _nfcSessionHandler.disposeNFCSessionHandler();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final cubit = context.read<DeckManagerCubit>();
    final deck = cubit.state.deck;
    final TextEditingController deckNameController = TextEditingController(text: deck.deckName);
    return BlocListener<NFCCubit, NFCState>(
      listener: (context, state) {
        if (state.isWriteOperation && 
            (state.isOperationSuccessful || state.errorMessage.isNotEmpty) &&
            !state.isSnackBarDisplayed) {
          _handleSnackBar(context, cubit, state);
        }
      },
      child: Scaffold(
        appBar: AppBarWidget(menu: _buildMenu(context, cubit, locale, deckNameController)),
        body: _buildGridView(context, cubit, locale),
      ),
    );
  }

  void _handleSnackBar(BuildContext context, DeckManagerCubit cubit, NFCState state) async {
    final locale = AppLocalizations.of(context);
    _nfcCubit.markSnackBarDisplayed();
    if (state.isOperationSuccessful) {
      final successMessage = locale.translate('snack_bar.nfc.write_success');
      await snackBar(
        context,
        content: successMessage,
      );
      _nfcCubit.resetOperationStatus();
    } else if (state.errorMessage.isNotEmpty) {
      final errorMessage = locale.translate('snack_bar.nfc.write_failed');
      await snackBar(
        context,
        content: errorMessage,
        isError: true,
      );
      _nfcCubit.clearErrorMessage();
      await _nfcCubit.restartSessionIfNeeded(card: cubit.state.selectedCard);
    }
    _nfcCubit.resetSnackBarState();
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
        locale.translate('toggle.edit'): () => cubit.toggleEditMode(),
      };
    }
    return isEditMode
        ? {
            Icons.nfc_rounded: () => cubit.toggleNfcRead(_nfcCubit),
            Icons.delete_outline_rounded: () => _showDeleteDialog(context, cubit, locale),
            TextField(
              controller: deckNameController,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: locale.translate('title.new_deck'),
              ),
              onSubmitted: (value) => _renameDeck(cubit, deckNameController, locale, value),
            ): null,
            Icons.add_rounded: {
              'route': AppRoutes.games,
              'arguments': {'isAdd': true},
            },
            locale.translate('toggle.save'): () {
              cubit.saveDeck(_nfcCubit);
              cubit.toggleEditMode();
            },
          }
        : {
            Icons.arrow_back_ios_new_rounded: '/back',
            Icons.ios_share_rounded: () => _toggleShare(context, cubit, locale),
            state.deck.deckName: null,
            Icons.play_arrow_rounded: AppRoutes.tracker,
            locale.translate('toggle.edit'): () => cubit.toggleEditMode(),
          };
  }

  void _showDeleteDialog(
    BuildContext context,
    DeckManagerCubit cubit,
    AppLocalizations locale,
  ) {
    cupertinoAlertDialogAction(
      context,
      title: locale.translate('dialog.deck.title'),
      content: locale.translate('dialog.deck.content'),
      onConfirm: () {
        cubit.toggleDelete();
        snackBar(
          context,
          content: locale.translate('snack_bar.deck.deleted'),
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
        : locale.translate('title.new_deck');
    cubit.renameDeck(newName);
    controller.text = newName;
  }

  void _toggleShare(BuildContext context, DeckManagerCubit cubit, AppLocalizations locale) {
    cubit.toggleShare();
    snackBar(
      context,
      content: locale.translate('snack_bar.deck.share'),
    );
  }

  Widget _buildGridView(BuildContext context, DeckManagerCubit cubit, AppLocalizations locale) {
    final deckCards = cubit.state.deck.cards;
    if (deckCards.isEmpty) {
      return Center(
        child: Text(
          locale.translate('text.deck_empty'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return GridWidget(items: deckCards.entries.toList());
  }
}
