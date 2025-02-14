import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/routes/routes.dart';
import '../../cubits/app_state.dart';

class GameLabelWidget extends StatelessWidget {
  final String game;
  final String? imagePath;
  final String description;
  final bool isAdd;
  final bool isCustom;

  const GameLabelWidget({
    Key? key,
    required this.game,
    this.imagePath,
    required this.description,
    this.isAdd = false,
    this.isCustom = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => _navigateToSearch(context),
      child: _buildContainer(theme),
    );
  }

  void _navigateToSearch(BuildContext context) {
    final cubit = context.read<AppCubit>();
    final String selectedGame = isCustom ? 'my_collection' : game;
    cubit.updateSelectedGame(selectedGame);
    Navigator.of(context).pushReplacementNamed(
      AppRoutes.search,
      arguments: {'game': selectedGame, 'isAdd': isAdd},
    );
  }

  Widget _buildContainer(ThemeData theme) => Container(
    margin: const EdgeInsets.only(bottom: 6.0),
    height: 60.0,
    decoration: BoxDecoration(
      color: theme.appBarTheme.backgroundColor,
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((0.2 * 255).toInt()),
          spreadRadius: 1.0,
          blurRadius: 2.0,
          offset: const Offset(0.0, 3.0),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        children: [
          _buildImage(),
          const SizedBox(width: 12.0),
          _buildGameInfo(theme),
        ],
      ),
    ),
  );

  Widget _buildImage() => Container(
    width: 36.0,
    height: 36.0,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: imagePath != null
          ? Image.asset(imagePath!, fit: BoxFit.cover)
          : const Icon(
            Icons.inbox_rounded,
            color: Colors.black,
            size: 24.0,
          ),
    ),
  );

  Widget _buildGameInfo(ThemeData theme) => Expanded(
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
        const SizedBox(height: 4.0),
        Text(
          _extractDescription(description),
          style: theme.textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    ),
  );

  String _extractDescription(String description) => description.split('//').length > 1 ? description.split('//')[1] : description;
}
