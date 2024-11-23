import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../core/locales/localizations.dart';
import '../../domain/entities/card.dart';

class CardInfoWidget extends StatelessWidget {
  const CardInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final CardEntity? card = arguments?['card'];
    final bool isCustom = arguments?['isCustom'] ?? false;

    return Padding(
      padding: const EdgeInsets.all(40),
      child: ListView(
        children: [
          if (isCustom)
            buildDottedBorder(context)
          else
            buildCardImage(context, card),
          const SizedBox(height: 26),
          Text(
            AppLocalizations.of(context).translate('card_description'),
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          buildDescription(context, card, isCustom),
        ],
      ),
    );
  }

  Widget buildDottedBorder(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: DottedBorder(
        color: Colors.white.withOpacity(0.4),
        borderType: BorderType.RRect,
        radius: const Radius.circular(16),
        dashPattern: const [16, 26],
        strokeWidth: 2,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.upload_rounded,
                size: 36,
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context).translate('upload_image'),
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardImage(BuildContext context, CardEntity? card) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AspectRatio(
        aspectRatio: 3 / 4,
        child: card != null
            ? Image.network(
                card.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return buildErrorImage(context);
                },
              )
            : buildErrorImage(context),
      ),
    );
  }

  Widget buildErrorImage(BuildContext context) {
    return Container(
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_not_supported,
              size: 36,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).translate('no_card_image'),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDescription(
      BuildContext context, CardEntity? card, bool isCustom) {
    if (isCustom) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.edit_rounded),
        ],
      );
    }

    if (card == null) {
      return Opacity(
        opacity: 0.6,
        child: Text(
          AppLocalizations.of(context).translate('no_card_info'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    if (card.additionalData == null) {
      return Opacity(
        opacity: 0.6,
        child: Text(
          card.description ??
              AppLocalizations.of(context).translate('no_card_description'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    return Opacity(
      opacity: 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: card.additionalData!.entries.map<Widget>((entry) {
          return entry.value is String && entry.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${entry.key}: ',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: '${entry.value}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                )
              : entry.value is int || entry.value is double
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${entry.key}: ',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextSpan(
                              text: '${entry.value}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  : const SizedBox();
        }).toList(),
      ),
    );
  }
}
