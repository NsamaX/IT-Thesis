import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/services/locator.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import '../cubits/drawer.dart';
import '../cubits/NFC.dart';
import '../cubits/scan.dart';
import '../widgets/drawer/features.dart';
import '../widgets/drawer/history.dart';
import '../widgets/navigation_bar/app.dart';
import '../widgets/navigation_bar/bottom.dart';
import '../widgets/nfc.dart';

class ReaderPage extends StatefulWidget {
  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> with WidgetsBindingObserver {
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DrawerCubit()),
        BlocProvider(create: (context) => locator<ScanCubit>(param1: 'vanguard')),
      ],
      child: Builder(
        builder: (context) {
          return BlocListener<NFCCubit, NFCState>(
            listenWhen: (previous, current) => previous.lastReadTag != current.lastReadTag && current.lastReadTag != null,
            listener: (context, nfcState) {
              context.read<ScanCubit>().fetchCardById(nfcState.lastReadTag!);
            },
            child: Scaffold(
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
            ),
          );
        },
      ),
    );
  }

  Map<dynamic, dynamic> _buildAppBarMenu(BuildContext context, AppLocalizations locale) {
    return {
      Icons.history_rounded: () => context.read<DrawerCubit>().toggleDrawer('history'),
      locale.translate('title.scan'): null,
      Icons.search_rounded: () => context.read<DrawerCubit>().toggleDrawer('feature'),
    };
  }

  Widget _buildHistoryDrawer(BuildContext context) {
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
                  savedTags: scanHistoryState.cards ?? []);
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturesDrawer(BuildContext context) {
    return BlocBuilder<DrawerCubit, Map<String, bool>>(
      buildWhen: (previous, current) =>
          previous['feature'] != current['feature'],
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
}
