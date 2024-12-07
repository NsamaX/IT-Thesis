import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';
import '../../blocs/drawer.dart';
import '../../blocs/NFC.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/bar/bottom_navigation.dart';
import '../../widgets/drawer/features.dart';
import '../../widgets/drawer/history.dart';
import '../../widgets/nfc.dart';

class ReadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawerCubit(),
      child: Builder(
        builder: (context) {
          context.read<NFCCubit>().loadTags();
          return Scaffold(
            appBar: AppBarWidget(
              menu: {
                Icons.history_rounded: () =>
                    context.read<DrawerCubit>().toggleDrawer('history'),
                AppLocalizations.of(context).translate('read.title'): null,
                Icons.search_rounded: () =>
                    context.read<DrawerCubit>().toggleDrawer('feature'),
              },
            ),
            body: GestureDetector(
              onTap: () => context.read<DrawerCubit>().closeDrawer(),
              behavior: HitTestBehavior.opaque,
              child: Stack(
                children: [
                  Center(child: NFCWidget()),
                  BlocBuilder<DrawerCubit, Map<String, bool>>(
                    builder: (context, state) {
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: 200),
                        top: 0,
                        left: state['history']! ? 0 : -200,
                        child: HistoryDrawerWidget(),
                      );
                    },
                  ),
                  BlocBuilder<DrawerCubit, Map<String, bool>>(
                    builder: (context, state) {
                      return AnimatedPositioned(
                        duration: Duration(milliseconds: 200),
                        top: 20,
                        right: state['feature']! ? 0 : -200,
                        child: FeaturesDrawerWidget(),
                      );
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBarWidget(),
          );
        },
      ),
    );
  }
}
