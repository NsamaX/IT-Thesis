import 'package:flutter/material.dart';
import '../../core/locales/localizations.dart';
import '../../domain/entities/card.dart';
import '../../core/routes/route.dart';

class CardLabelWidget extends StatelessWidget {
  final CardEntity? card;
  final bool lightTheme;

  const CardLabelWidget({
    Key? key,
    this.card,
    this.lightTheme = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.cardDetail,
          arguments: {
            'card': card,
            'isCustom': false,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        height: 60,
        decoration: BoxDecoration(
          color: lightTheme
              ? Colors.white
              : Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              buildImage(card?.imageUrl),
              const SizedBox(width: 12),
              buildText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImage(String? imageUrl) {
    return SizedBox(
      width: 36,
      height: 36,
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/default_card.png',
                    fit: BoxFit.cover,
                  );
                },
              ),
            )
          : Image.asset(
              'assets/images/default_card.png',
              fit: BoxFit.cover,
            ),
    );
  }

  Widget buildText(BuildContext context) {
    final textColor = lightTheme ? Colors.black : null;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            card?.name ??
                AppLocalizations.of(context).translate('no_card_name'),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: textColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            card?.description ??
                AppLocalizations.of(context).translate('no_card_description'),
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: textColor),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
