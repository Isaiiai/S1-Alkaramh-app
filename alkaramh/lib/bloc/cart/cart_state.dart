part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

//info: Cart quantity update state

final class CartQuantituLoadingState extends CartState {}

final class CartLoaded extends CartState {
  final List<Map<String, dynamic>> cartItems;

  CartLoaded({required this.cartItems});

  @override
  List<Object> get props => [cartItems];
}

final class CartError extends CartState {
  final String message;

  CartError({required this.message});

  @override
  List<Object> get props => [message];
}

//info: Cart Items State
final class CartItemLoadedState extends CartState {
  final String message;

  CartItemLoadedState({required this.message});
}

final class CartItemErrorState extends CartState {
  final String message;

  CartItemErrorState({required this.message});
}

final class QuantityUpdateLoadingState extends CartState {}

//? cart items increasing state

final class CartItemIncreasLoadingState extends CartState {}

final class CartItemIncreaseErrorState extends CartState {}
