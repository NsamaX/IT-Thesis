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
      onTap: () {
        context.read<AppStateCubit>().updateSelectedGame(game);
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.search,
          arguments: {'game': game, 'isAdd': isAdd},
        );
      },
      child: _buildContainer(context),
    );
  }

  Widget _buildContainer(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 6.0),
      height: 60.0,
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
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
            _buildGameInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 36.0,
      height: 36.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.asset(imagePath),
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
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
          const SizedBox(height: 4.0),
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