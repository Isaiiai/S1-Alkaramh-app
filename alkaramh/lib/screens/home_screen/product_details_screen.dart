import 'dart:convert';

import 'package:alkaramh/bloc/cart/cart_bloc.dart';
import 'package:alkaramh/bloc/order/order_bloc.dart';
import 'package:alkaramh/bloc/product_varient/product_varient_bloc.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/models/product_model.dart';
import 'package:alkaramh/bloc/product_fetch/product_fetch_bloc.dart';
import 'package:alkaramh/screens/address_get_screen/address_get_screen.dart';
import 'package:alkaramh/services/cart_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    productFetchBloc.add(ProductDetailsFetchEvent(productId: widget.productId));
    productVarientBloc
        .add(ProductVariantFetchEvent(productId: widget.productId));
  }

  Widget _buildVariantSelector(List<ProductVariant> variants) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Size",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.green.shade900 : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Product Details",
          style: TextStyle(color: Colors.black),
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
                              child: Image.asset(
                                brownweetImage,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            product.name,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.orange,
                                                  size: 20),
                                              Text(
                                                product.rating.toString(),
                                                style: const TextStyle(
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      if (state.productVarient.isNotEmpty)
                                        _buildVariantSelector(
                                            state.productVarient),
                                      const SizedBox(height: 16),
                                      Text(
                                        product.description,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return const Center(
                                child: Text("Something went wrong"),
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
                            }
                            else if (state is CartItemLoadedState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
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
                              onPressed: () {
                                if (selectedVariant == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Please select a variant"),
                                    ),
                                  );
                                  return;
                                }
                                _cartBloc.add(AddToCartEvent(
                                  productName: product.name,
                                  categoryId: product.categoryId,
                                  discription: product.description,
                                  variantId: selectedVariant!.id.toString(),
                                  variantName: selectedVariant!.name,
                                  variantPrice: selectedVariant!.price.toString(),
                                  quantity: "1",
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(color: AppColors.primaryColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                "Add Cart",
                                style: MyTextTheme.body
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
                                    'categoryId': product.categoryId,
                                    'description': product.description,
                                    'variantId': selectedVariant!.id.toString(),
                                    'variantName': selectedVariant!.name,
                                    'variantPrice':
                                        selectedVariant!.price.toString(),
                                    'quantity': "1",
                                  };
                                  orderBloc.selectedProducts = [orderProduct];
                                  orderBloc.totalAmount =
                                      selectedVariant!.price.toString();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AddressGetScreen(),
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
                            "Buy Now",
                            style:
                                MyTextTheme.body.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: Text("Something went wrong"),
          );
        },
      ),
    );
  }
}
