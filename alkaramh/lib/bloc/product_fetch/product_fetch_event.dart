part of 'product_fetch_bloc.dart';

sealed class ProductFetchEvent extends Equatable {
  const ProductFetchEvent();

  @override
  List<Object> get props => [];
}


class ProductFetchInitialEvent extends ProductFetchEvent {}

class ProductDetailsFetchEvent extends ProductFetchEvent {
  final String productId;

  ProductDetailsFetchEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}

