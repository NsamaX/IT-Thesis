import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/entities/card.dart';
import 'package:nfc_project/domain/usecases/sync_cards.dart';
import '../../blocs/search.dart';
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

    return BlocProvider<SearchBloc>(
      create: (_) => SearchBloc(syncCardsUseCase)..add(SyncCardsEvent(arguments['game'])),
      child: Scaffold(
        appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
        body: Column(
          children: [
            const SearchBarWidget(),
            SizedBox(height: 8),
            _buildBody(context, arguments),
          ],
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
        'isCustom': arguments['isCustom'] ?? false,
      };
    }
    return {'game': '', 'isAdd': false, 'isCustom': false};
  }

  Map<dynamic, dynamic> _buildAppBarMenu(AppLocalizations locale) {
    return {
      Icons.arrow_back_ios_new_rounded: '/back',
      locale.translate('search.title'): null,
      null: null,
    };
  }

  Widget _buildBody(BuildContext context, Map<String, dynamic> arguments) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchInitial || state is SearchLoading) {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is SearchLoaded) {
          return _buildCardList(context, state.cards, arguments);
        } else if (state is SearchError) {
          final locale = AppLocalizations.of(context);
          return Expanded(
            child: Center(
              child: Text(state.message.isNotEmpty
                  ? state.message
                  : locale.translate('search.error')),
            ),
          );
        } else {
          return const Expanded(
            child: Center(child: CircularProgressIndicator()),
          );
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
