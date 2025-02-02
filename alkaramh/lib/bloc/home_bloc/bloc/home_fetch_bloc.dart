import 'dart:async';

import 'package:alkaramh/models/product_model.dart';
import 'package:alkaramh/services/product_services.dart';
import 'package:alkaramh/services/category_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_fetch_event.dart';
part 'home_fetch_state.dart';

class HomeFetchBloc extends Bloc<HomeFetchEvent, HomeFetchState> {
  final CategoryService _categoryService = CategoryService();
  HomeFetchBloc() : super(HomeFetchInitial()) {
    on<HomeFetchEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<CategoryFetchEvent>(_onCategoryFetchEvent);
  }

  FutureOr<void> _onCategoryFetchEvent(
      CategoryFetchEvent event, Emitter<HomeFetchState> emit) async {
    print("This Event is called from the category fetch event ");
    emit(CategoryFetchLoadingState());
    try {
      final category = await _categoryService.fetchCategories();
      emit(CategoryFetchSuccessState(categories: category));
    } catch (e) {
      emit(CategoryFetchErrorState(message: e.toString()));
    }
  }
}
