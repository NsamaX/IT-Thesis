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
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _navigateToCardPage(context),
      child: _buildContainer(locale, theme),
    );
  }

  void _navigateToCardPage(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.card,
      arguments: {'card': card, 'isAdd': isAdd, 'isCustom': isCustom},
    );
  }

  Widget _buildContainer(AppLocalizations locale, ThemeData theme) {
    final color = lightTheme ? Colors.black : null;

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
            _buildImage(theme, color: color),
            const SizedBox(width: 12.0),
            Expanded(child: _buildCardInfo(locale, theme, color: color)),
            const SizedBox(width: 16.0),
            if (count != null) _buildCount(theme, color),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme, {Color? color}) {
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
                errorBuilder: (_, __, ___) => _buildFallbackIcon(color),
              ),
            )
          : _buildFallbackIcon(color),
    );
  }

  Widget _buildFallbackIcon(Color? color) {
    return Icon(
      Icons.image_not_supported,
      size: 36.0,
      color: color,
    );
  }

  Widget _buildCardInfo(AppLocalizations locale, ThemeData theme, {Color? color}) {
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

  Widget _buildCount(ThemeData theme, Color? color) {
    return Text(
      count.toString(),
      style: theme.textTheme.titleMedium?.copyWith(color: color),
    );
  }
}
