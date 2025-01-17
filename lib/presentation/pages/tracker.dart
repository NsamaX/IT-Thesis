import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import '../cubits/deck_manager.dart';
import '../cubits/drawer.dart';
import '../cubits/NFC.dart';
import '../cubits/tracker.dart';
import '../widgets/drawers/history.dart';
import '../widgets/drawers/player.dart';
import '../widgets/labels/card.dart';
import '../widgets/app_bar.dart';
import '../widgets/notifications.dart';

class TrackerPage extends StatefulWidget {
  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> with WidgetsBindingObserver {
  //-------------------------------- Lifecycle -------------------------------//
  late final NFCCubit _nfcCubit;
  late final NFCSessionHandler _nfcSessionHandler;

  @override
  void initState() {
    super.initState();
    _nfcCubit = context.read<NFCCubit>();
    _nfcSessionHandler = NFCSessionHandler(_nfcCubit)..initNFCSessionHandler();
  }

  @override
  void dispose() {
    _nfcSessionHandler.disposeNFCSessionHandler();
    super.dispose();
  }

  //---------------------------------- Build ---------------------------------//
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final deck = context.read<DeckManagerCubit>().state.deck;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DrawerCubit()),
        BlocProvider(create: (context) => TrackCubit(deck)),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<NFCCubit, NFCState>(
            listener: (context, nfcState) {
              if (nfcState.lastestReadTags != null && nfcState.isNFCEnabled) {
                context.read<TrackCubit>().readTag(nfcState.lastestReadTags!);
              }
            },
            listenWhen: (previous, current) {
              return previous.lastestReadTags != current.lastestReadTags && current.lastestReadTags != null;
            },
          ),
        ],
        child: BlocBuilder<TrackCubit, TrackState>(
          builder: (context, state) {
            if (!state.isDialogShown) {
              _showTrackerDialog(context, locale);
            }
            return Scaffold(
              appBar: AppBarWidget(menu: _buildAppBarMenu(context, locale, deck)),
              body: GestureDetector(
                onTap: () => context.read<DrawerCubit>().closeDrawer(),
                behavior: HitTestBehavior.opaque,
                child: BlocBuilder<DrawerCubit, Map<String, bool>>(
                  builder: (context, drawerState) {
                    final isDrawerOpen = drawerState['history'] ?? false;
                    return Stack(
                      children: [
                        AbsorbPointer(
                          absorbing: isDrawerOpen,
                          child: _buildCardList(context, state),
                        ),
                        _buildHistoryDrawer(context),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //--------------------------------- App Bar --------------------------------//
  Map<dynamic, dynamic> _buildAppBarMenu(
    BuildContext context,
    AppLocalizations locale,
    DeckEntity deck,
  ) {
    final nfcCubit = context.watch<NFCCubit>();
    final isNFCEnabled = nfcCubit.state.isNFCEnabled;
    return context.watch<TrackCubit>().state.isAdvanceModeEnabled ? {
      Icons.access_time_rounded: () => context.read<DrawerCubit>().toggleDrawer('history'),
      Icons.equalizer_sharp: null,
      locale.translate('title.tracker'): null,
      Icons.refresh_rounded: () => context.read<TrackCubit>().toggleReset(deck),
      Icons.build_rounded: () => context.read<TrackCubit>().toggleAdvanceMode(),
    } : {
      Icons.arrow_back_ios_new_rounded: '/back',
      Icons.people_rounded: null,
      locale.translate('title.tracker'): null,
      isNFCEnabled
              ? Icons.wifi_tethering_rounded
              : Icons.wifi_tethering_off_rounded:
          () => NFCHelper.handleToggleNFC(nfcCubit,
              enable: !isNFCEnabled,
              reason: 'User toggled NFC in Tracker Page'),
      Icons.build_outlined: () => context.read<TrackCubit>().toggleAdvanceMode(),
    };
  }
  
  //--------------------------------- Widget ---------------------------------//
  Widget _buildCardList(BuildContext context, TrackState state) {
    final totalCards = state.deck.cards.values.fold<int>(0, (sum, count) => sum + count);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 46, 8, 8),
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
        Positioned(
          top: 8,
          right: 16,
          child: Text(
            '$totalCards ${AppLocalizations.of(context).translate('text.total_cards')}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }

  void _showTrackerDialog(BuildContext context, AppLocalizations locale) {
    Future.microtask(() {
      context.read<TrackCubit>().showDialog();
      cupertinoAlertDialog(
        context,
        title: locale.translate('dialog.tracker.title'),
        content: locale.translate('dialog.tracker.content'),
      );
    });
  }

  Widget _buildPlayerDrawer(BuildContext context) {
    return BlocBuilder<DrawerCubit, Map<String, bool>>(
      buildWhen: (previous, current) => previous['player'] != current['player'],
      builder: (context, drawerState) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          top: drawerState['player']! ? 0 : -200,
          left: 0,
          child: PlayerDrawerWidget(),
        );
      },
    );
  }

  Widget _buildHistoryDrawer(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    return BlocBuilder<DrawerCubit, Map<String, bool>>(
      buildWhen: (previous, current) => previous['history'] != current['history'],
      builder: (context, drawerState) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          top: 0,
          left: drawerState['history']! ? 0 : -200,
          child: BlocBuilder<TrackCubit, TrackState>(
            builder: (context, trackState) {
              return HistoryDrawerWidget(
                height: MediaQuery.of(context).size.height - appBarHeight - 30,
                cards: trackState.history,
              );
            },
          ),
        );
      },
    );
  }
}
