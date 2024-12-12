import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nfc_project/core/locales/localizations.dart';
import 'package:nfc_project/domain/usecases/fetch_cards.dart';
import '../../blocs/search.dart';
import '../../widgets/label/card.dart';
import '../../widgets/navigation_bar/app.dart';
import '../../widgets/search.dart';

class SearchPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final arguments = _getArguments(context);
    final fetchCardsPageUseCase = GetIt.instance<FetchCardsPageUseCase>(param1: arguments['game']);

    return BlocProvider(
      create: (_) => SearchBloc(fetchCardsPageUseCase),
      child: Scaffold(
        appBar: AppBarWidget(menu: _buildAppBarMenu(locale)),
        body: Column(
          children: [
            const SearchBarWidget(),
            _buildBody(context, arguments),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getArguments(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    return {
      'game': arguments?['game'] ?? '',
      'isAdd': arguments?['isAdd'] ?? false,
      'isCustom': arguments?['isCustom'] ?? false,
    };
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
        if (state is SearchInitial) {
          context.read<SearchBloc>().add(FetchPageEvent(1));
          return const Center(child: CircularProgressIndicator());
        } else if (state is SearchLoaded) {
          return _buildCardList(context, state, arguments);
        } else if (state is SearchError) {
          final locale = AppLocalizations.of(context);
          return Center(child: Text(locale.translate('search.error')));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCardList(BuildContext context, SearchLoaded state, Map<String, dynamic> arguments) {
    final searchBloc = context.read<SearchBloc>();
    _setupScrollListener(searchBloc);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: state.cards.length + (state.hasNextPage ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < state.cards.length) {
              return CardLabelWidget(
                card: state.cards[index],
                isAdd: arguments['isAdd'],
                isCustom: arguments['isCustom'],
              );
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }

  void _setupScrollListener(SearchBloc searchBloc) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
          !searchBloc.isLoading && searchBloc.hasNextPage) {
        searchBloc.add(FetchPageEvent(searchBloc.currentPage + 1));
      }
    });
  }
}
