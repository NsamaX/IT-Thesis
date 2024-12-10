import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/utils/nfc_session_handler.dart';
import '../../blocs/drawer.dart';
import '../../blocs/NFC.dart';
import '../../widgets/drawer/features.dart';
import '../../widgets/drawer/history.dart';
import '../../widgets/navigation_bar/app.dart';
import '../../widgets/navigation_bar/bottom.dart';
import '../../widgets/nfc.dart';

class ReaderPage extends StatefulWidget {
  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> with WidgetsBindingObserver {
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

    return BlocProvider(
      create: (context) => DrawerCubit(),
      child: Builder(
        builder: (context) {
          context.read<NFCCubit>().loadTags();

          return Scaffold(
            appBar: AppBarWidget(menu: _buildAppBarMenu(context, locale)),
            body: GestureDetector(
              onTap: () => context.read<DrawerCubit>().closeDrawer(),
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  const Center(child: NFCWidget()),
                  _buildHistoryDrawer(context),
                  _buildFeaturesDrawer(context),
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavigationBarWidget(),
          );
        },
      ),
    );
  }

  Map<dynamic, dynamic> _buildAppBarMenu(BuildContext context, AppLocalizations locale) {
    return {
      Icons.history_rounded: () => context.read<DrawerCubit>().toggleDrawer('history'),
      locale.translate('scan.title'): null,
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
          child: const HistoryDrawerWidget(),
        );
      },
    );
  }

  Widget _buildFeaturesDrawer(BuildContext context) {
    return BlocBuilder<DrawerCubit, Map<String, bool>>(
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
}
