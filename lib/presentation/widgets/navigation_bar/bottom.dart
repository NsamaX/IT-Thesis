import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import '../../cubits/app_state.dart';

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
          onTap: (index) => _handleNavigation(context, state, index),
          items: _buildNavigationBarItems(locale),
          selectedItemColor: theme.secondaryHeaderColor,
          unselectedItemColor: theme.iconTheme.color,
        );
      },
    );
  }

  void _handleNavigation(BuildContext context, AppState state, int index) {
    if (index != state.currentPageIndex) {
      final appStateCubit = context.read<AppStateCubit>();
      appStateCubit.updatePageIndex(index);
      Navigator.pushNamedAndRemoveUntil(
        context,
        appStateCubit.getRouteForIndex(index),
        (_) => false,
      );
    }
  }

  List<BottomNavigationBarItem> _buildNavigationBarItems(AppLocalizations locale) {
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.web_stories_rounded),
        label: locale.translate('navigation.decks'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.insert_page_break_outlined),
        label: locale.translate('navigation.scan'),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: locale.translate('navigation.settings'),
      ),
    ];
  }
}
