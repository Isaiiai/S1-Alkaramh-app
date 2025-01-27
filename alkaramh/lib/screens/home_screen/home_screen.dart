import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/screens/home_screen/product_details_screen.dart';
import 'package:alkaramh/view_model/home_bloc/bloc/home_fetch_bloc.dart';
import 'package:alkaramh/view_model/product_fetch/product_fetch_bloc.dart';
import 'package:alkaramh/widget/home_screen/home_screen_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeFetchBloc homeFetchBloc = HomeFetchBloc();
  final ProductFetchBloc productFetchBloc = ProductFetchBloc();

  @override
  void initState() {
    super.initState();
    print("This is Inside initState");
    homeFetchBloc.add(CategoryFetchEvent());
    productFetchBloc.add(ProductFetchInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F7EC),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50.0,
                  left: 16.0,
                  right: 16.0), // Adjust top padding for floating effect
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HomeScreenWidget().buildOfferCart(50, brownweetImage),
                        const SizedBox(width: 12),
                        HomeScreenWidget().buildOfferCart(50, brownweetImage),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Select by category",
                        style: MyTextTheme.headline.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See all",
                          style: MyTextTheme.body.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFA47148),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<HomeFetchBloc, HomeFetchState>(
                    bloc: homeFetchBloc,
                    builder: (context, state) {
                      if (state is CategoryFetchLoadingState) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is CategoryFetchSuccessState) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: state.categories.map((category) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: HomeScreenWidget()
                                    .buildSelectByCatagoryCircle(
                                  catatoryHayImage,
                                  category.categoryName,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      }

                      if (state is CategoryFetchErrorState) {
                        return Center(child: Text(state.message));
                      }

                      return const SizedBox();
                    },
                  ),
                  const SizedBox(height: 20),
                  // Our Products
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Our Products",
                        style: MyTextTheme.headline.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See all",
                          style: MyTextTheme.body.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFFA47148),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 240,
                    child: BlocBuilder<ProductFetchBloc, ProductFetchState>(
                      bloc: productFetchBloc,
                      builder: (context, state) {
                        if (state is ProductFetchLoadingState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is ProductFetchLoadedState) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.products.length,
                            itemBuilder: (context, index) {
                              final products = state.products[index];
                              return HomeScreenWidget().buildOrderProductsList(
                                  brownweetImage, // TODO: Replace with product.imageUrl
                                  products.name,
                                 
                                  products.rating, onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                      productId: products.id.toString(),
                                    ),
                                  ),
                                );
                              });
                            },
                          );
                        }

                        if (state is ProductFetchErrorState) {
                          return Center(child: Text(state.message));
                        }

                        return const SizedBox();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search here...",
                      hintStyle: MyTextTheme.body.copyWith(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.favorite_border, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
