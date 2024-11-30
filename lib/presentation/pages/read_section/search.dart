import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../core/locales/localizations.dart';
import '../../../domain/usecases/fetch_cards.dart';
import '../../blocs/search.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/label/card.dart';

class SearchPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final game = arguments?['game'] ?? '';
    final isAdd = arguments?['isAdd'] ?? false;
    final isCustom = arguments?['isCustom'] ?? false;

    final fetchCardsPageUseCase =
        GetIt.instance<FetchCardsPageUseCase>(param1: game);

    return BlocProvider(
      create: (_) => SearchBloc(fetchCardsPageUseCase),
      child: Builder(
        builder: (context) {
          final searchBloc = context.read<SearchBloc>();
          _scrollController.addListener(() {
            if (_scrollController.position.pixels >=
                    _scrollController.position.maxScrollExtent - 200 &&
                !searchBloc.isLoading &&
                searchBloc.hasNextPage) {
              searchBloc.add(FetchPageEvent(searchBloc.currentPage + 1));
            }
          });
          return Scaffold(
            appBar: AppBarWidget(
              menu: {
                Icons.arrow_back_ios_new_rounded: '/back',
                AppLocalizations.of(context).translate('search.title'): null,
                null: null,
              },
            ),
            body: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  searchBloc.add(FetchPageEvent(1));
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          state.cards.length + (state.hasNextPage ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < state.cards.length) {
                          return CardLabelWidget(
                            card: state.cards[index],
                            isAdd: isAdd,
                            isCustom: isCustom,
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  );
                } else if (state is SearchError) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context).translate('search.error'),
                    ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          );
        },
      ),
    );
  }
}
