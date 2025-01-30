import 'package:alkaramh/services/cart_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartServices _cartServices = CartServices();
  CartBloc() : super(CartInitial()) {
    on<CartEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchCartItems>(_onFetchCartItems);
  }

  Future<void> _onFetchCartItems(
      FetchCartItems event, Emitter<CartState> emit) async {
    try {
      emit(CartLoading());
      final items = await _cartServices.getCartItems();
      emit(CartLoaded(cartItems: items));
      print(items.length);
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}
