import 'package:alkaramh/models/wish_list_model.dart';
import 'package:alkaramh/services/wish_list_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishListServices _wishlistServices = WishListServices();
  WishlistBloc() : super(WishlistInitial()) {
    on<WishlistEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchWishlistEvent>(_onFetchWishlistEvent);
    on<RemoveWishListEvent>(_onRemoveWishListEvent);
  }

  Future<void> _onFetchWishlistEvent(
      FetchWishlistEvent event, Emitter<WishlistState> emit) async {
    emit(WishlistLoadingState());
    try {
      final items = await _wishlistServices.getWishList();
      emit(WishlistSuccessState(wishlists: items));
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }

  Future<void> _onRemoveWishListEvent(
      RemoveWishListEvent event, Emitter<WishlistState> emit) async {
    emit(WishlistLoadingState());
    try {
      await _wishlistServices.removeFromWishList(event.productId);
      final items = await _wishlistServices.getWishList();
      emit(WishlistSuccessState(wishlists: items));
    } catch (e) {
      emit(WishlistError(message: e.toString()));
    }
  }
}
