import 'package:flutter/material.dart';
import '../../../core/locales/localizations.dart';
import '../../../core/routes/route.dart';
import '../../../domain/entities/card.dart';

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
    final theme = Theme.of(context);
    final textColor = lightTheme ? Colors.black : null;
    final iconColor = theme.appBarTheme.backgroundColor ?? Colors.black;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          AppRoutes.cardInfo,
          arguments: {'card': card, 'isAdd': isAdd, 'isCustom': isCustom},
        );
      },
      child: Container(
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
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: card?.imageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          card!.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.image_not_supported,
                            size: 36,
                            color: iconColor,
                          ),
                        ),
                      )
                    : Icon(
                        Icons.image_not_supported,
                        size: 36,
                        color: iconColor,
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      card?.name ?? AppLocalizations.of(context).translate('card_info.no_name'),
                      style: theme.textTheme.bodyMedium?.copyWith(color: textColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card?.description ?? AppLocalizations.of(context).translate('card_info.no_description'),
                      style: theme.textTheme.bodySmall?.copyWith(color: textColor),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (count != null) ...[
                Text(
                  count.toString(),
                  style: theme.textTheme.titleMedium?.copyWith(color: textColor),
                ),
              ],
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
