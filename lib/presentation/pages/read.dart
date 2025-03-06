import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/services/locator.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';

import '../cubits/NFC/cubit.dart';
import '../cubits/drawer.dart';
import '../cubits/reader.dart';

import '../widgets/drawer/feature_drawer.dart';
import '../widgets/drawer/history_drawer.dart';

import '../widgets/shared/app_bar.dart';
import '../widgets/shared/bottom_navigation_bar.dart';

import '../widgets/specific/NFC_reader.dart';

class ReadPage extends StatefulWidget {
  @override
  State<ReadPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReadPage> with WidgetsBindingObserver, RouteAware {
  late final NFCCubit _nfcCubit;
  late final NFCSessionHandler _nfcSessionHandler;

  /*-------------------------------- Lifecycle -------------------------------*/
  @override
  void initState() {
    super.initState();
    _nfcCubit = context.read<NFCCubit>();
    _nfcSessionHandler = NFCSessionHandler(_nfcCubit)..initNFCSessionHandler();
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DrawerCubit()),
        BlocProvider(create: (context) => locator<ReaderCubit>(param1: 'vanguard')),
      ],
      child: Builder(
        builder: (context) => BlocListener<NFCCubit, NFCState>(
          listenWhen: (previous, current) => previous.lastestReadTags != current.lastestReadTags && current.lastestReadTags != null,
          listener: (context, nfcState) {
            context.read<ReaderCubit>().fetchCardById(nfcState.lastestReadTags!);
            if (nfcState.lastestReadTags != null && !context.read<DrawerCubit>().state.isDrawerVisible('history')) {
              context.read<DrawerCubit>().toggleDrawer('history');
            }
          },
          child: _buildBody(context, locale),
        ),
      ),
    );
  }

  /*--------------------------------- App Bar --------------------------------*/
  Map<dynamic, dynamic> _buildAppBarMenu(BuildContext context, AppLocalizations locale) => {
    Icons.history_rounded: () => context.read<DrawerCubit>().toggleDrawer('history'),
    locale.translate('title.read'): null,
    Icons.search_rounded: () => context.read<DrawerCubit>().toggleDrawer('feature'),
  };

  /*---------------------------------- Body ----------------------------------*/
  Widget _buildBody(BuildContext context, AppLocalizations locale) => Scaffold(
    appBar: AppBarWidget(menu: _buildAppBarMenu(context, locale)),
    body: GestureDetector(
      onTap: () => context.read<DrawerCubit>().closeDrawer(),
      behavior: HitTestBehavior.opaque,
      child: BlocBuilder<ReaderCubit, ReaderCubitState>(
        builder: (context, scanState) => Stack(
          children: [
            const Center(child: NFCReaderWidget()),
            _buildHistoryDrawer(context),
            _buildFeaturesDrawer(context),
          ],
        ),
      ),
    ),
    bottomNavigationBar: const BottomNavigationBarWidget(),
  );

  /*--------------------------------- Widgets --------------------------------*/
  Widget _buildHistoryDrawer(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    final double bottomNavBarHeight = kBottomNavigationBarHeight;

    return BlocBuilder<DrawerCubit, DrawerState>(
      buildWhen: (previous, current) => previous.isDrawerVisible('history') != current.isDrawerVisible('history'),
      builder: (context, state) => AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        top: 0,
        left: state.isDrawerVisible('history') ? 0 : -200,
        child: BlocBuilder<ReaderCubit, ReaderCubitState>(
          builder: (context, scanHistoryState) => HistoryDrawerWidget(
            cards: scanHistoryState.cards,
            height: MediaQuery.of(context).size.height - appBarHeight - bottomNavBarHeight - 30,
            isNFC: true,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesDrawer(BuildContext context) {
    return BlocBuilder<DrawerCubit, DrawerState>(
      buildWhen: (previous, current) => previous.isDrawerVisible('feature') != current.isDrawerVisible('feature'),
      builder: (context, state) => AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        top: 20,
        right: state.isDrawerVisible('feature') ? 0 : -200,
        child: const FeatureDrawerWidget(),
      ),
    );
  }
}
