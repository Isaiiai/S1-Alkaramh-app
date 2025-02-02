import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/cart/cart_bloc.dart';
import 'package:alkaramh/bloc/order/order_bloc.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/address_get_screen/address_get_screen.dart';
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

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(FetchCartItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CartLoaded) {
              final cartItems = state.cartItems;

              return Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!.translate('cart'),
                                textAlign: TextAlign.center,
                                style: MyTextTheme.body.copyWith(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SvgPicture.asset(shareIcon, width: 15, height: 15),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: Colors.grey[600]),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('your_location'),
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Colors.grey[400]),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Select All
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Checkbox(
                          value: cartItems.isNotEmpty &&
                              selectedItems.values.every((v) => v),
                          onChanged: (value) {
                            setState(() {
                              for (int i = 0; i < cartItems.length; i++) {
                                selectedItems[i] = value ?? false;
                              }
                              updateTotalAmount(cartItems);
                            });
                          },
                        ),
                        Text(
                            AppLocalizations.of(context)!.translate('see_all')),
                      ],
                    ),
                  ),

                  // Cart Items
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
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
                                    selectedItems[index] = value ?? false;
                                    updateTotalAmount(cartItems);
                                  });
                                },
                              ),
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: const DecorationImage(
                                    image: AssetImage(brownweetImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            item['productName'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline,
                                              color: Colors.red),
                                          onPressed: () {
                                            context.read<CartBloc>().add(
                                                  RemoveFromCartEvent(
                                                      itemId: item['id']),
                                                );
                                          },
                                        ),
                                      ],
                                    ),
                                    Text(
                                      item['variantName'],
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context)!.translate('qar')} ${item['variantPrice']}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryColor,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.remove_circle_outline),
                                              onPressed: () {
                                                int currentQuantity =
                                                    int.parse(item['quantity']);
                                                if (currentQuantity > 1) {
                                                  context.read<CartBloc>().add(
                                                        UpdateQuantityEvent(
                                                          itemId: item['id'],
                                                          quantity:
                                                              (currentQuantity -
                                                                      1)
                                                                  .toString(),
                                                        ),
                                                      );
                                                }
                                              },
                                            ),
                                            Text(
                                              item['quantity'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.add_circle_outline),
                                              onPressed: () {
                                                int currentQuantity =
                                                    int.parse(item['quantity']);
                                                context.read<CartBloc>().add(
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
                  ),

                  // Checkout
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .translate('total_amount'),
                              style: MyTextTheme.body,
                            ),
                            Text(
                              '${AppLocalizations.of(context)!.translate('qar')} ${totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: totalAmount > 0
                                ? () {
                                    List<Map<String, dynamic>>
                                        selectedProducts = [];
                                    for (int i = 0; i < cartItems.length; i++) {
                                      if (selectedItems[i] == true) {
                                        selectedProducts.add(cartItems[i]);
                                      }
                                    }
                                    final orderBloc = context.read<OrderBloc>();
                                    orderBloc.selectedProducts =
                                        selectedProducts;
                                    orderBloc.totalAmount =
                                        totalAmount.toString();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddressGetScreen(),
                                      ),
                                    );
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              '${AppLocalizations.of(context)!.translate('checkout')} (${selectedItems.values.where((v) => v).length} ${AppLocalizations.of(context)!.translate('items')})',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return const Center(child: Text('No items in cart'));
          },
        ),
      ),
    );
  }
}
