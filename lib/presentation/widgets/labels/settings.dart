import 'package:flutter/material.dart';

class SettingsLabelWidget extends StatelessWidget {
  final List<Map<String, dynamic>> label;

  const SettingsLabelWidget({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: label.map((category) {
        final title = category['title'] as String?;
        final content = category['content'] as List<dynamic>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) _buildTitle(theme, title),
            ..._buildContentList(context, theme, content),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTitle(ThemeData theme, String title) => Padding(
    padding: const EdgeInsets.only(left: 20.0, top: 16.0, bottom: 8.0),
    child: Text(
      title,
      style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
    ),
  );

  List<Widget> _buildContentList(
    BuildContext context,
    ThemeData theme,
    List<dynamic> content,
  ) => content.map((item) {
    final icon = item['icon'] as IconData?;
    final text = item['text'] as String;
    final info = item['info'] as String?;
    final select = item['select'] as bool?;
    final onTap = item['onTap'];

    return _buildContentItem(context, theme, onTap, icon, text, info, select);
  }).toList();

  Widget _buildContentItem(
    BuildContext context,
    ThemeData theme,
    dynamic onTap,
    IconData? icon,
    String text,
    String? info,
    bool? select,
  ) {
    final hasRoute = onTap is String;

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
                Text(
                  text,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
            Row(
              children: [
                if (info != null) Text(info, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey)),
                if (info != null) const SizedBox(width: 6.0),
                if (hasRoute) const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey),
                if (!hasRoute && select == true) const Icon(Icons.check_rounded, size: 18.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleOnTap(BuildContext context, dynamic onTap) {
    if (onTap is String) {
      Navigator.pushNamed(context, onTap);
    } else if (onTap is VoidCallback) {
      onTap();
    }
  }
}
