import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/core/routes/routes.dart';
import 'package:nfc_project/domain/entities/card.dart';

class CardLabelWidget extends StatelessWidget {
  final CardEntity? card;
  final int? count;
  final bool isNFC, isAdd, isCustom, isTrack, lightTheme;
  final Color? cardColors;
  final void Function(Color color)? changeCardColor;
  final void Function()? onDelete;

  const CardLabelWidget({
    Key? key,
    this.card,
    this.count,
    this.isNFC = true,
    this.isAdd = false,
    this.isCustom = false,
    this.isTrack = false,
    this.lightTheme = false,
    this.cardColors,
    this.changeCardColor,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final color = lightTheme ? Colors.black : null;
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        AppRoutes.card,
        arguments: {'card': card, 'isNFC': isNFC, 'isAdd': isAdd, 'isCustom': isCustom},
      ),
      child: _buildContainer(context, locale, theme, color),
    );
  }

  Widget _buildContainer(BuildContext context, AppLocalizations locale, ThemeData theme, Color? color) {
    final backgroundColor = lightTheme ? Colors.white : theme.appBarTheme.backgroundColor;
    final pinColor = cardColors ?? backgroundColor;
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      height: 60.0,
      decoration: BoxDecoration(
        color: pinColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.2 * 255).toInt()),
            offset: const Offset(0, 3),
            blurRadius: 2,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
          child: Slidable(
            key: ValueKey(card?.cardId ?? UniqueKey()),
            endActionPane: _buildSlidableActions(context, theme, backgroundColor),
            child: Row(
              children: [
                _buildImage(theme, color),
                const SizedBox(width: 8.0),
                Expanded(child: _buildCardInfo(locale, theme, color)),
                const SizedBox(width: 8.0),
                if (count != null) _buildCount(theme, color),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ActionPane? _buildSlidableActions(BuildContext context, ThemeData theme, Color? backgroundColor) {
    if (!isTrack) return null;
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
    ];
    return ActionPane(
      motion: const StretchMotion(),
      extentRatio: (60.0 * colors.length) / MediaQuery.of(context).size.width,
      children: colors
          .map((color) => SlidableAction(
                onPressed: (_) => _toggleColor(color, backgroundColor),
                backgroundColor: color,
                foregroundColor: theme.appBarTheme.backgroundColor,
                icon: cardColors == color ? Icons.close_rounded : Icons.push_pin_rounded,
              ))
          .toList(),
    );
  }

  void _toggleColor(Color targetColor, Color? backgroundColor) {
    changeCardColor?.call(cardColors == targetColor ? backgroundColor! : targetColor);
  }

  Widget _buildImage(ThemeData theme, Color? color) {
    final imageUrl = card?.imageUrl;
    final isNetworkImage = imageUrl?.startsWith('http') ?? false;
    final isLocalFile = imageUrl != null && File(imageUrl).existsSync();

    return Container(
      width: 42.0,
      height: 42.0,
      decoration: BoxDecoration(
        color: lightTheme ? Colors.white : theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: (imageUrl?.isEmpty ?? true)
            ? _buildFallbackIcon(color)
            : isNetworkImage
                ? Image.network(imageUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildFallbackIcon(color))
                : isLocalFile
                    ? Image.file(File(imageUrl), fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildFallbackIcon(color))
                    : _buildFallbackIcon(color),
      ),
    );
  }

  Widget _buildFallbackIcon(Color? color) => Icon(Icons.image_not_supported, size: 36.0, color: color);

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

  Widget _buildCount(ThemeData theme, Color? color) => Padding(
    padding: const EdgeInsets.only(right: 22.0),
    child: Text(count.toString(), style: theme.textTheme.titleMedium?.copyWith(color: color)),
  );
}
