import 'dart:ffi';

import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/screens/home_screen/product_details_screen.dart';
import 'package:alkaramh/services/wish_list_services.dart';
import 'package:flutter/material.dart';

class HomeScreenWidget {
  buildOfferCart(int offer, String offerProductImage, context) {
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
                  AppLocalizations.of(context)!
                      .translate('special_offer')
                      .replaceFirst('%s', offer.toString()),
                  style: MyTextTheme.body.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    print("Offer Page Clicked");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.translate('offer_page'),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.translate('shop_now'),
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
    return Container(
      height: 140,
      child: Column(
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
              child: Image.network(
                productImage,
                fit: BoxFit.fill,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    productImage,
                    fit: BoxFit.cover,
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                      strokeWidth: 2.0,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: 80, // Match width with image container
              child: Text(
                title,
                style: MyTextTheme.headline.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildOrderProductsList({
    required String productId,
    required String productImage,
    required String productName,
    required String productarabicName,
    required String description,
    required String arabicDescription,
    required VoidCallback? onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 190,
        height: 190,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
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
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          productImage,
                          height: 97,
                          width: 108,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              productImage,
                              fit: BoxFit.cover,
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return FutureBuilder<bool>(
                          future: WishListServices().isInWishList(productId),
                          builder: (context, snapshot) {
                            final isInWishlist = snapshot.data ?? false;
                            return GestureDetector(
                              onTap: () async {
                                try {
                                  if (isInWishlist) {
                                    await WishListServices()
                                        .removeFromWishList(productId);
                                  } else {
                                    await WishListServices().addToWishList(
                                      productId: productId,
                                      productName: productName,
                                      productarabicName: productarabicName,
                                      description: description,
                                      arabicDescription: arabicDescription,
                                    );
                                  }
                                  setState(() {}); // Refresh icon state

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        isInWishlist
                                            ? AppLocalizations.of(context)!
                                                .translate(
                                                    'remove_from_wishlist')
                                            : AppLocalizations.of(context)!
                                                .translate('add_to_wishlist'),
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString()),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    isInWishlist
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        isInWishlist ? Colors.red : Colors.grey,
                                    size: 18,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      productName,
                      style: MyTextTheme.body.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
