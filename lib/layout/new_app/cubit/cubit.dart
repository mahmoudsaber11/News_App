import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/new_app/cubit/states.dart';
import 'package:news_app/modules/news_app/business/business_screen.dart';
import 'package:news_app/modules/news_app/science/science_screen.dart';
import 'package:news_app/modules/news_app/sports/sports_screen.dart';
import 'package:news_app/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates> {
  NewsCubit() : super(NewsInitailState());
  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = const [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];
  List<BottomNavigationBarItem> bottomItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.business), label: "Business"),
    BottomNavigationBarItem(icon: Icon(Icons.sports), label: "Sports"),
    BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Science'),
  ];

  void changeBottomNavBar(int index) {
    currentIndex = index;
    emit(NewBottomNavState());
  }

  List<dynamic> business = [];

  void getBusiness() {
    emit(NewsGetBusinessLoadingStates());
    DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'business',
      'apiKey': 'ba86f396996e451884f75e9a9ffcad51'
    }).then((value) {
      emit(NewsGetBusinessSuccessStates());
      business = value.data['articles'];
      // print(business[0]['title']);
    }).catchError((error) {
      //   print(error.toString());
      emit(NewsGetBusinessErrorStates(error.toString()));
    });
  }

  List<dynamic> sports = [];

  void getSports() {
    emit(NewsGetSportsLoadingStates());
    DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'sports',
      'apiKey': 'ba86f396996e451884f75e9a9ffcad51'
    }).then((value) {
      emit(NewsGetSportsSuccessStates());
      sports = value.data['articles'];
      //  print(business[0]['title']);
    }).catchError((error) {
      // print(error.toString());
      emit(NewsGetSportsErrorStates(error.toString()));
    });
  }

  List<dynamic> science = [];

  void getScience() {
    emit(NewsGetScienceLoadingStates());
    DioHelper.getData(url: 'v2/top-headlines', query: {
      'country': 'eg',
      'category': 'science',
      'apiKey': 'ba86f396996e451884f75e9a9ffcad51'
    }).then((value) {
      emit(NewsGetScienceSuccessStates());
      science = value.data['articles'];
      //  print(business[0]['title']);
    }).catchError((error) {
      //  print(error.toString());
      emit(NewsGetScienceErrorStates(error.toString()));
    });
  }

  List<dynamic> search = [];

  void getSearch(String value) {
    emit(NewsGetScienceLoadingStates());
    search = [];
    DioHelper.getData(
            url: 'v2/everything',
            query: {'q': value, 'apiKey': 'ba86f396996e451884f75e9a9ffcad51'})
        .then((value) {
      emit(NewsGetSearchSuccessStates());
      search = value.data['articles'];
      //print(search[0]['title']);
    }).catchError((error) {
      //  print(error.toString());
      emit(NewsGetSearchErrorStates(error.toString()));
    });
  }
}
