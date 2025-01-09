import 'package:flutter/material.dart';

class SettingsLabelWidget extends StatelessWidget {
  final List<Map<String, dynamic>> label;

  const SettingsLabelWidget({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: label.map<Widget>(
        (category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(context, category['title'] as String),
              ..._buildContentList(context, category['content'] as List<dynamic>),
            ],
          );
        },
      ).toList(),
    );
  }

  Widget _buildTitle(
      BuildContext context, 
      String text,
    ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.primary),
      ),
    );
  }

  List<Widget> _buildContentList(
      BuildContext context, 
      List<dynamic> content,
    ) {
    return content.map<Widget>((item) {
      return _buildContent(
        context,
        icon: item['icon'] as IconData,
        text: item['text'] as String,
        onTap: item['onTap'],
      );
    }).toList();
  }

  Widget _buildContent(
    BuildContext context, {
    required IconData icon,
    required String text,
    required dynamic onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _handleTap(context, onTap),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: theme.appBarTheme.backgroundColor,
          border: const Border(
            bottom: BorderSide(
              color: Colors.white60,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12),
              Text(
                text,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(
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
