import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBarCubit extends Cubit<int> {
  BottomNavBarCubit() : super(0);
  int index = 0;
  void selectTab(int index) {
    this.index = index;
    emit(index);
  }
}
