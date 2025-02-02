import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/models/order_model.dart';
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
      appBar: AppBar(title: Text("Your Orders")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? Center(child: Text("No orders found"))
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
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order details
            Text(
              "ORDER PLACED: ${order.createdAt != null ? DateFormat('MMM dd, yyyy hh:mm a').format(order.createdAt!.toDate()) : 'Unknown'}",
              style: MyTextTheme.body
                  .copyWith(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              "TOTAL: QAR ${order.totalAmount}",
              style: MyTextTheme.body
                  .copyWith(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              "SHIP TO: ${order.address.name.toUpperCase()}",
              style: MyTextTheme.body
                  .copyWith(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),

          
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  brownweetImage,
                  height: 50,
                  width: 50,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.cartItems.first["productName"] ?? "Unknown Product",
                      style: MyTextTheme.body
                          .copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "QAR ${order.cartItems.first["variantPrice"] ?? '0'}",
                      style: MyTextTheme.body
                          .copyWith(fontSize: 14, color: Colors.green),
                    ),
                    Text(
                      order.status,
                      style: MyTextTheme.body
                          .copyWith(fontSize: 12, color: Colors.orange),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (order.status == "pending")
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Order tracking is not available"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      minimumSize: const Size(120, 40),
                    ),
                    child: Text(
                      "Track your order",
                      style: MyTextTheme.body.copyWith(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                if (order.status == "delivered")
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      minimumSize: const Size(120, 40),
                    ),
                    child: Text("Buy it again"),
                  ),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Edit Order was not implemented"),
                        ),
                      );
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    minimumSize: const Size(120, 40),
                  ),
                  child: Text(
                    order.status == "pending"
                        ? "View or edit order"
                        : "View items",
                    style: MyTextTheme.body.copyWith(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
