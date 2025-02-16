import 'dart:async';

import 'package:alkaramh/models/product_model.dart';
import 'package:alkaramh/services/product_services.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_varient_event.dart';
part 'product_varient_state.dart';

class ProductVarientBloc
    extends Bloc<ProductVarientEvent, ProductVarientState> {
  ProductVarientBloc() : super(ProductVarientInitial()) {
    on<ProductVarientEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ProductVariantFetchEvent>(_onProductVariantFetchEvent);
  }

  FutureOr<void> _onProductVariantFetchEvent(
      ProductVariantFetchEvent event, Emitter<ProductVarientState> emit) async {
    emit(ProductVarientLoadingState());
    try {
      final productVarient =
          await ProductsFetchService().fetchProductVariants(event.productId);
      emit(ProductVarientLoadedState(productVarient: productVarient));
    } catch (e) {
      print(e.toString());
      emit(ProductVarientErrorState(message: e.toString()));
    }
  }
}
