import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/locales/localizations.dart';
import '../../core/routes/route.dart';
import '../blocs/bottom_nav_cubit.dart';
import '../widgets/app_bar.dart';
import '../widgets/nar_bar.dart';

class MyDeckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<BottomNavCubit>().updateIndex(0);

    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.open_in_new_rounded: AppRoutes.newDeck,
          AppLocalizations.of(context).translate('my_deck_title'): null,
          Icons.edit_rounded: null,
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
