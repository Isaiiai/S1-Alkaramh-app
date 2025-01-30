part of 'home_fetch_bloc.dart';

sealed class HomeFetchState extends Equatable {
  const HomeFetchState();

  @override
  List<Object> get props => [];
}

final class HomeFetchInitial extends HomeFetchState {}


//info: Fetch Category

final class CategoryFetchSuccessState extends HomeFetchState {
  final List<Category> categories;

  const CategoryFetchSuccessState({required this.categories});
}

final class CategoryFetchErrorState extends HomeFetchState {
  final String message;

  const CategoryFetchErrorState({required this.message});
}

final class CategoryFetchLoadingState extends HomeFetchState  {
  const CategoryFetchLoadingState();
}
