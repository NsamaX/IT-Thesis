import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/locales/localizations.dart';
import '../../blocs/app_state.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppStateCubit, AppState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        return BottomNavigationBar(
          currentIndex: state.currentPageIndex,
          onTap: (index) {
            if (index != state.currentPageIndex) {
              context.read<AppStateCubit>().updatePageIndex(index);
              Navigator.pushNamedAndRemoveUntil(
                context,
                context.read<AppStateCubit>().getRouteForIndex(index),
                (_) => false,
              );
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.web_stories_rounded),
              label: AppLocalizations.of(context).translate('my_deck.title'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_page_break_outlined),
              label: AppLocalizations.of(context).translate('read.title'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: AppLocalizations.of(context).translate('setting.title'),
            ),
          ],
          selectedItemColor: theme.secondaryHeaderColor,
          unselectedItemColor: theme.iconTheme.color,
        );
      },
    );
  }
}
