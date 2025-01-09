import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Map<dynamic, dynamic> menu;

  const AppBarWidget({Key? key, required this.menu}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: menu.length == 1
          ? Center(
              child: _buildMenuItem(
                context,
                onTapFunction: menu.values.first,
                menuKey: menu.keys.first,
                isTitle: true,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: menu.entries
                  .map(
                    (entry) => _buildMenuItem(
                      context,
                      onTapFunction: entry.value,
                      menuKey: entry.key,
                      isTitle: _isTitle(menuKey: entry.key),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required dynamic onTapFunction,
    required dynamic menuKey,
    required bool isTitle,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _handleMenuTap(context, onTapFunction: onTapFunction),
      child: SizedBox(
        width: isTitle ? 142.0 : 42.0,
        height: kToolbarHeight,
        child: Center(
          child: menuKey is IconData
              ? Icon(menuKey)
              : menuKey is String
                  ? Text(
                      menuKey,
                      style: isTitle
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.bodyMedium?.copyWith(color: theme.appBarTheme.iconTheme?.color),
                      textAlign: TextAlign.center,
                    )
                  : menuKey,
        ),
      ),
    );
  }

  void _handleMenuTap(
    BuildContext context, {
    required dynamic onTapFunction,
  }) {
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

  bool _isTitle({required dynamic menuKey}) => menuKey == menu.keys.elementAt(menu.length ~/ 2);
}
