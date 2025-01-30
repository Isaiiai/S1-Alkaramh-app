part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();
  
  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}


final class OrderLoadingState  extends OrderState {}

final class OrderSuccessState extends OrderState {
  final OrderModel orders;

  OrderSuccessState({required this.orders});

  @override
  List<Object> get props => [orders];
}

final class OrderFailureState extends OrderState {
  final String message;

  OrderFailureState({required this.message});

  @override
  List<Object> get props => [message];
}