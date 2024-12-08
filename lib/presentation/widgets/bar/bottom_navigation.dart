import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import '../../blocs/app_state.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return BlocBuilder<AppStateCubit, AppState>(
      builder: (context, state) {
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
              label: locale.translate('navigation.decks'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_page_break_outlined),
              label: locale.translate('navigation.reader'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: locale.translate('navigation.settings'),
            ),
          ],
          selectedItemColor: theme.secondaryHeaderColor,
          unselectedItemColor: theme.iconTheme.color,
        );
      },
    );
  }
}
