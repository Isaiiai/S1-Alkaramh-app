part of 'wishlist_bloc.dart';

sealed class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

final class FetchWishlistEvent extends WishlistEvent {}


final class RemoveWishListEvent extends WishlistEvent {
  final String productId;
  const RemoveWishListEvent({required this.productId});
}