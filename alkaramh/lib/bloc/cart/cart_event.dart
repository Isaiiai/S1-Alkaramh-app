part of 'cart_bloc.dart';
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class FetchCartItems extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final String productName;
  final String productarabicName;
  final String categoryId;
  final String discription;
  final String arabicDiscription;
  final String variantId;
  final String variantName;
  final String variantPrice;
  final String quantity;
  final String? productImageUrl;

  AddToCartEvent({
    required this.productName,
    required this.productarabicName,
    required this.categoryId,
    required this.discription,
    required this.arabicDiscription,
    required this.variantId,
    required this.variantName,
    required this.variantPrice,
    required this.quantity,
    this.productImageUrl,
  });
}


//info: Remove From Cart 

class RemoveFromCartEvent extends CartEvent {
  final String itemId;
  const RemoveFromCartEvent({required this.itemId});
}

class UpdateQuantityEvent extends CartEvent {
  final String itemId;
  final String quantity;
  const UpdateQuantityEvent({required this.itemId, required this.quantity});
}


class ClearCartEvent extends CartEvent {}





