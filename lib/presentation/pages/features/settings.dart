import 'package:flutter/material.dart';

import 'package:nfc_project/core/routes/routes.dart';

import '../../cubits/settings.dart';

void toggleSignOut(BuildContext context, SettingsCubit cubit) {
  cubit.updateSetting('firstLoad', true);
  Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
}
