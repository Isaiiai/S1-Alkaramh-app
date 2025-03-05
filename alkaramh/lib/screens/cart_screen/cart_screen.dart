import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/cart/cart_bloc.dart';
import 'package:alkaramh/bloc/order/order_bloc.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/address_get_screen/address_get_screen.dart';
import 'package:alkaramh/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:alkaramh/services/context_extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Map<int, bool> selectedItems = {};
  List<Map<String, dynamic>> selectedCartItem = [];
  double totalAmount = 0;
  final CartBloc _cartbloc = CartBloc();
  bool isCartEmpty = false;

  // Function to update total amount based on selected items
  void updateTotalAmount(List<Map<String, dynamic>> cartItems) {
    totalAmount = 0;
    for (int i = 0; i < cartItems.length; i++) {
      if (selectedItems[i] == true) {
        totalAmount += double.parse(cartItems[i]['variantPrice']) *
            int.parse(
                cartItems[i]['quantity']); // Multiply by existing quantity
      }
    }
    setState(() {}); // Update the UI
  }

  List<Map<String, dynamic>> cartInItems = [];
  bool isCartItemLoading = false;
  bool isArabic = false;

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
              child: Row(
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
            ),
            BlocConsumer<CartBloc, CartState>(
              bloc: _cartbloc,
              listener: (context, state) {
                if (state is CartLoaded) {
                  cartInItems = state.cartItems;
                  isCartEmpty = cartInItems.isEmpty;
                }
              },
              builder: (context, state) {
                if (state is CartLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return isCartEmpty
                    ? Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                cartEmptyImage,
                                width: 200,
                                height: 200,
                              ),
                              Text(
                                context.isArabic
                                    ? "سلة التسوق فارغة"
                                    : "Cart is Empty",
                                style: MyTextTheme.body(context),
                              )
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
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
                                      spreadRadius: 1),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Checkbox for selecting an item
                                  Checkbox(
                                    value: selectedItems[index] ?? false,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedItems[index] = value ?? false;
                                        updateTotalAmount(cartInItems);
                                      });
                                    },
                                  ),
                                  // Product Image
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: const DecorationImage(
                                          image: AssetImage(brownweetImage),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Product details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                        context.isArabic ? item['productarabicName'] : item['productName'],
                                          style: MyTextTheme.body(context)
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          item['variantName'],
                                          style: MyTextTheme.body(context)
                                              .copyWith(
                                                  color: Colors.grey[600]),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Product Price
                                            Text(
                                              '${AppLocalizations.of(context)!.translate('qar')} ${item['variantPrice']}',
                                              style: MyTextTheme.body(context)
                                                  .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            // Quantity Selector
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons
                                                          .remove_circle_outline,
                                                      size: 18),
                                                  onPressed: () {
                                                    int currentQuantity =
                                                        int.parse(
                                                            item['quantity']);
                                                    if (currentQuantity > 1) {
                                                      _cartbloc.add(
                                                          UpdateQuantityEvent(
                                                        itemId: item['id'],
                                                        quantity:
                                                            (currentQuantity -
                                                                    1)
                                                                .toString(),
                                                      ));
                                                      cartInItems[index]
                                                              ['quantity'] =
                                                          (currentQuantity - 1)
                                                              .toString();
                                                      updateTotalAmount(
                                                          cartInItems);
                                                    }
                                                  },
                                                ),
                                                Text(
                                                  item['quantity'],
                                                  style:
                                                      MyTextTheme.body(context)
                                                          .copyWith(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.add_circle_outline,
                                                      size: 18),
                                                  onPressed: () {
                                                    int currentQuantity =
                                                        int.parse(
                                                            item['quantity']);
                                                    _cartbloc.add(
                                                        UpdateQuantityEvent(
                                                      itemId: item['id'],
                                                      quantity:
                                                          (currentQuantity + 1)
                                                              .toString(),
                                                    ));
                                                    cartInItems[index]
                                                            ['quantity'] =
                                                        (currentQuantity + 1)
                                                            .toString();
                                                    updateTotalAmount(
                                                        cartInItems);
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
                      );
              },
            ),
            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: totalAmount > 0
                    ? () async {
                        final orderBloc = context.read<OrderBloc>();
                        for (int index = 0;
                            index <= selectedItems.length;
                            index++) {
                          if (selectedItems[index] == true) {
                            selectedCartItem.add(cartInItems[index]);
                          }
                        }
                        orderBloc.selectedProducts = selectedCartItem;
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
                    padding: const EdgeInsets.symmetric(vertical: 16)),
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
