import 'package:flutter_bloc/flutter_bloc.dart';

class SignCubit extends Cubit<bool> {
  SignCubit() : super(false);

  void toggleSign() => emit(!state);
}
