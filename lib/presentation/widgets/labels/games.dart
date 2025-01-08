import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/routes/routes.dart';
import '../../cubits/app_state.dart';

class GamesLabelWidget extends StatelessWidget {
  final String game;
  final String imagePath;
  final String description;
  final bool isAdd;

  const GamesLabelWidget({
    Key? key,
    required this.game,
    required this.imagePath,
    required this.description,
    this.isAdd = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context: context),
      child: _buildContainer(context: context),
    );
  }

  void _handleTap({required BuildContext context}) {
    context.read<AppStateCubit>().updateSelectedGame(game);
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.search,
      arguments: {'game': game, 'isAdd': isAdd},
    );
  }

  Widget _buildContainer({required BuildContext context}) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      height: 60,
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(12)),
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
            _buildImage(),
            const SizedBox(width: 12),
            _buildGameInfo(context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        child: Image.asset(imagePath),
      ),
    );
  }

  Widget _buildGameInfo({required BuildContext context}) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            game,
            style: theme.textTheme.bodyMedium,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 4),
          Text(
            _extractDescription(description: description),
            style: theme.textTheme.bodySmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  String _extractDescription({required String description}) {
    final parts = description.split('//');

    return parts.length > 1 ? parts[1] : description;
  }
}
