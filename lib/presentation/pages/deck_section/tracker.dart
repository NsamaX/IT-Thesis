import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/utils/nfc_helper.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import 'package:nfc_project/domain/entities/deck.dart';
import '../../cubits/deck_manager.dart';
import '../../cubits/drawer.dart';
import '../../cubits/NFC.dart';
import '../../cubits/scan_history.dart';
import '../../cubits/tracker.dart';
import '../../widgets/dialog.dart';
import '../../widgets/drawer/history.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DrawerCubit()),
        BlocProvider.value(value: GetIt.I<ScanHistoryCubit>()),
        BlocProvider(create: (context) => TrackCubit(deck)),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<NFCCubit, NFCState>(
            listener: (context, nfcState) {
              if (nfcState.lastReadTag != null && nfcState.isNFCEnabled) {
                _handleNFCTag(context, nfcState, locale);
              }
            },
            listenWhen: (previous, current) {
              return previous.lastReadTag != current.lastReadTag &&
                  current.lastReadTag != null;
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
              body: Stack(
                children: [
                  _buildCardList(context, state),
                  _buildHistoryDrawer(context),
                  BlocBuilder<DrawerCubit, Map<String, bool>>(
                    builder: (context, state) {
                      if (state['history'] == true) {
                        return GestureDetector(
                          onTap: () => context.read<DrawerCubit>().closeDrawer(),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            color: Colors.transparent,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
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
    if (tag != null) {
      try {
        context.read<TrackCubit>().readTag(tag);
        showSnackBar(
          context: context,
          content: locale.translate('snack_bar.nfc.read_success'),
        );
      } catch (e) {
        showSnackBar(
          context: context,
          content: locale.translate('snack_bar.nfc.read_failed'),
        );
      }
    }
  }

  void _showTrackerDialog(BuildContext context, AppLocalizations locale) {
    Future.microtask(() {
      context.read<TrackCubit>().showDialog();
      showCupertinoAlertOK(
        context: context,
        title: locale.translate('dialog.tracker.title'),
        content: locale.translate('dialog.tracker.content'),
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
      Icons.access_time_rounded: () => context.read<DrawerCubit>().toggleDrawer('history'),
      locale.translate('title.tracker'): null,
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

  Widget _buildHistoryDrawer(BuildContext context) {
    return BlocBuilder<DrawerCubit, Map<String, bool>>(
      buildWhen: (previous, current) => previous['history'] != current['history'],
      builder: (context, drawerState) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          top: 0,
          left: drawerState['history']! ? 0 : -200,
          child: BlocBuilder<TrackCubit, TrackState>(
            builder: (context, trackState) {
              return HistoryDrawerWidget(savedTags: trackState.history);
            },
          ),
        );
      },
    );
  }
}
