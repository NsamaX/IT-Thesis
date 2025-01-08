import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/domain/entities/card.dart';

class CardLabelWidget extends StatelessWidget {
  final CardEntity? card;
  final int? count;
  final bool isAdd;
  final bool isCustom;
  final bool lightTheme;

  const CardLabelWidget({
    Key? key,
    this.card,
    this.count,
    this.isAdd = false,
    this.isCustom = false,
    this.lightTheme = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        AppRoutes.card,
        arguments: {'card': card, 'isAdd': isAdd, 'isCustom': isCustom},
      ),
      child: _buildContainer(context: context, textColor: lightTheme ? Colors.black : null),
    );
  }

  Widget _buildContainer({
      required BuildContext context,
      required Color? textColor,
    }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      height: 60,
      decoration: BoxDecoration(
        color: lightTheme ? Colors.white : theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            _buildImage(context: context, textColor: textColor),
            const SizedBox(width: 12),
            Expanded(child: _buildCardInfo(context: context, textColor: textColor)),
            const SizedBox(width: 16),
            if (count != null) ...[
              Text(
                count.toString(),
                style: theme.textTheme.titleMedium?.copyWith(color: textColor),
              ),
              const SizedBox(width: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage({
      required BuildContext context,
      required Color? textColor,
    }) {
    final theme = Theme.of(context);

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: lightTheme ? Colors.white : theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: card?.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: Image.network(
                card!.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported, size: 36, color: textColor),
              ),
            )
          : Icon(Icons.image_not_supported, size: 36, color: textColor),
    );
  }

  Widget _buildCardInfo({
      required BuildContext context,
      required Color? textColor,
    }) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          card?.name ?? locale.translate('text.no_card_name'),
          style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 4),
        Text(
          card?.description ?? locale.translate('text.no_card_description'),
          style: theme.textTheme.bodySmall?.copyWith(color: textColor),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
