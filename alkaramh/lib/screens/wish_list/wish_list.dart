import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/bloc/wish_list/wishlist_bloc.dart';
import 'package:alkaramh/config/color/colors_file.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/home_screen/product_details_screen.dart';
import 'package:alkaramh/services/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishList extends StatefulWidget {
  const WishList({super.key});

  @override
  State<WishList> createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  final WishlistBloc wishlistBloc = WishlistBloc();

  @override
  void initState() {
    super.initState();
    wishlistBloc.add(FetchWishlistEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackGroundColor,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate('wishlist'),
          style: MyTextTheme.body.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        bloc: wishlistBloc,
        builder: (context, state) {
          if (state is WishlistLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WishlistError) {
            return Center(child: Text(state.message));
          }

          if (state is WishlistSuccessState) {
            if (state.wishlists.isEmpty) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.translate('empty_wishlist'),
                  style: MyTextTheme.body,
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.wishlists.length,
              itemBuilder: (context, index) {
                final item = state.wishlists[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                      productId: item['productId'],
                                    ),
                                  ),
                                );
                  },
                  child: Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
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
                                Text(
                                  context.isArabic
                                      ? item['productarabicName']
                                      : item['productName'],
                                  style: MyTextTheme.body.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  context.isArabic
                                      ? item['arabicDescription']
                                      : item['description'],
                                  style: MyTextTheme.body.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.red),
                            onPressed: () async {
                              wishlistBloc.add(
                                RemoveWishListEvent(
                                  productId: item['productId'],
                                ),
                              );
                              wishlistBloc.add(FetchWishlistEvent());
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
