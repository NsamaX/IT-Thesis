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
      child: _buildContainer(context, color: lightTheme ? Colors.black : null),
    );
  }

  Widget _buildContainer(
    BuildContext context, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      height: 60.0,
      decoration: BoxDecoration(
        color: lightTheme ? Colors.white : theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0.0, 3.0),
            blurRadius: 2.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: [
            _buildImage(context, color: color),
            const SizedBox(width: 12.0),
            Expanded(child: _buildCardInfo(context, color: color)),
            const SizedBox(width: 16.0),
            if (count != null) ...[
              Text(
                count.toString(),
                style: theme.textTheme.titleMedium?.copyWith(color: color),
              ),
              const SizedBox(width: 12.0),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage(
    BuildContext context, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: 42.0,
      height: 42.0,
      decoration: BoxDecoration(
        color: lightTheme ? Colors.white : theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: card?.imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                card!.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.image_not_supported, 
                  size: 36.0, 
                  color: color,
                ),
              ),
            )
          : Icon(
              Icons.image_not_supported, 
              size: 36.0, 
              color: color,
            ),
    );
  }

  Widget _buildCardInfo(
    BuildContext context, { 
    Color? color,
  }) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          card?.name ?? locale.translate('text.no_card_name'),
          style: theme.textTheme.bodyMedium?.copyWith(color: color),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(height: 4.0),
        Text(
          card?.description ?? locale.translate('text.no_card_description'),
          style: theme.textTheme.bodySmall?.copyWith(color: color),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
