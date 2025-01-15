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
              _buildTitle(context, title: category['title'] as String),
              ..._buildContentList(context, content: category['content'] as List<dynamic>),
            ],
          );
        },
      ).toList(),
    );
  }

  Widget _buildTitle(
    BuildContext context, {
    required String title,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor),
      ),
    );
  }

  List<Widget> _buildContentList(
    BuildContext context, {
    required List<dynamic> content,
  }) {
    return content.map<Widget>((item) {
      return _buildContent(
        context,
        onTap: item['onTap'],
        icon: item['icon'] as IconData,
        text: item['text'] as String,
      );
    }).toList();
  }

  Widget _buildContent(
    BuildContext context, {
    required dynamic onTap,
    required IconData icon,
    required String text,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if (onTap == null) return;
        if (onTap is String) {
          Navigator.pushNamed(context, onTap);
        } else if (onTap is VoidCallback) {
          onTap();
        }
      },
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
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 12.0),
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
}
