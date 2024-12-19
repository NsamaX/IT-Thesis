import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import '../../blocs/deck_manager.dart';
import '../../blocs/NFC.dart';
import '../../blocs/tracker.dart';
import '../../widgets/dialog.dart';
import '../../widgets/label/card.dart';
import '../../widgets/navigation_bar/app.dart';

class TrackerPage extends StatefulWidget {
  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> with WidgetsBindingObserver {
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

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final deck = context.read<DeckManagerCubit>().state.deck;

    return BlocProvider(
      create: (context) => TrackCubit(deck),
      child: MultiBlocListener(
        listeners: [
          BlocListener<NFCCubit, NFCState>(
            listener: (context, nfcState) {
              if (nfcState.lastReadTag != null && nfcState.isNFCEnabled) {
                _handleNFCTag(context, nfcState, locale);
              }
            },
          ),
        ],
        child: BlocBuilder<TrackCubit, TrackState>(
          builder: (context, state) {
            if (!state.isDialogShown) {
              _showTrackerDialog(context, locale);
            }
            return Scaffold(
              appBar:
                  AppBarWidget(menu: _buildAppBarMenu(context, locale, deck)),
              body: _buildCardList(context, state),
            );
          },
        ),
      ),
    );
  }

  void _handleNFCTag(
    BuildContext context,
    NFCState nfcState,
    AppLocalizations locale,
  ) async {
    final tag = nfcState.lastReadTag;

    if (tag != null && nfcState.isNFCEnabled) {
      try {
        context.read<TrackCubit>().readTag(tag);
        showSnackBar(
          context: context,
          content: locale.translate('card.dialog.read_success'),
        );
      } catch (e) {
        showSnackBar(
          context: context,
          content: locale.translate('card.dialog.read_fail'),
        );
      }
    }
  }

  void _showTrackerDialog(BuildContext context, AppLocalizations locale) {
    Future.microtask(() {
      context.read<TrackCubit>().showDialog();
      showCupertinoAlertOK(
        context: context,
        title: locale.translate('tracker.dialog.title'),
        content: locale.translate('tracker.dialog.content'),
      );
    });
  }

  Map<dynamic, dynamic> _buildAppBarMenu(
    BuildContext context,
    AppLocalizations locale,
    DeckEntity deck,
  ) {
    final nfcCubit = context.watch<NFCCubit>();
    final isNFCEnabled = nfcCubit.state.isNFCEnabled;

    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      Icons.access_time_rounded: null,
      locale.translate('tracker.title'): null,
      Icons.refresh_rounded: () => context.read<TrackCubit>().toggleReset(deck),
      isNFCEnabled
              ? Icons.wifi_tethering_rounded
              : Icons.wifi_tethering_off_rounded:
          () => NFCHelper.handleToggleNFC(nfcCubit,
              enable: !isNFCEnabled,
              reason: 'User toggled NFC in Tracker Page'),
    };
  }

  Widget _buildCardList(BuildContext context, TrackState state) {
    final totalCards =
        state.deck.cards.values.fold<int>(0, (sum, count) => sum + count);

    return Stack(
      children: [
        // ListView แสดงการ์ด
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 46, 8, 0),
          child: ListView.builder(
            itemCount: state.deck.cards.length,
            itemBuilder: (context, index) {
              final entry = state.deck.cards.entries.elementAt(index);
              final card = entry.key;
              final count = entry.value;
              return CardLabelWidget(
                card: card,
                count: count,
                lightTheme: count > 0,
              );
            },
          ),
        ),
        // จำนวนการ์ดทั้งหมด
        Positioned(
          top: 8,
          right: 16,
          child: Text(
              '$totalCards ${AppLocalizations.of(context).translate('tracker.total')}',
              style: Theme.of(context).textTheme.titleMedium),
        ),
      ],
    );
  }
}
