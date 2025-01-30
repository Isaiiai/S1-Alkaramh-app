import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/models/product_model.dart';
import 'package:alkaramh/screens/home_screen/product_details_screen.dart';
import 'package:alkaramh/bloc/home_bloc/bloc/home_fetch_bloc.dart';
import 'package:alkaramh/bloc/product_fetch/product_fetch_bloc.dart';
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
  bool isSeeMore = false;
  List<Category> productVarient = [];
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    homeFetchBloc.add(CategoryFetchEvent());
    productFetchBloc.add(ProductFetchInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F7EC),
      body: isSeeMore
          ? _buildSeeMoreProducts(context, productVarient, products)
          : _buildHomeProducts(context),
    );
  }

  //info: Build Products Home
  Widget _buildHomeProducts(BuildContext context) {
    return Stack(
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
                      onPressed: () {
                        setState(() {
                          isSeeMore = true;
                        });
                      },
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
                BlocConsumer<HomeFetchBloc, HomeFetchState>(
                  bloc: homeFetchBloc,
                  listener: (context, state) {
                    if (state is CategoryFetchErrorState) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is CategoryFetchSuccessState) {
                      productVarient = state.categories;
                    }
                  },
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
                      onPressed: () {
                        setState(() {
                          isSeeMore = true;
                        });
                      },
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
                  child: BlocConsumer<ProductFetchBloc, ProductFetchState>(
                    bloc: productFetchBloc,
                    listener: (context, state) {
                      if (state is ProductFetchErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)));
                      } else if (state is ProductFetchLoadedState) {
                        products = state.products;
                      }
                    },
                    builder: (context, state) {
                      if (state is ProductFetchLoadingState) {
                        return const Center(child: CircularProgressIndicator());
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
    );
  }

  // List of categories
  final List<String> categories = [
    'Aala Feed',
    'Alfalfa',
    'Corn',
    'Dates',
    'Hay',
    'Hen Feed'
  ];

  // Test data for products mapped to categories

  String selectedCategory = 'Aala Feed';

  //info: Build SeeMore Products
  Widget _buildSeeMoreProducts(BuildContext context,
      List<Category> categoryList, List<Product> products) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isSeeMore = false;
        });
        return false;
      },
      child: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final isSelected = category == selectedCategory;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategory = category;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  category,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.black,
                                  ),
                                ),
                                if (isSelected)
                                  const SizedBox(
                                    height: 5,
                                  ),
                                if (isSelected)
                                  Container(
                                    height: 3,
                                    width: 30,
                                    color: Colors.green,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  //               Expanded
                  //                 child: GridView.builder(
                  //                   padding: const EdgeInsets.all(10),
                  //                   gridDelegate:
                  //                       const SliverGridDelegateWithFixedCrossAxisCount(
                  //                     crossAxisCount: 2,
                  //                     mainAxisSpacing: 10,
                  //                     crossAxisSpacing: 10,
                  //                     childAspectRatio: 0.8,
                  //                   ),
                  //                   itemCount: products[ind]?.length ?? 0,
                  //                   itemBuilder: (context, index) {
                  //                     final product = products[selectedCategory]![index];
                  //                     return Card(
                  //                       shape: RoundedRectangleBorder(
                  //                         borderRadius: BorderRadius.circular(10),
                  //                       ),
                  //                       elevation: 3,
                  //                       child: Column(
                  //                         crossAxisAlignment: CrossAxisAlignment.start,
                  //                         children: [
                  //                           Expanded(
                  //                             child: Container(
                  //                               decoration: BoxDecoration(
                  //                                 borderRadius: const BorderRadius.vertical(
                  //                                     top: Radius.circular(10)),
                  //                                 image: DecorationImage(
                  //                                   image: AssetImage(product['image']),
                  //                                   fit: BoxFit.cover,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                           Padding(
                  //                             padding: const EdgeInsets.all(8.0),
                  //                             child: Column(
                  //                               crossAxisAlignment: CrossAxisAlignment.start,
                  //                               children: [
                  //                                 Text(
                  //                                   product['name'],
                  //                                   style: const TextStyle(
                  //                                     fontWeight: FontWeight.bold,
                  //                                   ),
                  //                                 ),
                  //                                 Text(
                  //                                   product['price'],
                  //                                   style:
                  //                                       const TextStyle(color: Colors.green),
                  //                                 ),
                  //                                 Row(
                  //                                   children: [
                  //                                     const Icon(Icons.star,
                  //                                         size: 16, color: Colors.orange),
                  //                                     Text(product['rating'].toString()),
                  //                                   ],
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     );
                  //                   },
                  //                 ),
                  //               ),
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
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () {
                    setState(() {
                      isSeeMore = false;
                    });
                  },
                ),
                const Spacer(),
                Container(
                  child: Text(
                    'Our Products',
                    style: MyTextTheme.body.copyWith(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                  ),
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
