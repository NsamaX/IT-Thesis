import 'package:flutter/material.dart';

class LabelWidget extends StatelessWidget {
  final List<Map<String, dynamic>> label;

  const LabelWidget({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: label.map<Widget>((category) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildTitle(context: context, text: category['title'] as String),
            ...category['content'].map<Widget>((item) {
              return buildContent(
                context: context,
                icon: item['icon'] as IconData,
                text: item['text'] as String,
                onTap: item['onTap'],
              );
            }).toList(),
          ],
        );
      }).toList(),
    );
  }

  Widget buildTitle({required BuildContext context, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 16, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: Theme.of(context).secondaryHeaderColor),
      ),
    );
  }

  Widget buildContent({
    required BuildContext context,
    required dynamic icon,
    required String text,
    dynamic onTap,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          if (onTap is String) {
            Navigator.pushNamed(context, onTap);
          } else if (onTap is VoidCallback) {
            onTap();
          }
        }
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
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
              Text(text, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ),
    );
  }
}
