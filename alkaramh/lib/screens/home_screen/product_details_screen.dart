import 'package:alkaramh/app_localizations.dart';
    import 'package:alkaramh/bloc/cart/cart_bloc.dart';
    import 'package:alkaramh/bloc/order/order_bloc.dart';
    import 'package:alkaramh/bloc/product_varient/product_varient_bloc.dart';
    import 'package:alkaramh/config/color/colors_file.dart';
    import 'package:alkaramh/config/text/my_text_theme.dart';
    import 'package:alkaramh/models/product_model.dart';
    import 'package:alkaramh/bloc/product_fetch/product_fetch_bloc.dart';
    import 'package:alkaramh/screens/address_get_screen/address_get_screen.dart';
    import 'package:alkaramh/screens/cart_screen/cart_screen.dart';
    import 'package:alkaramh/services/context_extensions.dart';
    import 'package:flutter/material.dart';
    import 'package:flutter_bloc/flutter_bloc.dart';

    class ProductDetailsScreen extends StatefulWidget {
      final String productId;

      const ProductDetailsScreen({
        Key? key,
        required this.productId,
      }) : super(key: key);

      @override
      _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
    }

    class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
      String selectedQuantity = "1";
      ProductVariant? selectedVariant;
      final ProductFetchBloc productFetchBloc = ProductFetchBloc();
      final ProductVarientBloc productVarientBloc = ProductVarientBloc();
      CartBloc _cartBloc = CartBloc();

      List<Product> products = [];
      bool isInCart = false;

      @override
      void initState() {
        super.initState();
        productFetchBloc.add(ProductDetailsFetchEvent(productId: widget.productId));
        productVarientBloc.add(ProductVariantFetchEvent(productId: widget.productId));
        _cartBloc.add(FetchCartItems());

        // Check if the product is in the cart
        _cartBloc.stream.listen((state) {
          if (state is CartLoaded) {
            setState(() {
              isInCart = state.cartItems.any((item) => item['id'] == widget.productId);
            });
          }
        });
      }

      Widget _buildVariantSelector(List<ProductVariant> variants) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.translate('select_quantity'),
              style: MyTextTheme.body(context)
                  .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: variants.map((variant) {
                  bool isSelected = selectedVariant?.id == variant.id;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        "${variant.name}\nQAR ${variant.price}",
                        textAlign: TextAlign.center,
                      ),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedVariant = selected ? variant : null;
                        });
                      },
                      selectedColor: Colors.green.shade100,
                      labelStyle: MyTextTheme.body(context).copyWith(
                        color: isSelected ? Colors.green.shade900 : Colors.black,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      }

      @override
      Widget build(BuildContext context) {
        OrderBloc orderBloc = BlocProvider.of<OrderBloc>(context);

        return Scaffold(
          backgroundColor: AppColors.primaryBackGroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              AppLocalizations.of(context)!.translate('product_details'),
              style: MyTextTheme.body(context).copyWith(color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: BlocConsumer<ProductFetchBloc, ProductFetchState>(
            bloc: productFetchBloc,
            listener: (context, state) {
              if (state is ProductFetchErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is ProductFetchLoadedState) {
                products = state.products;
              }
            },
            builder: (context, state) {
              if (state is ProductFetchLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is ProductFetchLoadedState) {
                final product = state.products[0];
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Image.network(
                                    product.imageUrl ?? '',
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              BlocConsumer<ProductVarientBloc, ProductVarientState>(
                                bloc: productVarientBloc,
                                listener: (context, state) {
                                  if (state is ProductVarientErrorState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(state.message)),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  if (state is ProductVarientLoadingState) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (state is ProductVarientLoadedState) {
                                    if (selectedVariant == null && state.productVarient.isNotEmpty) {
                                      selectedVariant = state.productVarient[0];
                                    }
                                    return Container(
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            blurRadius: 10,
                                            spreadRadius: 5,
                                            offset: const Offset(0, -5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                context.isArabic
                                                    ? product.arabicName
                                                    : product.name,
                                                style: MyTextTheme.body(context).copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              if (selectedVariant != null)
                                                Text(
                                                  "QAR ${selectedVariant!.price}",
                                                  style: MyTextTheme.body(context).copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          if (state.productVarient.isNotEmpty)
                                            _buildVariantSelector(state.productVarient),
                                          const SizedBox(height: 16),
                                          Text(
                                            context.isArabic
                                                ? product.arabicDescription
                                                : product.description,
                                            style: MyTextTheme.body(context).copyWith(
                                                fontSize: 14,
                                                color: Colors.grey[700]),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  return Center(
                                    child: Text(AppLocalizations.of(context)!
                                        .translate('something_went_wrong')),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: BlocConsumer<CartBloc, CartState>(
                              bloc: _cartBloc,
                              listener: (context, state) {
                                if (state is CartItemErrorState) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.message),
                                    ),
                                  );
                                } else if (state is CartItemLoadedState) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        AppLocalizations.of(context)!
                                            .translate('success'),
                                        style: MyTextTheme.body(context).copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              builder: (context, state) {
                                if (state is CartLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return ElevatedButton(
                                  onPressed: isInCart
                                      ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CartScreen(),
                                      ),
                                    );
                                  }
                                      : () {
                                    if (selectedVariant == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            AppLocalizations.of(context)!.translate(
                                                'please_select_a_variant'),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    _cartBloc.add(AddToCartEvent(
                                      productName: product.name,
                                      productarabicName: product.arabicName,
                                      categoryId: product.categoryId,
                                      discription: product.description,
                                      arabicDiscription: product.arabicDescription,
                                      variantId: selectedVariant!.id.toString(),
                                      variantName: selectedVariant!.name,
                                      variantPrice: selectedVariant!.price.toString(),
                                      quantity: "1",
                                      productImageUrl: product.imageUrl ?? '',
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: AppColors.primaryColor),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.translate(
                                        isInCart ? 'go_to_cart' : 'add_to_cart'),
                                    style: MyTextTheme.body(context)
                                        .copyWith(color: AppColors.primaryColor),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: selectedVariant == null
                                  ? null
                                  : () {
                                final orderProduct = {
                                  'productName': product.name,
                                  'productarabicName': product.arabicName,
                                  'productImageUrl': product.imageUrl,
                                  'categoryId': product.categoryId,
                                  'description': product.description,
                                  'arabicDescription': product.arabicDescription,
                                  'variantId': selectedVariant!.id.toString(),
                                  'variantName': selectedVariant!.name,
                                  'variantPrice': selectedVariant!.price.toString(),
                                  'quantity': "1",
                                };
                                orderBloc.selectedProducts = [orderProduct];
                                orderBloc.totalAmount = selectedVariant!.price.toString();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddressGetScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                disabledBackgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.translate('buy_now'),
                                style: MyTextTheme.body(context).copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Center(
                child: Text(AppLocalizations.of(context)!
                    .translate('something_went_wrong')),
              );
            },
          ),
        );
      }
    }