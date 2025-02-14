import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';
import '../../cubits/collection.dart';

class CardImageWidget extends StatefulWidget {
  final CardEntity? card;
  final bool isCustom;

  const CardImageWidget({
    Key? key,
    this.card,
    this.isCustom = false,
  }) : super(key: key);

  @override
  _CardImageWidgetState createState() => _CardImageWidgetState();
}

class _CardImageWidgetState extends State<CardImageWidget> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return widget.isCustom
        ? _buildDottedPlaceholder(locale, theme)
        : _buildCardImage(locale, theme, widget.card);
  }

  Widget _buildDottedPlaceholder(AppLocalizations locale, ThemeData theme) => BlocBuilder<CollectionCubit, CollectionState>(
    builder: (context, state) {
      final imageUrl = state.imageUrl;
      return AspectRatio(
        aspectRatio: 3 / 4,
        child: GestureDetector(
          onTap: _pickImage,
          child: DottedBorder(
            color: Colors.white.withOpacity(0.4),
            borderType: BorderType.RRect,
            radius: const Radius.circular(16.0),
            dashPattern: const [14.0, 24.0],
            strokeWidth: 2,
            child: imageUrl == ''
                ? _buildPlaceholderContent(locale, theme, Icons.upload_rounded, 'text.upload_image')
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: Image.file(File(imageUrl!), fit: BoxFit.cover),
                    ),
                  ),
          ),
        ),
      );
    },
  );

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      context.read<CollectionCubit>().setImageUrl(pickedFile.path);
    }
  }

  Widget _buildCardImage(AppLocalizations locale, ThemeData theme, CardEntity? card) {
    if (card?.imageUrl == null) {
      return _buildErrorImage(locale, theme);
    }
    return Container(
      decoration: _buildBoxDecoration(theme),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Image.network(
            card!.imageUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildErrorImage(locale, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorImage(AppLocalizations locale, ThemeData theme) => _buildPlaceholderContent(
    locale,
    theme,
    Icons.image_not_supported,
    'text.no_card_image',
  );

  Widget _buildPlaceholderContent(AppLocalizations locale, ThemeData theme, IconData icon, String textKey) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 36.0, color: Colors.grey),
        const SizedBox(height: 8.0),
        Text(
          locale.translate(textKey),
          style: theme.textTheme.titleSmall,
        ),
      ],
    ),
  );

  BoxDecoration _buildBoxDecoration(ThemeData theme) => BoxDecoration(
    color: theme.appBarTheme.backgroundColor,
    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        offset: const Offset(3.0, 4.0),
        blurRadius: 12.0,
        spreadRadius: 2.0,
      ),
    ],
  );
}
