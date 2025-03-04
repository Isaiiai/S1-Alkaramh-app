import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/cart/cart_bloc.dart';
import 'package:alkaramh/bloc/order/order_bloc.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/address_get_screen/address_get_screen.dart';
import 'package:alkaramh/services/context_extensions.dart';
import 'package:alkaramh/widget/snakbar_all/snakbar_all.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<int, bool> selectedItems = {};
  double totalAmount = 0;
  final CartBloc _cartbloc = CartBloc();
  bool isCartEmpty = false;

  void updateTotalAmount(List<Map<String, dynamic>> cartItems) {
    totalAmount = 0;
    for (int i = 0; i < cartItems.length; i++) {
      if (selectedItems[i] == true) {
        totalAmount += double.parse(cartItems[i]['variantPrice']) *
            int.parse(cartItems[i]['quantity']);
      }
    }
    setState(() {});
  }

  List<Map<String, dynamic>> cartInItems = [];
  bool isCartItemLoading = false;

  @override
  void initState() {
    super.initState();
    _cartbloc.add(FetchCartItems());
    selectedItems.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.translate('cart'),
                          textAlign: TextAlign.center,
                          style: MyTextTheme.body(context).copyWith(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Checkbox(
                    value: cartInItems.isNotEmpty &&
                        selectedItems.values.every((v) => v),
                    onChanged: (value) {
                      setState(() {
                        for (int i = 0; i < cartInItems.length; i++) {
                          selectedItems[i] = value ?? false;
                        }
                        updateTotalAmount(cartInItems);
                      });
                    },
                  ),
                  Text(AppLocalizations.of(context)!.translate('select_all')),
                ],
              ),
            ),
            BlocConsumer<CartBloc, CartState>(
              bloc: _cartbloc,
              listener: (context, state) {
                if (state is CartLoaded) {
                  cartInItems = state.cartItems;
                  if (state.cartItems.isEmpty) {
                    isCartEmpty = true;
                  }
                }
              },
              builder: (context, state) {
                if (state is CartLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CartItemLoadedState) {
                  isCartItemLoading = true;
                }
                return isCartEmpty
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              cartEmptyImage,
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('cart_is_empty'),
                              style: MyTextTheme.body(context).copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: Stack(
                          children: [
                            ListView.builder(
                              itemCount: cartInItems.length,
                              padding: const EdgeInsets.all(16),
                              itemBuilder: (context, index) {
                                final item = cartInItems[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: selectedItems[index] ?? false,
                                        onChanged: (value) {
                                          setState(() {
                                            selectedItems[index] =
                                                value ?? false;
                                            updateTotalAmount(cartInItems);
                                          });
                                        },
                                      ),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          image: const DecorationImage(
                                            image: AssetImage(brownweetImage),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    context.isArabic
                                                        ? item[
                                                            'productarabicName']
                                                        : item['productName'],
                                                    style: MyTextTheme.body(
                                                            context)
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.delete_outline,
                                                      color: Colors.red),
                                                  onPressed: () {
                                                    _cartbloc.add(
                                                      RemoveFromCartEvent(
                                                          itemId: item['id']),
                                                    );

                                                    _cartbloc
                                                        .add(FetchCartItems());
                                                  },
                                                ),
                                              ],
                                            ),
                                            Text(
                                              item['variantName'],
                                              style: MyTextTheme.body(context)
                                                  .copyWith(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  '${AppLocalizations.of(context)!.translate('qar')} ${item['variantPrice']}',
                                                  style:
                                                      MyTextTheme.body(context)
                                                          .copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        size: 18,
                                                      ),
                                                      onPressed: () {
                                                        int currentQuantity =
                                                            int.parse(item[
                                                                'quantity']);
                                                        if (currentQuantity >
                                                            1) {
                                                          _cartbloc.add(
                                                            UpdateQuantityEvent(
                                                              itemId:
                                                                  item['id'],
                                                              quantity:
                                                                  (currentQuantity -
                                                                          1)
                                                                      .toString(),
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .translate(
                                                                        'item_removed_from_cart'),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                    BlocBuilder<CartBloc,
                                                        CartState>(
                                                      bloc: _cartbloc,
                                                      builder:
                                                          (context, state) {
                                                        if (state
                                                            is CartItemIncreasLoadingState) {
                                                          return const SizedBox(
                                                            width: 16,
                                                            height: 16,
                                                            child:
                                                                CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                          );
                                                        }
                                                        return Text(
                                                          item['quantity'],
                                                          style:
                                                              MyTextTheme.body(
                                                                      context)
                                                                  .copyWith(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        size: 18,
                                                      ),
                                                      onPressed: () {
                                                        int currentQuantity =
                                                            int.parse(item[
                                                                'quantity']);
                                                        _cartbloc.add(
                                                          UpdateQuantityEvent(
                                                            itemId: item['id'],
                                                            quantity:
                                                                (currentQuantity +
                                                                        1)
                                                                    .toString(),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            if (isCartItemLoading)
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  color: Colors.black.withOpacity(0.5),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
              },
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: totalAmount > 0
                    ? () async {
                        List<Map<String, dynamic>> cartselectedProducts = [];
                        for (int i = 0; i < cartInItems.length; i++) {
                          if (selectedItems[i] == true) {
                            cartselectedProducts.add(cartInItems[i]);
                          }
                        }
                        final orderBloc = context.read<OrderBloc>();
                        orderBloc.selectedProducts = cartselectedProducts;
                        orderBloc.totalAmount = totalAmount.toString();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddressGetScreen(),
                          ),
                        ).then((result) {
                          if (result == true) {
                            context.read<CartBloc>().add(ClearCartEvent());
                          }
                        });
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  '${AppLocalizations.of(context)!.translate('checkout')} (${selectedItems.values.where((v) => v).length} ${AppLocalizations.of(context)!.translate('items')})',
                  style:
                      MyTextTheme.body(context).copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
