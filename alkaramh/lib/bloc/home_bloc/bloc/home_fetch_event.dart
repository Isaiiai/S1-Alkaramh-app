part of 'home_fetch_bloc.dart';

sealed class HomeFetchEvent extends Equatable {
  const HomeFetchEvent();

  @override
  List<Object> get props => [];
}



class CategoryFetchEvent extends HomeFetchEvent {}
