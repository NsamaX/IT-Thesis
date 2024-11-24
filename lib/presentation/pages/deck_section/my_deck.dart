import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/locales/localizations.dart';
import '../../../core/routes/route.dart';
import '../../blocs/bottom_nav.dart';
import '../../widgets/bar/app.dart';
import '../../widgets/bar/bottom_navigation.dart';

class MyDeckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.open_in_new_rounded: AppRoutes.deck,
          AppLocalizations.of(context).translate('my_deck_title'): null,
          Icons.edit_rounded: null,
        },
      ),
      bottomNavigationBar: BlocProvider(
        create: (context) => BottomNavCubit(0),
        child: BottomNavigationBarWidget(),
      ),
    );
  }
}
