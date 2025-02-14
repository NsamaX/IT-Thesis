import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/domain/entities/card.dart';

class CardLabelWidget extends StatelessWidget {
  final CardEntity? card;
  final int? count;
  final bool isNFC;
  final bool isAdd;
  final bool isCustom;
  final bool lightTheme;

  const CardLabelWidget({
    Key? key,
    this.card,
    this.count,
    this.isNFC = true,
    this.isAdd = false,
    this.isCustom = false,
    this.lightTheme = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final color = lightTheme ? Colors.black : null;
    return GestureDetector(
      onTap: () => _navigateToCardPage(context),
      child: _buildContainer(locale, theme, color),
    );
  }

  void _navigateToCardPage(BuildContext context) => Navigator.of(context).pushNamed(
    AppRoutes.card,
    arguments: {'card': card, 'isNFC': isNFC, 'isAdd': isAdd, 'isCustom': isCustom},
  );

  Widget _buildContainer(AppLocalizations locale, ThemeData theme, Color? color) => Container(
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
    child: Row(
      children: [
        const SizedBox(width: 8.0),
        _buildImage(theme, color),
        const SizedBox(width: 8.0),
        Expanded(child: _buildCardInfo(locale, theme, color)),
        const SizedBox(width: 8.0),
        if (count != null) ...[
          _buildCount(theme, color),
          const SizedBox(width: 22.0),
        ],
      ],
    ),
  );

  Widget _buildImage(ThemeData theme, Color? color) {
    if (card?.imageUrl == null || card!.imageUrl!.isEmpty) {
      return _buildFallbackIcon(color);
    }
    final String imageUrl = card!.imageUrl!;
    final bool isNetworkImage = imageUrl.startsWith('http');
    final bool isLocalFile = File(imageUrl).existsSync();
    return Container(
      width: 42.0,
      height: 42.0,
      decoration: BoxDecoration(
        color: lightTheme ? Colors.white : theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: isNetworkImage
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildFallbackIcon(color),
              )
            : isLocalFile
                ? Image.file(
                    File(imageUrl),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallbackIcon(color),
                  )
                : _buildFallbackIcon(color),
      ),
    );
  }

  Widget _buildFallbackIcon(Color? color) => Icon(
    Icons.image_not_supported,
    size: 36.0,
    color: color,
  );

  Widget _buildCardInfo(AppLocalizations locale, ThemeData theme, Color? color) => Column(
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

  Widget _buildCount(ThemeData theme, Color? color) => Text(
    count.toString(),
    style: theme.textTheme.titleMedium?.copyWith(color: color),
  );
}
