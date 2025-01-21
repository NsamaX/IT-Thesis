import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Map<dynamic, dynamic> menu;

  const AppBarWidget({Key? key, required this.menu}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      title: menu.length == 1
          ? Center(
              child: _buildMenuItem(
                context,
                theme,
                menuKey: menu.keys.first,
                onTapFunction: menu.values.first,
                isTitle: true,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: menu.entries
                  .map((entry) => _buildMenuItem(
                        context,
                        theme,
                        menuKey: entry.key,
                        onTapFunction: entry.value,
                        isTitle: _isTitle(entry.key),
                      ))
                  .toList(),
            ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    ThemeData theme, {
    required dynamic menuKey,
    required dynamic onTapFunction,
    required bool isTitle,
  }) => GestureDetector(
    onTap: () => _handleMenuTap(context, onTapFunction),
    child: SizedBox(
      width: isTitle ? 142.0 : 42.0,
      height: kToolbarHeight,
      child: Center(
        child: _getMenuItemWidget(theme, menuKey, isTitle),
      ),
    ),
  );

  Widget _getMenuItemWidget(ThemeData theme, dynamic menuKey, bool isTitle) {
    if (menuKey == null) return const SizedBox.shrink();
    if (menuKey is IconData) {
      return Icon(menuKey);
    } else if (menuKey is String) {
      return Text(
        menuKey,
        style: isTitle
            ? theme.textTheme.titleMedium
            : theme.textTheme.bodyMedium?.copyWith(color: theme.appBarTheme.iconTheme?.color),
        textAlign: TextAlign.center,
      );
    } else if (menuKey is Widget) {
      return menuKey;
    } else {
      return const Icon(Icons.error_outline);
    }
  }

  void _handleMenuTap(BuildContext context, dynamic onTapFunction) {
    if (onTapFunction == null) return;
    if (onTapFunction is String) {
      if (onTapFunction.startsWith('/back')) {
        Navigator.pop(context);
      } else {
        Navigator.pushNamed(context, onTapFunction);
      }
    } else if (onTapFunction is Map<String, dynamic>) {
      Navigator.pushNamed(
        context,
        onTapFunction['route'],
        arguments: onTapFunction['arguments'],
      );
    } else if (onTapFunction is VoidCallback) {
      onTapFunction();
    }
  }

  bool _isTitle(dynamic menuKey) => menuKey == menu.keys.elementAt(menu.length ~/ 2);
}
