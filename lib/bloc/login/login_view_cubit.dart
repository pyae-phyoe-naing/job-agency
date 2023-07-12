import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewCubit extends Cubit<int>{
  LoginViewCubit():super(0);
  final PageController _pageController = PageController();
  PageController get controller=>_pageController;
  void animateTo(index){
    emit(index);
    _pageController.animateToPage(index, duration:const Duration(milliseconds:130), curve:Curves.easeIn);
  }
}