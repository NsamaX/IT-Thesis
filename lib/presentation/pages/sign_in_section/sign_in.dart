import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/app_state.dart';
import '../../widgets/sign_in/sign_in.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<AppStateCubit>().updatePageIndex(1);
    return SignInWidget();
  }
}
