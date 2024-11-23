import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/locales/localizations.dart';
import '../../core/routes/route.dart';
import '../blocs/bottom_nav_cubit.dart';
import '../widgets/app_bar.dart';
import '../widgets/nar_bar.dart';

class ReadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<BottomNavCubit>().updateIndex(1);

    return Scaffold(
      appBar: AppBarWidget(
        menu: {
          Icons.history_rounded: null,
          AppLocalizations.of(context).translate('read_title'): null,
          Icons.search_rounded: AppRoutes.search,
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}
