import 'package:flutter/material.dart';

class SettingLabelWidget extends StatelessWidget {
  final List<Map<String, dynamic>> label;

  const SettingLabelWidget({
    super.key, 
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox();

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: label.map((category) {
          final String? title = category['title'];
          final List<dynamic> content = category['content'] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) _buildTitle(theme, title),
              ..._buildContentList(context, theme, content),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTitle(
    ThemeData theme, 
    String title,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
      ),
    );
  }

  List<Widget> _buildContentList(
    BuildContext context, 
    ThemeData theme, 
    List<dynamic> content,
  ) {
    return content.map((item) {
      return _buildContentItem(
        context: context,
        theme: theme,
        onTap: item['onTap'],
        icon: item['icon'] as IconData?,
        text: item['text'] as String,
        info: item['info'] as String?,
        select: item['select'] as bool? ?? false,
        show: item['arrow'] as bool? ?? false,
      );
    }).toList();
  }

  Widget _buildContentItem({
    required BuildContext context,
    required ThemeData theme,
    required dynamic onTap,
    IconData? icon,
    required String text,
    String? info,
    required bool select,
    required bool show,
  }) {
    final bool hasRoute = onTap is String;

    return GestureDetector(
      onTap: () => _handleOnTap(context, onTap),
      child: Container(
        height: 40.0,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          color: theme.appBarTheme.backgroundColor,
          border: const Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon),
                  const SizedBox(width: 12.0),
                ],
                Text(text, style: theme.textTheme.bodySmall),
              ],
            ),
            Row(
              children: [
                if (info != null) ...[
                  Text(info, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                  const SizedBox(width: 6.0),
                ],
                if (hasRoute) const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                if (select) const Icon(Icons.check_rounded, size: 18.0, color: Colors.grey),
                if (show) const Icon(Icons.arrow_outward_rounded, size: 16.0, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleOnTap(
    BuildContext context, 
    dynamic onTap,
  ) {
    if (onTap == null) return;
    if (onTap is String) {
      Navigator.pushNamed(context, onTap);
    } else if (onTap is VoidCallback) {
      onTap();
    }
  }
}
