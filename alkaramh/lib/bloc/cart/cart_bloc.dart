import 'package:alkaramh/services/cart_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartServices _cartServices = CartServices();
  CartBloc() : super(CartInitial()) {
    on<FetchCartItems>(_onFetchCartItems);
    on<AddToCartEvent>(_onAddToCartEvent);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClearCart);
  }

  Future<void> _onFetchCartItems(
      FetchCartItems event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await _cartServices.getCartItems();
      emit(CartLoaded(cartItems: items));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onAddToCartEvent(
      AddToCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await _cartServices.addToCart(
        productName: event.productName,
        productarabicName: event.productarabicName,
        categoryId: event.categoryId,
        discription: event.discription,
        arabicDiscription: event.arabicDiscription,
        variantId: event.variantId,
        variantName: event.variantName,
        variantPrice: event.variantPrice,
        quantity: event.quantity,
        productImageUrl: event.productImageUrl ?? '',
      );
      emit(CartItemLoadedState(message: "Item added to cart"));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
      RemoveFromCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await _cartServices.removeFromCart(event.itemId);
      final items = await _cartServices.getCartItems();
      emit(CartLoaded(cartItems: items));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
      UpdateQuantityEvent event, Emitter<CartState> emit) async {
    
    try {
      await _cartServices.updateQuantity(event.itemId, event.quantity);
      final items = await _cartServices.getCartItems();
      emit(CartLoaded(cartItems: items));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onClearCart(
      ClearCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      await _cartServices.clearCart();
      emit(CartItemLoadedState(message: "Cart cleared"));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }
}
