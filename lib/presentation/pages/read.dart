import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/services/locator.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import '../cubits/drawer.dart';
import '../cubits/NFC.dart';
import '../cubits/scan.dart';
import '../widgets/drawers/features.dart';
import '../widgets/drawers/history.dart';
import '../widgets/app_bar.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/nfc.dart';

class ReadPage extends StatefulWidget {
  @override
  State<ReadPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReadPage> with WidgetsBindingObserver, RouteAware {
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

  //------------------------------ RouteObserver -----------------------------//
  @override
  void didPushNext() {
    _nfcSessionHandler.disposeNFCSessionHandler();
  }

  @override
  void didPopNext() {
    _nfcSessionHandler.initNFCSessionHandler();
  }

  //---------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DrawerCubit()),
        BlocProvider(create: (context) => locator<ScanCubit>(param1: 'vanguard')),
      ],
      child: Builder(
        builder: (context) {
          return BlocListener<NFCCubit, NFCState>(
            listenWhen: (previous, current) => previous.lastestReadTags != current.lastestReadTags && current.lastestReadTags != null,
            listener: (context, nfcState) {
              context.read<ScanCubit>().fetchCardById(nfcState.lastestReadTags!);
              if (nfcState.lastestReadTags != null && context.read<DrawerCubit>().isDrawerVisible('history') == false) {
                context.read<DrawerCubit>().toggleDrawer('history');
              }
            },
            child: _buildBody(context, locale),
          );
        },
      ),
    );
  }

  //--------------------------------- App Bar --------------------------------//
  Map<dynamic, dynamic> _buildAppBarMenu(BuildContext context, AppLocalizations locale) => {
    Icons.history_rounded: () => context.read<DrawerCubit>().toggleDrawer('history'),
    locale.translate('title.read'): null,
    Icons.search_rounded: () => context.read<DrawerCubit>().toggleDrawer('feature'),
  };

  //--------------------------------- Body -----------------------------------//
  Widget _buildBody(BuildContext context, AppLocalizations locale) => Scaffold(
    appBar: AppBarWidget(menu: _buildAppBarMenu(context, locale)),
    body: GestureDetector(
      onTap: () => context.read<DrawerCubit>().closeDrawer(),
      behavior: HitTestBehavior.opaque,
      child: BlocBuilder<ScanCubit, ScanCubitState>(
        builder: (context, scanState) {
          return Stack(
            children: [
              const Center(child: NFCWidget()),
              _buildHistoryDrawer(context),
              _buildFeaturesDrawer(context),
            ],
          );
        },
      ),
    ),
    bottomNavigationBar: const BottomNavigationBarWidget(),
  );

  //----------------------------- Drawer Widgets -----------------------------//
  Widget _buildHistoryDrawer(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    final double bottomNavBarHeight = kBottomNavigationBarHeight;

    return BlocBuilder<DrawerCubit, Map<String, bool>>(
      buildWhen: (previous, current) => previous['history'] != current['history'],
      builder: (context, state) {
        return AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          top: 0,
          left: state['history']! ? 0 : -200,
          child: BlocBuilder<ScanCubit, ScanCubitState>(
            builder: (context, scanHistoryState) {
              return HistoryDrawerWidget(
                height: MediaQuery.of(context).size.height - appBarHeight - bottomNavBarHeight - 30,
                cards: scanHistoryState.cards ?? [],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturesDrawer(BuildContext context) => BlocBuilder<DrawerCubit, Map<String, bool>>(
    buildWhen: (previous, current) => previous['feature'] != current['feature'],
    builder: (context, state) {
      return AnimatedPositioned(
        duration: const Duration(milliseconds: 200),
        top: 20,
        right: state['feature']! ? 0 : -200,
        child: const FeaturesDrawerWidget(),
      );
    },
  );
}
