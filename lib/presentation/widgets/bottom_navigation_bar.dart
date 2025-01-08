import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import '../cubits/app_state.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final navigationItems = [
      {'icon': Icons.web_stories_rounded, 'label': 'navigation.decks'},
      {'icon': Icons.insert_page_break_outlined, 'label': 'navigation.scan'},
      {'icon': Icons.settings, 'label': 'navigation.settings'},
    ];

    return BlocBuilder<AppStateCubit, AppState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.currentPageIndex,
          onTap: (index) => _navigateToPage(context: context, index: index),
          items: _buildNavigationItems(items: navigationItems, locale: locale),
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.iconTheme.color,
          backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
        );
      },
    );
  }

  void _navigateToPage({
      required BuildContext context,
      required int index,
    }) {
    final cubit = context.read<AppStateCubit>();

    if (index != cubit.state.currentPageIndex) {
      cubit.updatePageIndex(index);
      Navigator.pushNamedAndRemoveUntil(
        context,
        cubit.getRouteForIndex(index),
        (_) => false,
      );
    }
  }

  List<BottomNavigationBarItem> _buildNavigationItems({
      required List<Map<String, Object>> items,
      required AppLocalizations locale,
    }) {
    return items
        .map(
          (item) => BottomNavigationBarItem(
            icon: Icon(item['icon'] as IconData),
            label: locale.translate(item['label'] as String),
          ),
        )
        .toList();
  }
}
