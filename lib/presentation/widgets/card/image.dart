import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
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
            color: Colors.white.withAlpha((0.4 * 255).toInt()),
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
      final String savedPath = await _saveImageToPermanentDirectory(pickedFile.path);
      context.read<CollectionCubit>().setImageUrl(savedPath);
    }
  }

  Future<String> _saveImageToPermanentDirectory(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final String newPath = '${directory.path}/${imagePath.split('/').last}';
    final File imageFile = File(imagePath);
    final File newImage = await imageFile.copy(newPath);
    return newImage.path;
  }

  Widget _buildCardImage(AppLocalizations locale, ThemeData theme, CardEntity? card) {
    if (card?.imageUrl == null || card!.imageUrl!.isEmpty) {
      return _buildErrorImage(locale, theme);
    }
    final String imageUrl = card.imageUrl!;
    final bool isNetworkImage = imageUrl.startsWith('http');
    final bool isLocalFile = File(imageUrl).existsSync();
    return Container(
      decoration: _buildBoxDecoration(theme),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: isNetworkImage
              ? Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildErrorImage(locale, theme),
                )
              : isLocalFile
                  ? Image.file(
                      File(imageUrl),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _buildErrorImage(locale, theme),
                    )
                  : _buildErrorImage(locale, theme),
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
        color: Colors.black.withAlpha((0.2 * 255).toInt()),
        offset: const Offset(3.0, 4.0),
        blurRadius: 12.0,
        spreadRadius: 2.0,
      ),
    ],
  );
}
