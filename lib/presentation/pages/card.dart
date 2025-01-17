import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../cubits/deck_manager.dart';
import '../cubits/NFC.dart';
import '../widgets/card/quantity.dart';
import '../widgets/card/info.dart';
import '../widgets/card/image.dart';
import '../widgets/app_bar.dart';
import '../widgets/notifications.dart';

class CardPage extends StatefulWidget {
  @override
  _CardInfoPageState createState() => _CardInfoPageState();
}

class _CardInfoPageState extends State<CardPage> with WidgetsBindingObserver {
  //-------------------------------- Lifecycle -------------------------------//
  late final NFCCubit _nfcCubit;
  late final NFCSessionHandler _nfcSessionHandler;
  late TextEditingController _deckNameController;

  @override
  void initState() {
    super.initState();
    _nfcCubit = context.read<NFCCubit>();
    _nfcSessionHandler = NFCSessionHandler(_nfcCubit)..initNFCSessionHandler();
    _deckNameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = AppLocalizations.of(context);
    _deckNameController.text = locale.translate('text.card_name');
    _initializeCardData();
  }

  void _initializeCardData() {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final card = arguments?['card'] as CardEntity?;
    if (card != null) context.read<DeckManagerCubit>().setQuantity(1);
  }

  @override
  void dispose() {
    _nfcSessionHandler.disposeNFCSessionHandler();
    _deckNameController.dispose();
    super.dispose();
  }

  //---------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final card = arguments?['card'] as CardEntity?;
    final isAdd = arguments?['isAdd'] ?? false;
    final isCustom = arguments?['isCustom'] ?? false;
    return Scaffold(
      appBar: AppBarWidget(
        menu: _buildAppBarMenu(context, locale, card, isAdd, isCustom),
      ),
      body: BlocBuilder<DeckManagerCubit, DeckManagerState>(
        builder: (_, state) => ListView(
          padding: const EdgeInsets.all(40),
          children: [
            CardImageWidget(card: card, isCustom: isCustom),
            const SizedBox(height: 24),
            CardInfoWidget(card: card, isCustom: isCustom),
            if (isAdd) _buildCardQuantitySelector(context, state),
          ],
        ),
      ),
    );
  }

  //--------------------------------- App Bar --------------------------------//
  Map<dynamic, dynamic> _buildAppBarMenu(BuildContext context, AppLocalizations locale, CardEntity? card, bool isAdd, bool isCustom) {
    final deckManagerCubit = context.read<DeckManagerCubit>();
    final nfcCubit = context.watch<NFCCubit>();
    final isNFCEnabled = nfcCubit.state.isNFCEnabled;
    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      isCustom
          ? _buildCustomTextField(context, locale)
          : locale.translate('title.card'): null,
      if (isAdd) locale.translate('toggle.add'): () => _handleAddCard(context, locale, deckManagerCubit, card),
      if (isCustom) locale.translate('toggle.done'): null,
      if (!isAdd && !isCustom) (isNFCEnabled 
          ? Icons.wifi_tethering_rounded 
          : Icons.wifi_tethering_off_rounded): () => _toggleNFC(nfcCubit, isNFCEnabled, card),
    };
  }

  Widget _buildCustomTextField(BuildContext context, AppLocalizations locale) {
    return TextField(
      controller: _deckNameController,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: locale.translate('text.card_name'),
      ),
      onSubmitted: (value) {
        _deckNameController.text = value.trim().isNotEmpty
            ? value.trim()
            : locale.translate('text.card_name');
      },
    );
  }

  void _handleAddCard(BuildContext context, AppLocalizations locale, DeckManagerCubit deckManagerCubit, CardEntity? card) {
    deckManagerCubit.addCard(card!, deckManagerCubit.state.quantity);
    Navigator.of(context).pop();
    snackBar(
      context,
      content: locale.translate('snack_bar.card.add_success'),
    );
  }

  void _toggleNFC(NFCCubit nfcCubit, bool isNFCEnabled, CardEntity? card) {
    NFCHelper.handleToggleNFC(
      nfcCubit,
      enable: !isNFCEnabled,
      card: card,
      reason: 'User toggled NFC in Card Page',
    );
  }

  //--------------------------------- Widget ---------------------------------//
  Widget _buildCardQuantitySelector(BuildContext context, DeckManagerState state) {
    return Column(
      children: [
        const SizedBox(height: 24),
        CardQuantityWidget(
          onSelected: (quantity) => context.read<DeckManagerCubit>().setQuantity(quantity),
          quantityCount: 4,
          selectedQuantity: state.quantity,
        ),
      ],
    );
  }
}
