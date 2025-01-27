import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/models/product_model.dart';
import 'package:alkaramh/view_model/product_fetch/product_fetch_bloc.dart';
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
  String selectedQuantity = "1"; // Default quantity
  TextEditingController customQuantityController = TextEditingController();
  ProductFetchBloc productFetchBloc = ProductFetchBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productFetchBloc.add(ProductDetailsFetchEvent(productId: widget.productId));
    productFetchBloc.add(ProductVariantFetchEvent(productId: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Detail Product",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<ProductFetchBloc, ProductFetchState>(
          bloc: productFetchBloc,
          listener: (context, state) {
            // TODO: implement listener
            if (state is ProductFetchErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ProductFetchLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is ProductFetchErrorState) {
              return Center(child: Text(state.message));
            }
            if (state is ProductFetchLoadedState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Image.asset(
                        brownweetImage, // Replace with your asset path
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Product Details Container
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 5,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and Rating
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.products[0].name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                             Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.orange, size: 20),
                                Text(
                                 state.products[0].rating.toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                               
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Price
                        Text(
                          state.products[0].categoryId,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 16),
                        // Description
                        Text(
                          state.products[0].description,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        SizedBox(height: 16),
                        // Select Quantity
                        Text(
                          "Select Quantity",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildQuantityButton(context, "10"),
                            _buildQuantityButton(context, "50"),
                            
                          ],
                        ),
                       const SizedBox(height: 200),
                        // Add to Cart and Buy Now Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Colors.green),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child:const Text(
                                  "Add to cart",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ),
                          const  SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  print("Selected Quantity: $selectedQuantity");
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child:const Text("Buy Now"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: Text("Some error occring "),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuantityButton(BuildContext context, String label) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedQuantity = label;
        });
      },
      style: OutlinedButton.styleFrom(
        side:const BorderSide(color: Colors.green),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(label, style: TextStyle(color: Colors.green)),
    );
  }

  
}
