import 'package:flutter_bloc/flutter_bloc.dart';

class NFCCubit extends Cubit<bool> {
  NFCCubit() : super(false);

  void toggleNFCStatus() => emit(!state);
}
