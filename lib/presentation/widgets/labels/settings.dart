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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context, theme, title: category['title'] as String),
            ..._buildContentList(context, theme, content: category['content'] as List<dynamic>),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTitle(
    BuildContext context, 
    ThemeData theme, {
    required String title,
  }) {
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
    ThemeData theme, {
    required List<dynamic> content,
  }) {
    return content.map((item) {
      return _buildContentItem(
        context,
        theme,
        onTap: item['onTap'],
        icon: item['icon'] as IconData,
        text: item['text'] as String,
        arrow: item['arrow'] as String?,
      );
    }).toList();
  }

  Widget _buildContentItem(
    BuildContext context,
    ThemeData theme, {
    required dynamic onTap,
    required IconData icon,
    required String text,
    String? arrow,
  }) {
    final hasRoute = onTap is String;

    return GestureDetector(
      onTap: () => _handleOnTap(context, onTap),
      child: Container(
        height: 40.0,
        decoration: BoxDecoration(
          color: theme.appBarTheme.backgroundColor,
          border: const Border(
            bottom: BorderSide(
              color: Colors.white60,
              width: 1.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 12.0),
                  Text(
                    text,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              Row(
                children: [
                  if (arrow != null)
                    Text(
                      arrow,
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  SizedBox(width: arrow != null ? 6.0 : 0.0),
                  if (hasRoute)
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOnTap(BuildContext context, dynamic onTap) {
    if (onTap == null) return;
    if (onTap is String) {
      Navigator.pushNamed(context, onTap);
    } else if (onTap is VoidCallback) {
      onTap();
    }
  }
}
