import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nfc_project/core/locales/localizations.dart';

import '../cubits/app_state.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final navigationItems = [
      {'icon': Icons.web_stories_rounded, 'label': 'navigation.decks'},
      {'icon': Icons.insert_page_break_outlined, 'label': 'navigation.read'},
      {'icon': Icons.settings, 'label': 'navigation.settings'},
    ];
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) => BottomNavigationBar(
        currentIndex: state.currentPageIndex,
        elevation: 8.0,
        onTap: (index) => _navigateToPage(context, index),
        items: _buildNavigationItems(navigationItems, locale),
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    final cubit = context.read<AppCubit>();
    if (index != cubit.state.currentPageIndex) {
      cubit.updatePageIndex(index);
      Navigator.pushNamedAndRemoveUntil(
        context,
        cubit.getRouteForIndex(index),
        (_) => false,
      );
    }
  }

  List<BottomNavigationBarItem> _buildNavigationItems(
    List<Map<String, Object>> items,
    AppLocalizations locale,
  ) => items
          .map(
            (item) => BottomNavigationBarItem(
              icon: Icon(item['icon'] as IconData),
              label: locale.translate(item['label'] as String),
            ),
          )
          .toList();
}
