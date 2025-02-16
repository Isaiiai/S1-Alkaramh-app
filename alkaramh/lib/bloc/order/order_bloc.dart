import 'dart:ffi';

import 'package:alkaramh/models/order_model.dart';
import 'package:alkaramh/models/product_model.dart';
import 'package:alkaramh/services/auth_services.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  //info: Order details in the Variable Name
  String productVarientId = '';
  List<Map<String, dynamic>> selectedProducts = [];
  String totalAmount = '';

  OrderBloc() : super(OrderInitial()) {
    on<OrderEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<OrderPostEvent>(orderPostEvent);
  }

  void orderPostEvent(OrderPostEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoadingState());
    try {
      AuthServices authServices = AuthServices();

      final user = await authServices.getCurrentUser();

      if (user == null) {
        emit(OrderFailureState(message: 'User not found'));
        return;
      }
      final order = OrderModel(
        userId: user.uid,
        cartItems: selectedProducts,
        address: event.address,
        totalAmount: totalAmount,
        paymentMethod: event.paymentMethod,

      );

      await FirebaseFirestore.instance.collection('orders').add(order.toJson());
      emit(OrderSuccessState(
        orders: OrderModel(
          userId: user.uid,
          cartItems: selectedProducts,
          address: event.address,
          totalAmount: totalAmount,
          paymentMethod: event.paymentMethod,
        ),
      ));
    } catch (e) {
      emit(OrderFailureState(message: e.toString()));
    }
  }
}
