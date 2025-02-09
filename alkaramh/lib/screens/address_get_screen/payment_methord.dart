import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/cart/cart_bloc.dart';
import 'package:alkaramh/bloc/order/order_bloc.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaymentMethodScreen extends StatefulWidget {
  final String totalAmount;
  final AddressModel address;

  const PaymentMethodScreen({
    Key? key,
    required this.totalAmount,
    required this.address,
  }) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String selectedPaymentMethod = 'cash_on_delivery';
  CartBloc cartBloc = CartBloc();

  @override
  Widget build(BuildContext context) {
    final orderBloc = context.read<OrderBloc>();
    final double totalWithDelivery = double.parse(widget.totalAmount);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('payment_method'),
          style: MyTextTheme.body.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .translate('select_payment_method'),
                    style: MyTextTheme.body.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!
                        .translate('cash_on_delivery')),
                    leading: Radio(
                      value: 'cash_on_delivery',
                      groupValue: selectedPaymentMethod,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value.toString();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!
                        .translate('online_payment')),
                    leading: Radio(
                      value: 'online_payment',
                      groupValue: selectedPaymentMethod,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value.toString();
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!
                        .translate('cart_on_delivery')),
                    leading: Radio(
                      value: 'cart_on_delivery',
                      groupValue: selectedPaymentMethod,
                      activeColor: AppColors.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          selectedPaymentMethod = value.toString();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate('price_details'),
                    style: MyTextTheme.body.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!
                          .translate('products_total')),
                      Text(
                          '${AppLocalizations.of(context)!.translate('qar')} ${widget.totalAmount}'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context)!
                          .translate('delivery_charge')),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate('total_amount'),
                        style: MyTextTheme.body
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.translate('qar')} $totalWithDelivery',
                        style: MyTextTheme.body
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: BlocConsumer<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state is OrderSuccessState) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .translate('order_placed_successfully')),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: state is OrderLoadingState
                        ? null
                        : () {
                            orderBloc.add(
                              OrderPostEvent(
                                address: widget.address,
                                paymentMethod: selectedPaymentMethod,
                              ),
                            );
                            cartBloc.add(ClearCartEvent());
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: state is OrderLoadingState
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            AppLocalizations.of(context)!
                                .translate('confirm_order'),
                            style:
                                MyTextTheme.body.copyWith(color: Colors.white),
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
