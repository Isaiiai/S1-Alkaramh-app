import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/models/product_model.dart';
import 'package:alkaramh/screens/home_screen/product_details_screen.dart';
import 'package:alkaramh/bloc/home_bloc/bloc/home_fetch_bloc.dart';
import 'package:alkaramh/bloc/product_fetch/product_fetch_bloc.dart';
import 'package:alkaramh/screens/wish_list/wish_list.dart';
import 'package:alkaramh/widget/home_screen/home_screen_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  List<Product> products = [];

  // List of categories
  List<Category> categories = [];

  // Test data for products mapped to categories

  String selectedCategory = 'Hay';

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
          ? _buildSeeMoreProducts(context, categories, products)
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
                    }
                  },
                  builder: (context, state) {
                    if (state is CategoryFetchLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is CategoryFetchSuccessState) {
                      categories = state.categories;
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
        //info: Top Search Bar
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
                icon: const Icon(Icons.favorite_border, color: Colors.grey),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const WishList();
                  }));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  //info: Build SeeMore Products
  Widget _buildSeeMoreProducts(
      BuildContext context, List<Category> categories, List<Product> products) {
    String? selectedCategoryId = categories
        .firstWhere(
          (category) => category.categoryName == selectedCategory,
          orElse: () => categories.first,
        )
        .id;

    List<Product> filteredProducts = products
        .where((product) => product.categoryId == selectedCategoryId)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        const SizedBox(height: 80),
            
                        // Categories
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              final category = categories[index];
                              final isSelected =
                                  category.categoryName == selectedCategory;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategory = category.categoryName;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          isSelected ? Colors.green : Colors.grey,
                                    ),
                                  ),
                                  child: Text(
                                    category.categoryName,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                 
                  // Products Grid
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: filteredProducts.isEmpty
                        ? SliverToBoxAdapter(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(height: 100),
                                  Text('No products in this category'),
                                ],
                              ),
                            ),
                          )
                        : SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.8,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final product = filteredProducts[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailsScreen(
                                          productId: product.id.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    product.imageUrl ??
                                                        brownweetImage),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Category: ${product.categoryId}',
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.star,
                                                    size: 16,
                                                    color: Colors.orange,
                                                  ),
                                                  Text(
                                                    product.rating.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              childCount: filteredProducts.length,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),

          // Header
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      isSeeMore = false;
                    });
                  },
                ),
                const Spacer(),
                Text(
                  'Our Products',
                  style: MyTextTheme.body.copyWith(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.settings),
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
