import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nfc_project/core/routes/route.dart';
import '../../blocs/app_state.dart';

class SupportedGameLabelWidget extends StatelessWidget {
  final String game;
  final String description;
  final String imagePath;
  final bool isAdd;

  const SupportedGameLabelWidget({
    Key? key,
    required this.game,
    required this.description,
    required this.imagePath,
    this.isAdd = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<AppStateCubit>();
    return GestureDetector(
      onTap: () {
        cubit.updateSelectedGame(game);
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.search,
          arguments: {'game': game, 'isAdd': isAdd},
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        height: 60,
        decoration: BoxDecoration(
          color: theme.appBarTheme.backgroundColor,
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(imagePath),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
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
                      description.split('//')[1],
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
