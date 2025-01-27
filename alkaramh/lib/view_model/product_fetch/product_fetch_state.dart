part of 'product_fetch_bloc.dart';

sealed class ProductFetchState extends Equatable {
  const ProductFetchState();
  
  @override
  List<Object> get props => [];
}

final class ProductFetchInitial extends ProductFetchState {}



final class ProductFetchLoadingState extends ProductFetchState {}

final class ProductFetchLoadedState extends ProductFetchState {
  final List<Product> products;

  const ProductFetchLoadedState({required this.products});
}

final class ProductFetchErrorState extends ProductFetchState {
  final String message;

  const ProductFetchErrorState({required this.message});
}