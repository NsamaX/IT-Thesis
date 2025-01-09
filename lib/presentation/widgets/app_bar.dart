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
                menu.keys.first,
                menu.values.first,
                isTitle: true,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: menu.entries
                  .map(
                    (entry) => _buildMenuItem(
                      context,
                      entry.key,
                      entry.value,
                      isTitle: _isTitle(entry.key),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    dynamic menuKey,
    dynamic onTapFunction,
    {required bool isTitle}
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _handleMenuTap(context, onTapFunction),
      child: SizedBox(
        width: isTitle ? 142 : 42,
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

  bool _isTitle(dynamic menuKey) {
    return menuKey == menu.keys.elementAt(menu.length ~/ 2);
  }
}
