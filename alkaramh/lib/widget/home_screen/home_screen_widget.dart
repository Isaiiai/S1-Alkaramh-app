import 'dart:ffi';

import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/screens/home_screen/product_details_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenWidget {
  buildOfferCart(int offer, String offerProductImage) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Get your special \n offer up to $offer%",
                  style: MyTextTheme.body.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    print("Offer Page Clicked");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    "Shop Now",
                    style: MyTextTheme.body.copyWith(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Image.asset(
            offerProductImage, // Replace with your image URL
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  buildSelectByCatagoryCircle(String productImage, String title) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Center(
            child: Image.asset(
              productImage, // Replace with your image URL
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: MyTextTheme.headline.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  buildOrderProductsList(
      String productImage, String productName, double starRating,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Background color of the container
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 190,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        // Ensure the image matches the container's border
                        child: Image.asset(
                          productImage,
                          height: 97,
                          width: 108,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 30, // Adjust size as needed
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Background color
                        shape: BoxShape.circle, // Makes it circular
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.1), // Subtle shadow
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.grey,
                          size: 18, // Adjust icon size as needed
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      productName,
                      style: MyTextTheme.body.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 5),

                  // Star Rating
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        SizedBox(width: 5),
                        Text(
                          starRating.toStringAsFixed(1),
                          style: MyTextTheme.headline.copyWith(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Product Name

              const SizedBox(height: 5),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Text(
              //     "QAR ${price}", // Price can be dynamic
              //     style: MyTextTheme.headline.copyWith(
              //       fontSize: 14,
              //       fontWeight: FontWeight.w700,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
