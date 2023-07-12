import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewManageCubit extends Cubit<int> {
  ViewManageCubit() : super(0);

  final PageController _pageController = PageController();
  PageController get controller => _pageController;

  void dispose() => _pageController.dispose();

  void animateTo(int index, [bool isSwipe = true]) {
    if (isSwipe) {
      controller.animateToPage(index,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linearToEaseOut);
    }
    emit(index);
  }
}
