part of 'product_varient_bloc.dart';

sealed class ProductVarientState extends Equatable {
  const ProductVarientState();
  
  @override
  List<Object> get props => [];
}

final class ProductVarientInitial extends ProductVarientState {}


//info: 'ProductVarientLoaded' is never used

//info: product varient state

final class ProductVarientLoadedState extends ProductVarientState {
  final List<ProductVariant> productVarient;

  const ProductVarientLoadedState({required this.productVarient});
}

final class ProductVarientErrorState extends ProductVarientState {
  final String message;

  const ProductVarientErrorState({required this.message});
}

final class ProductVarientLoadingState extends ProductVarientState {}