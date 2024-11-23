import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final Map<dynamic, dynamic> menu;

  const AppBarWidget({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: menu.length == 1
          ? Center(
              child: buildMenuItem(menu.keys.first, menu.values.first, context),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: menu.entries
                  .map(
                    (entry) => buildMenuItem(entry.key, entry.value, context),
                  )
                  .toList(),
            ),
    );
  }

  Widget buildMenuItem(
      dynamic menu, dynamic onTapFunction, BuildContext context) {
    final isTitle = menu == this.menu.keys.elementAt(this.menu.length ~/ 2);

    return GestureDetector(
      onTap: () {
        if (onTapFunction != null) {
          if (onTapFunction is String) {
            (onTapFunction == '/back')
                ? Navigator.pop(context)
                : Navigator.pushNamed(context, onTapFunction);
          } else if (onTapFunction is VoidCallback) {
            onTapFunction();
          }
        }
      },
      child: Container(
        width: isTitle ? 140 : 36,
        child: menu is IconData
            ? Icon(menu)
            : menu is String
                ? Text(
                    menu,
                    style: isTitle
                        ? Theme.of(context).textTheme.titleMedium
                        : Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .appBarTheme
                                  .iconTheme!
                                  .color,
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
