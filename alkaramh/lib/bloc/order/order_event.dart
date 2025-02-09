part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class MakeOrderEvent extends OrderEvent {
  final String productID;
  final String address;

  MakeOrderEvent({
    required this.productID,
    required this.address,
  });

  @override
  List<Object> get props => [productID, address];
}

class OrderPostEvent extends OrderEvent {
  final AddressModel address;

  final String paymentMethod;

  OrderPostEvent({
    required this.address,
    required this.paymentMethod,
  });

  @override
  List<Object> get props => [address];
}
