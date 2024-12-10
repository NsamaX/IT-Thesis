import 'package:flutter/material.dart';

class SettingsLabelWidget extends StatelessWidget {
  final List<Map<String, dynamic>> label;

  const SettingsLabelWidget({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: label.map<Widget>(
        (category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(theme, category['title'] as String),
              ..._buildContentList(context, theme, category['content'] as List<dynamic>),
            ],
          );
        },
      ).toList(),
    );
  }

  Widget _buildTitle(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.secondaryHeaderColor),
      ),
    );
  }

  List<Widget> _buildContentList(BuildContext context, ThemeData theme, List<dynamic> content) {
    return content.map<Widget>((item) {
      return _buildContent(
        context: context,
        theme: theme,
        icon: item['icon'] as IconData?,
        text: item['text'] as String,
        onTap: item['onTap'],
      );
    }).toList();
  }

  void _handleTap(BuildContext context, dynamic onTap) {
    if (onTap != null) {
      if (onTap is String) {
        Navigator.pushNamed(context, onTap);
      } else if (onTap is VoidCallback) {
        onTap();
      }
    }
  }

  Widget _buildContent({
    required BuildContext context,
    required ThemeData theme,
    IconData? icon,
    required String text,
    dynamic onTap,
  }) {
    return GestureDetector(
      onTap: () => _handleTap(context, onTap),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: theme.appBarTheme.backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.6),
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              icon != null ? Icon(icon) : const SizedBox.shrink(),
              const SizedBox(width: 12),
              Text(text, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
