import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Map<dynamic, dynamic> menu;

  const AppBarWidget({
    Key? key,
    required this.menu,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: menu.length == 1
          ? Center(
              child: buildMenuItem(context, menu.keys.first, menu.values.first),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: menu.entries
                  .map(
                    (entry) => buildMenuItem(context, entry.key, entry.value),
                  )
                  .toList(),
            ),
    );
  }

  Widget buildMenuItem(
    BuildContext context,
    dynamic menu,
    dynamic onTapFunction,
  ) {
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
        width: isTitle ? 140 : 42,
        child: menu is IconData
            ? Icon(menu)
            : menu is String
                ? Text(
                    menu,
                    style: isTitle
                        ? theme.textTheme.titleMedium
                        : theme.textTheme.bodyMedium?.copyWith(
                            color: theme.appBarTheme.iconTheme!.color,
                          ),
                    textAlign: TextAlign.center,
                  )
                : menu,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
