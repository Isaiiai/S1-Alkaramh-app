import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/cart/cart_bloc.dart';
import 'package:alkaramh/bloc/order/order_bloc.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/models/order_model.dart';
import 'package:alkaramh/screens/address_get_screen/order_success_screen.dart';
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
    final double totalWithDelivery = double.parse(widget.totalAmount) + 50;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          AppLocalizations.of(context)!.translate('checkout'),
          style: MyTextTheme.body(context).copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate('pay_with'),
                    style: MyTextTheme.body(context).copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      buildPaymentOption(
                        context,
                        'card_on_delivery',
                        Icons.credit_card,
                        AppLocalizations.of(context)!
                            .translate('card_on_delivery'),
                      ),
                      buildPaymentOption(
                        context,
                        'cash_on_delivery',
                        Icons.money,
                        AppLocalizations.of(context)!
                            .translate('cash_on_delivery'),
                      ),
                      buildPaymentOption(
                        context,
                        'farhan_on_delivery',
                        Icons.payment,
                        'Farhan on delivery',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate('price_details'),
                    style: MyTextTheme.body(context).copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildPriceRow('Basket Total', widget.totalAmount),
                  buildPriceRow('Delivery Fee', '50'),
                  const Divider(),
                  buildPriceRow('Total amount', totalWithDelivery.toString(),
                      isBold: true),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: BlocConsumer<OrderBloc, OrderState>(
                listener: (context, state) {
                  if (state is OrderSuccessState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderSuccessScreen(),
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
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: state is OrderLoadingState
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            AppLocalizations.of(context)!
                                .translate('place_order'),
                            style:
                                MyTextTheme.body(context).copyWith(color: Colors.white),
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

  Widget buildPaymentOption(
      BuildContext context, String value, IconData icon, String title) {
    final isSelected = selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          
          color: isSelected ? Colors.green.withOpacity(0.1) : Colors.white,
        ),
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Colors.green : Colors.transparent,
              width: 2,
            ),
          ),
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected ? Colors.green : Colors.black,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.green : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPriceRow(String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.translate(label),
            style: MyTextTheme.body(context).copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            'QAR $amount',
            style: MyTextTheme.body(context).copyWith(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
