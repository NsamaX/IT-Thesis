import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';

import 'package:nfc_project/domain/entities/deck.dart';

import '../cubits/deck_management/cubit.dart';
import '../cubits/NFC/cubit.dart';
import '../cubits/deck_tracker/cubit.dart';
import '../cubits/drawer.dart';

import '../widgets/card/card_label.dart';

import '../widgets/deck/deck_insight_chart.dart';
import '../widgets/deck/deck_insight.dart';

import '../widgets/drawer/history_drawer.dart';
import '../widgets/drawer/player_drawer.dart';

import '../widgets/shared/app_bar.dart';
import '../widgets/shared/notifications.dart';

import '../widgets/specific/switch_mode.dart';

class DeckTrackerPage extends StatefulWidget {
  @override
  State<DeckTrackerPage> createState() => _DeckTrackerPageState();
}

class _DeckTrackerPageState extends State<DeckTrackerPage> with WidgetsBindingObserver {
  late final NFCCubit _nfcCubit;
  late final NFCSessionHandler _nfcSessionHandler;

  /*-------------------------------- Lifecycle -------------------------------*/
  @override
  void initState() {
    super.initState();
    _nfcCubit = context.read<NFCCubit>();
    _nfcSessionHandler = NFCSessionHandler(_nfcCubit)..initNFCSessionHandler();
    if (!_nfcCubit.state.isNFCEnabled) {
      NFCHelper.handleToggleNFC(
        _nfcCubit,
        enable: true,
        reason: 'Auto-enable NFC when entering Tracker Page',
      );
    }
  }

  @override
  void dispose() {
    _nfcSessionHandler.disposeNFCSessionHandler();
    super.dispose();
  }

