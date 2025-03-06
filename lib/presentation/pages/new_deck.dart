import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/core/services/locator.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';

import '../cubits/deck_management/cubit.dart';
import '../cubits/NFC/cubit.dart';

import '../widgets/shared/app_bar.dart';
import '../widgets/shared/deck_card_grid.dart';
import '../widgets/shared/notifications.dart';

import 'features/new_deck.dart';

class NewDeckPage extends StatefulWidget {
  @override
  State<NewDeckPage> createState() => _NewDeckPageState();
}

class _NewDeckPageState extends State<NewDeckPage> with WidgetsBindingObserver, RouteAware {
  late final NFCCubit _nfcCubit;
  late final NFCSessionHandler _nfcSessionHandler;
  late TextEditingController _deckNameController;

  /*-------------------------------- Lifecycle -------------------------------*/
  @override
  void initState() {
    super.initState();
    _nfcCubit = context.read<NFCCubit>();
    _nfcSessionHandler = NFCSessionHandler(_nfcCubit)..initNFCSessionHandler();
    _deckNameController = TextEditingController(text: context.read<DeckManagerCubit>().state.deck.deckName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    locator<RouteObserver<ModalRoute>>().subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    locator<RouteObserver<ModalRoute>>().unsubscribe(this);
    _nfcSessionHandler.disposeNFCSessionHandler();
    _deckNameController.dispose();
    super.dispose();
  }

  @override
  void didPushNext() {
    _nfcSessionHandler.disposeNFCSessionHandler();
  }

  @override
  void didPopNext() {
    _nfcSessionHandler.initNFCSessionHandler();
  }

  /*---------------------------------- Build ---------------------------------*/
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
        appBar: AppBarWidget(menu: _buildAppBarMenu(context, cubit, locale, deckNameController)),
        body: _buildGridView(context, cubit, locale),
      ),
    );
  }

  /*--------------------------------- App Bar --------------------------------*/
  Map<dynamic, dynamic> _buildAppBarMenu(BuildContext context, DeckManagerCubit cubit, AppLocalizations locale, TextEditingController deckNameController) {
    final state = context.watch<DeckManagerCubit>().state;
    final bool isEditModeEnabled = state.isEditModeEnabled;
    final bool hasCards = state.deck.cards.isNotEmpty;
    if (!isEditModeEnabled && !hasCards) {
      return {
        Icons.arrow_back_ios_new_rounded: '/back',
        state.deck.deckName: null,
        locale.translate('toggle.edit'): () => cubit.toggleEditMode(),
      };
    }
    return isEditModeEnabled
        ? {
            Icons.nfc_rounded: () => cubit.toggleNFC(_nfcCubit),
            Icons.delete_outline_rounded: () => showDeleteDialog(context, cubit, locale),
            TextField(
              controller: _deckNameController,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: locale.translate('title.new_deck'),
              ),
              onChanged: (value) => cubit.renameDeck(value.trim().isNotEmpty ? value.trim() : locale.translate('title.new_deck')),
              onSubmitted: (value) => renameDeck(cubit, _deckNameController, locale, value),
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
            Icons.ios_share_rounded: () => toggleShare(context, cubit, locale),
            state.deck.deckName: null,
            Icons.play_arrow_rounded: AppRoutes.deckTracker,
            locale.translate('toggle.edit'): () => cubit.toggleEditMode(),
          };
  }

  /*---------------------------------- Body ----------------------------------*/
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
    return DeckCardGridWidget(items: deckCards.entries.toList());
  }

  /*--------------------------------- Widgets --------------------------------*/
  void _handleSnackBar(BuildContext context, DeckManagerCubit cubit, NFCState state) async {
    final locale = AppLocalizations.of(context);
    _nfcCubit.markSnackBarDisplayed();
    if (state.isOperationSuccessful) {
      final successMessage = locale.translate('snack_bar.nfc.write_success');
      snackBar(
        context,
        successMessage,
      );
      _nfcCubit.resetOperationStatus();
    } else if (state.errorMessage.isNotEmpty) {
      final errorMessage = locale.translate('snack_bar.nfc.write_failed');
      snackBar(
        context,
        errorMessage,
        isError: true,
      );
      _nfcCubit.clearErrorMessage();
      await _nfcCubit.restartSessionIfNeeded(card: cubit.state.selectedCard);
    }
    _nfcCubit.resetSnackBarState();
  }
}
