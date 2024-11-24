import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/locales/localizations.dart';
import '../../blocs/bottom_nav.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, currentIndex) {
        final theme = Theme.of(context);
        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            index != currentIndex
                ? Navigator.pushNamedAndRemoveUntil(
                    context,
                    context.read<BottomNavCubit>().getRouteForIndex(index),
                    (_) => false)
                : null;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.web_stories_rounded),
              label: AppLocalizations.of(context).translate('my_deck_title'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_page_break_outlined),
              label: AppLocalizations.of(context).translate('read_title'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: AppLocalizations.of(context).translate('setting_title'),
            ),
          ],
          selectedItemColor: theme.secondaryHeaderColor,
          unselectedItemColor: theme.iconTheme.color,
        );
      },
    );
  }
}