  /*---------------------------------- Build ---------------------------------*/
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final deck = context.read<DeckManagerCubit>().state.deck;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DrawerCubit()),
        BlocProvider(create: (context) => GetIt.instance<DeckTrackCubit>(param1: deck)),
      ],
      child: Builder(
        builder: (context) {
          context.read<DeckTrackCubit>().fetchRecord();
          _showTrackerDialog(context, locale);
          return MultiBlocListener(
            listeners: [
              BlocListener<NFCCubit, NFCState>(
                listener: (context, nfcState) {
                  if (nfcState.lastestReadTags != null && nfcState.isNFCEnabled) {
                    context.read<DeckTrackCubit>().readTag(nfcState.lastestReadTags!);
                  }
                },
                listenWhen: (previous, current) {
                  return previous.lastestReadTags != current.lastestReadTags && current.lastestReadTags != null;
                },
              ),
            ],
            child: BlocBuilder<DeckTrackCubit, DeckTrackState>(
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBarWidget(menu: _buildAppBarMenu(context, locale, deck)),
                  body: _buildBody(context, state),
                );
              },
            ),
          );
        }
      ),
    );
  }

  /*--------------------------------- App Bar --------------------------------*/
  Map<dynamic, dynamic> _buildAppBarMenu(BuildContext context, AppLocalizations locale, DeckEntity deck) {
    final nfcCubit = context.watch<NFCCubit>();
    final isNFCEnabled = nfcCubit.state.isNFCEnabled;
    return context.watch<DeckTrackCubit>().state.isAdvanceModeEnabled
        ? {
            Icons.access_time_rounded: () => context.read<DrawerCubit>().toggleDrawer('history'),
            Icons.refresh_rounded: () => _resetMultipleChoicesDialog(context, deck),
            locale.translate('title.tracker'): null,
            isNFCEnabled
                    ? Icons.wifi_tethering_rounded
                    : Icons.wifi_tethering_off_rounded:
                () => NFCHelper.handleToggleNFC(nfcCubit,
                    enable: !isNFCEnabled,
                    reason: 'User toggled NFC in Tracker Page'),
            Icons.build_rounded: () => context.read<DeckTrackCubit>().toggleAdvanceMode(),
          }
        : {
            Icons.arrow_back_ios_new_rounded: '/back',
            Icons.people_rounded: () => context.read<DrawerCubit>().toggleDrawer('feature'),
            locale.translate('title.tracker'): null,
            isNFCEnabled
                    ? Icons.wifi_tethering_rounded
                    : Icons.wifi_tethering_off_rounded:
                () => NFCHelper.handleToggleNFC(nfcCubit,
                    enable: !isNFCEnabled,
                    reason: 'User toggled NFC in Tracker Page'),
            Icons.build_outlined: () => context.read<DeckTrackCubit>().toggleAdvanceMode(),
          };
  }

  /*--------------------------------- Feature --------------------------------*/
  void _resetMultipleChoicesDialog(BuildContext context, DeckEntity deck) {
    cupertinoMultipleChoicesDialog(
      context,
      AppLocalizations.of(context).translate('dialog.reset_deck.title'),
      AppLocalizations.of(context).translate('dialog.reset_deck.content'),
      {
        AppLocalizations.of(context).translate('button.reset'): {
          'onPressed': () {
            context.read<DeckTrackCubit>().toggleReset();
            Navigator.of(context).pop();
          },
          'isCancel': false,
        },
        AppLocalizations.of(context).translate('toggle.save'): {
          'onPressed': () {
            context.read<DeckTrackCubit>().toggleSaveRecord();
            Navigator.of(context).pop();
          },
          'isCancel': false,
        },
        AppLocalizations.of(context).translate('button.cancel'): {
          'onPressed': () => Navigator.of(context).pop(),
          'isCancel': true,
        },
      },
    );
  }

  /*---------------------------------- Body ----------------------------------*/
  Widget _buildBody(BuildContext context, DeckTrackState state) => GestureDetector(
    onTap: () => context.read<DrawerCubit>().closeDrawer(),
    behavior: HitTestBehavior.opaque,
    child: BlocBuilder<DrawerCubit, DrawerState>(
      builder: (context, drawerState) {
        final isDrawerOpen = drawerState.isDrawerVisible('history');
        final isFeatureOpen = drawerState.isDrawerVisible('feature');
        return Stack(
          children: [
            AbsorbPointer(
              absorbing: isDrawerOpen || isFeatureOpen,
              child: _buildBodyByMode(context, state),
            ),
            if (isFeatureOpen) Container(color: Colors.black.withAlpha((0.5 * 255).toInt())),
            _buildHistoryDrawer(context),
            _buildPlayerHistoryDrawer(context),
          ],
        );
      },
    ),
  );

  /*--------------------------------- Widgets --------------------------------*/
  Widget _buildBodyByMode(BuildContext context, DeckTrackState state) => Column(
    children: [
      const SizedBox(height: 16.0),
      SwitchModeWidget(
        isAnalyzeModeEnabled: state.isAnalyzeModeEnabled,
        onSelected: (isAnalysis) => context.read<DeckTrackCubit>().toggleAnalyzeMode(),
      ),
      const SizedBox(height: 8.0),
      Expanded(
        child: BlocBuilder<DeckTrackCubit, DeckTrackState>(
          builder: (context, DecktrackState) {
            if (DecktrackState.isAnalyzeModeEnabled) {
              final List<Map<String, dynamic>> cardStats = context.read<DeckTrackCubit>().calculateDrawAndReturnCounts();
              return _buildAnalyzeInfo(state, cardStats);
            } else {
              return _buildCardList(context, DecktrackState);
            }
          },
        ),
      ),
    ],
  );

  Widget _buildCardList(BuildContext context, DeckTrackState state) {
    final totalCards = state.currentDeck.cards.values.fold<int>(0, (sum, count) => sum + count);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$totalCards ${AppLocalizations.of(context).translate('text.total_cards')}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ListView.builder(
            itemCount: state.currentDeck.cards.length,
            itemBuilder: (context, index) {
              final entry = state.currentDeck.cards.entries.elementAt(index);
              final card = entry.key;
              final count = entry.value;
              return CardLabelWidget(
                card: card,
                count: count,
                isNFC: false,
                isTrack: true,
                lightTheme: count > 0,
                cardColors: state.cardColors[card.cardId],
                changeCardColor: (color) => context.read<DeckTrackCubit>().changeCardColor(card.cardId, color),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyzeInfo(DeckTrackState state, List<Map<String, dynamic>> cardStats) => ListView(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(6.0, 0.0, 16.0, 0.0),
        child: DeckInsightChartWidget(cardStats: cardStats),
      ),
      DeckInsightWidget(
        initialDeck: state.initialDeck, 
        record: state.record, 
        records: state.records,
        cardStats: cardStats,
        selectRecord: (context, recordId) => context.read<DeckTrackCubit>().fetchRecordById(recordId),
      ),
    ],
  );

  void _showTrackerDialog(BuildContext context, AppLocalizations locale) => Future.microtask(() {
    context.read<DeckTrackCubit>().showDialog();
    cupertinoAlertDialog(
      context,
      locale.translate('dialog.tracker_tutorial.title'),
      locale.translate('dialog.tracker_tutorial.content'),
    );
  });

  Widget _buildHistoryDrawer(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    return BlocBuilder<DrawerCubit, DrawerState>(
      buildWhen: (previous, current) => previous.isDrawerVisible('history') != current.isDrawerVisible('history'),
      builder: (context, state) => AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        top: 0,
        left: state.isDrawerVisible('history') ? 0.0 : -200.0,
        child: BlocBuilder<DeckTrackCubit, DeckTrackState>(
          builder: (context, DecktrackState) => HistoryDrawerWidget(
            cards: DecktrackState.history,
            height: MediaQuery.of(context).size.height - appBarHeight - 30.0,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerHistoryDrawer(BuildContext context) {
    return BlocBuilder<DrawerCubit, DrawerState>(
      buildWhen: (previous, current) => previous.isDrawerVisible('feature') != current.isDrawerVisible('feature'),
      builder: (context, state) => AnimatedPositioned(
        duration: const Duration(milliseconds: 160),
        top: state.isDrawerVisible('feature') ? 0.0 : -160.0,
        left: 0,
        child: BlocBuilder<DeckTrackCubit, DeckTrackState>(
          builder: (context, DecktrackState) => PlayerDrawerWidget(),
        ),
      ),
    );
  }
}
