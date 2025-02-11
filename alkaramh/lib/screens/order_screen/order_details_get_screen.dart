import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/models/order_model.dart';
import 'package:alkaramh/services/context_extensions.dart';
import 'package:alkaramh/services/order_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final OrderServices _orderServices = OrderServices();
  List<OrderModel> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        List<OrderModel> orders =
            await _orderServices.getOrdersByUserId(userId);
        print(orders.first.cartItems.first["productImageUrl"]);
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackGroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.translate('orders')),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(
                  child: Text(AppLocalizations.of(context)!
                      .translate('no_orders_found')),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    return _buildOrderCard(_orders[index]);
                  },
                ),
    );
  }

  Widget _buildOrderCard(OrderModel order) {
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final dateFormat =
        DateFormat('MMM dd, yyyy hh:mm a', isArabic ? 'ar' : 'en');

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              "${AppLocalizations.of(context)!.translate('order_placed')}: ${order.createdAt != null ? dateFormat.format(order.createdAt!.toDate()) : AppLocalizations.of(context)!.translate('unknown')}",
              style: MyTextTheme.body
                  .copyWith(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              "${AppLocalizations.of(context)!.translate('total')}: ${AppLocalizations.of(context)!.translate('qar')} ${order.totalAmount}",
              style: MyTextTheme.body
                  .copyWith(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              "${AppLocalizations.of(context)!.translate('ship_to')}: ${order.address.name.toUpperCase()}",
              style: MyTextTheme.body
                  .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  order.cartItems.first["productImageUrl"] ?? brownweetImage,
                  height: 50,
                  width: 50,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: isArabic
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.isArabic
                          ? order.cartItems.first["productarabicName"]
                          : order.cartItems.first["productName"],
                      style: MyTextTheme.body
                          .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${AppLocalizations.of(context)!.translate('qar')} ${order.cartItems.first["variantPrice"] ?? '0'}",
                      style: MyTextTheme.body
                          .copyWith(fontSize: 14, color: Colors.green),
                    ),
                    Text(
                      AppLocalizations.of(context)!
                          .translate(order.status.toLowerCase()),
                      style: MyTextTheme.body
                          .copyWith(fontSize: 12, color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
