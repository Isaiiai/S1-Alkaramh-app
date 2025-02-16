part of 'wishlist_bloc.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();
  
  @override
  List<Object> get props => [];
}

final class WishlistInitial extends WishlistState {}

final class WishlistLoadingState extends WishlistState {}

final class WishlistSuccessState extends WishlistState {
  final List<Map<String,dynamic>> wishlists;

  WishlistSuccessState({required this.wishlists});

  @override
  List<Object> get props => [wishlists];
}

final class WishlistError extends WishlistState {
  final String message;

  WishlistError({required this.message});

  @override
  List<Object> get props => [message];
}
