import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/utils/arguments.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import 'package:nfc_project/domain/entities/card.dart';

import '../cubits/deck_management/cubit.dart';
import '../cubits/NFC/cubit.dart';
import '../cubits/collection.dart';
import '../widgets/card/image.dart';
import '../widgets/card/info.dart';
import '../widgets/card/quantity.dart';
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
  late TextEditingController _cardNameController;
  late TextEditingController _descriptionController;

  CardEntity? _card;
  bool _isNFC = true;
  bool _isAdd = false;
  bool _isCustom = false;

  @override
  void initState() {
    super.initState();
    _nfcCubit = context.read<NFCCubit>();
    _nfcSessionHandler = NFCSessionHandler(_nfcCubit)..initNFCSessionHandler();
    context.read<CollectionCubit>().clear();
    _cardNameController = TextEditingController(text: _card?.name ?? '');
    _descriptionController = TextEditingController(text: _card?.description ?? '');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = getArguments(context);
    _card = arguments['card'] as CardEntity?;
    _isNFC = arguments['isNFC'] ?? true;
    _isAdd = arguments['isAdd'] ?? false;
    _isCustom = arguments['isCustom'] ?? false;
  }

  @override
  void dispose() {
    _nfcSessionHandler.disposeNFCSessionHandler();
    _cardNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //---------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBarWidget(menu: _buildAppBarMenu(context, locale)),
      body: _buildBody(),
    );
  }

  //--------------------------------- App Bar --------------------------------//
  Map<dynamic, dynamic> _buildAppBarMenu(BuildContext context, AppLocalizations locale) {
    final deckManagerCubit = context.read<DeckManagerCubit>();
    final nfcCubit = context.watch<NFCCubit>();
    final collectionCubit = context.watch<CollectionCubit>();
    final isNFCEnabled = nfcCubit.state.isNFCEnabled;
    final isValid = collectionCubit.state.isValid;
    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      _isCustom
          ? _buildTextField(context, locale)
          : locale.translate('title.card'): null,
      if (_isAdd)locale.translate('toggle.add') : () => _toggleAdd(locale, deckManagerCubit)
      else if (_isCustom) 
        isValid 
          ? locale.translate('toggle.done')
          : null : () => _toggleCreate(locale)
      else if (_isNFC) (
        isNFCEnabled 
            ? Icons.wifi_tethering_rounded 
            : Icons.wifi_tethering_off_rounded): () => _toggleNFC(nfcCubit, isNFCEnabled)
      else null: null,
    };
  }

  //-------------------------------- Features --------------------------------//
  Widget _buildTextField(BuildContext context, AppLocalizations locale) {
    final collectionCubit = context.watch<CollectionCubit>();
    return TextField(
      controller: TextEditingController(text: collectionCubit.state.name)
        ..selection = TextSelection.collapsed(offset: collectionCubit.state.name.length),
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: locale.translate('text.card_name'),
      ),
      onChanged: (value) {
        collectionCubit.setName(value.trim());
      },
    );
  }

  void _toggleAdd(AppLocalizations locale, DeckManagerCubit deckManagerCubit) async {
    if (_card != null) {
      deckManagerCubit.addCard(_card!, deckManagerCubit.state.quantity);
      await snackBar(
        context,
        locale.translate('snack_bar.card.add_success'),
      );
      Navigator.of(context).pop();
    }
  }

  void _toggleCreate(AppLocalizations locale) async {
    context.read<CollectionCubit>().addCard();
    await snackBar(
      context,
      locale.translate('snack_bar.card.add_success'),
    );
  }

  void _toggleNFC(NFCCubit nfcCubit, bool isNFCEnabled) => NFCHelper.handleToggleNFC(
    nfcCubit,
    enable: !isNFCEnabled,
    card: _card,
    reason: 'User toggled NFC in Card Page',
  );

  //--------------------------------- Body -----------------------------------//
  Widget _buildBody() => BlocBuilder<DeckManagerCubit, DeckManagerState>(
    builder: (context, state) => ListView(
      padding: const EdgeInsets.all(40),
      children: [
        CardImageWidget(card: _card, isCustom: _isCustom),
        const SizedBox(height: 24),
        CardInfoWidget(
          card: _card, 
          isCustom: _isCustom,  
          descriptionController: _descriptionController,
        ),
        if (_isAdd) CardQuantityWidget(
          onSelected: (quantity) => context.read<DeckManagerCubit>().setQuantity(quantity),
          quantityCount: 4,
          selectedQuantity: state.quantity,
        ),
      ],
    ),
  );
}
