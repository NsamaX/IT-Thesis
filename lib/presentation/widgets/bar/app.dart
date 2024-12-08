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
          ? Center(child: buildMenu(context, menu.keys.first, menu.values.first))
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: menu.entries.map((entry) => buildMenu(context, entry.key, entry.value)).toList(),
            ),
    );
  }

  Widget buildMenu(BuildContext context, dynamic menu, dynamic onTapFunction) {
    final theme = Theme.of(context);
    final isTitle = menu == this.menu.keys.elementAt(this.menu.length ~/ 2);
    return GestureDetector(
      onTap: () {
        if (onTapFunction != null) {
          if (onTapFunction is String) {
            if (onTapFunction.startsWith('/back')) {
              Navigator.pop(context);
            } else {
              Navigator.pushNamed(
                context,
                onTapFunction,
              );
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
      },
      child: Container(
        width: isTitle ? 142 : 42,
        height: kToolbarHeight,
        child: Center(
          child: menu is IconData
              ? Icon(menu)
              : menu is String
                  ? Text(
                      menu,
                      style: isTitle
                          ? theme.textTheme.titleMedium
                          : theme.textTheme.bodyMedium?.copyWith(color: theme.appBarTheme.iconTheme!.color),
                      textAlign: TextAlign.center,
                    )
                  : menu,
        ),
      ),
    );
  }
}
