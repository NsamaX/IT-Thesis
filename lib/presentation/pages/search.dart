import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/locales/localizations.dart';
import '../../domain/usecases/fetch_cards.dart';
import '../blocs/search_bloc.dart';
import '../blocs/game_selection_cubit.dart';
import '../widgets/app_bar.dart';
import '../widgets/card_label.dart';

class SearchPage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentGame = context.watch<GameSelectionCubit>().state;
    final fetchCardsPageUseCase = FetchCardsPageUseCase(currentGame);

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
                Icons.arrow_back_ios_new_rounded: () =>
                    Navigator.of(context).pop(),
                AppLocalizations.of(context).translate('search_title'): null,
                null: null,
              },
            ),
            body: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchInitial) {
                  searchBloc.add(FetchPageEvent(1));
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  return Column(
                    children: [
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              state.cards.length + (state.hasNextPage ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < state.cards.length) {
                              return CardLabelWidget(
                                card: state.cards[index],
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
                      ),
                    ],
                  );
                } else if (state is SearchError) {
                  return Center(
                    child: Text('Error: ${state.message}'),
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
