part of 'product_varient_bloc.dart';

sealed class ProductVarientEvent extends Equatable {
  const ProductVarientEvent();

  @override
  List<Object> get props => [];
}

class ProductVariantFetchEvent extends ProductVarientEvent {
  final String productId;

  ProductVariantFetchEvent({required this.productId});

  @override
  List<Object> get props => [productId];
}
