import 'dart:async';

import 'package:alkaramh/models/product_model.dart';
import 'package:alkaramh/services/all_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_fetch_event.dart';
part 'product_fetch_state.dart';

class ProductFetchBloc extends Bloc<ProductFetchEvent, ProductFetchState> {
  ProductFetchBloc() : super(ProductFetchInitial()) {
    on<ProductFetchEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ProductFetchInitialEvent>(_onProductFetchInitialEvent);
    //info: Fetch Details
    on<ProductDetailsFetchEvent>(_onProductDetailsFetchEvent);
    //product Varient Fetch
    on<ProductVariantFetchEvent>(_onProductVariantFetchEvent);
  }

  FutureOr<void> _onProductFetchInitialEvent(
      ProductFetchInitialEvent event, Emitter<ProductFetchState> emit) async {
    emit(ProductFetchLoadingState());
    try {
      final product = await ProductsFetchService().fetchProducts();

      emit(ProductFetchLoadedState(products: product));
    } catch (e) {
      emit(ProductFetchErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onProductDetailsFetchEvent(
      ProductDetailsFetchEvent event, Emitter<ProductFetchState> emit) async {
    emit(ProductFetchLoadingState());
    try {
      final product =
          await ProductsFetchService().fetchProductDetails(event.productId);
      emit(ProductFetchLoadedState(products: [product]));
    } catch (e) {
      emit(ProductFetchErrorState(message: e.toString()));
    }
  }

  FutureOr<void> _onProductVariantFetchEvent(
      ProductVariantFetchEvent event, Emitter<ProductFetchState> emit) async {
    emit(ProductFetchLoadingState());
    try {
      final productVarient =
          await ProductsFetchService().fetchProductVariants(event.productId);
      print(productVarient.first.name);
    } catch (e) {
      print(e.toString());
      emit(ProductFetchErrorState(message: e.toString()));
    }
  }
}
