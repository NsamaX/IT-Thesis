import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/usecases/card.dart';
import '../cubits/search.dart';
import '../widgets/app_bar.dart';
import '../widgets/card_list.dart';
import '../widgets/search_bar.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  //---------------------------------- Build ---------------------------------//
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final arguments = _getArguments(context);
    final syncCardsUseCase = GetIt.instance<SyncCardsUseCase>(param1: arguments['game']);
    return BlocProvider<SearchCubit>(
      create: (_) => SearchCubit(syncCardsUseCase)..syncCards(arguments['game']),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
          body: Column(
            children: [
              SearchBarWidget(
                onSearchChanged: (query) => context.read<SearchCubit>().searchCards(query),
                onSearchCleared: () => context.read<SearchCubit>().clearSearch(),
              ),
              const SizedBox(height: 8),
              _buildBody(context, arguments),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _getArguments(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments is Map<String, dynamic>) {
      return {
        'game': arguments['game'] ?? '',
        'isAdd': arguments['isAdd'] ?? false,
      };
    }
    return {'game': '', 'isAdd': false};
  }

  //--------------------------------- App Bar --------------------------------//
  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) => {
    Icons.arrow_back_ios_new_rounded: '/back',
    locale.translate('title.search'): null,
    null: null,
  };
  
  //---------------------------------- Body ----------------------------------//
  Widget _buildBody(BuildContext context, Map<String, dynamic> arguments) => BlocBuilder<SearchCubit, SearchState>(
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
                : AppLocalizations.of(context).translate('text.internet_error')),
          ),
        );
      }
      return Expanded(
        child: CardListWidget(
          cards: state.searchedCards,
          isAdd: arguments['isAdd'],
        ),
      );
    },
  );
}
