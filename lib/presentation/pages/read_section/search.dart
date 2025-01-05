import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/usecases/cards_management.dart';
import '../../cubits/search.dart';
import '../../widgets/label/card.dart';
import '../../widgets/navigation_bar/app.dart';
import '../../widgets/search.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final arguments = _getArguments(context);
    final syncCardsUseCase = GetIt.instance<SyncCardsUseCase>(param1: arguments['game']);

    // Use BlocProvider to scope the SearchCubit to this page
    return BlocProvider<SearchCubit>(
      create: (_) => SearchCubit(syncCardsUseCase)..syncCards(arguments['game']),
      child: Builder(
        // Use Builder to ensure the correct context for reading the Bloc
        builder: (context) {
          return Scaffold(
            appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
            body: Column(
              children: [
                SearchBarWidget(
                  onSearchChanged: (query) =>
                      context.read<SearchCubit>().searchCards(query),
                  onSearchCleared: () =>
                      context.read<SearchCubit>().clearSearch(),
                ),
                const SizedBox(height: 8),
                _buildBody(context, arguments),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> _getArguments(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Map<String, dynamic>) {
      return {
        'game': arguments['game'] ?? '',
        'isAdd': arguments['isAdd'] ?? false,
        'isCustom': arguments['isCustom'] ?? false,
      };
    }
    return {'game': '', 'isAdd': false, 'isCustom': false};
  }

  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) {
    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      locale.translate('title.search'): null,
      null: null,
    };
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> arguments) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state.errorMessage != null) {
          return Expanded(
            child: Center(
              child: Text(state.errorMessage!.isNotEmpty
                  ? state.errorMessage!
                  : AppLocalizations.of(context).translate('search.error')),
            ),
          );
        } else {
          return _buildCardList(context, state.cards, arguments);
        }
      },
    );
  }

  Widget _buildCardList(BuildContext context, List<CardEntity> cards, Map<String, dynamic> arguments) {
    if (cards.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(AppLocalizations.of(context).translate('search.no_results')),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          return CardLabelWidget(
            card: cards[index],
            isAdd: arguments['isAdd'],
            isCustom: arguments['isCustom'],
          );
        },
        cacheExtent: 1000,
      ),
    );
  }
}
