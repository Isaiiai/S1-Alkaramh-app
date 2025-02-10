import 'package:alkaramh/app_localizations.dart';
import 'package:alkaramh/config/text/my_text_theme.dart';
import 'package:alkaramh/constants/image_deceleration.dart';
import 'package:alkaramh/models/product_model.dart';
import 'package:alkaramh/screens/home_screen/product_details_screen.dart';
import 'package:alkaramh/bloc/home_bloc/bloc/home_fetch_bloc.dart';
import 'package:alkaramh/bloc/product_fetch/product_fetch_bloc.dart';
import 'package:alkaramh/screens/wish_list/wish_list.dart';
import 'package:alkaramh/services/context_extensions.dart';
import 'package:alkaramh/services/wish_list_services.dart';
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
  WishListServices wishListServices = WishListServices();
  bool isSeeMore = false;
  bool isSearching = false; // Track search state
  List<Product> products = [];
  List<Category> categories = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<Product> filteredProducts = [];

  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    homeFetchBloc.add(CategoryFetchEvent());
    productFetchBloc.add(ProductFetchInitialEvent());
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void filterProductsByCategory(String categoryId) {
    setState(() {
      selectedCategory = categoryId;
      if (categoryId.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products
            .where((product) => product.categoryId == categoryId)
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _getFilteredProducts(List<Product> products) {
    if (_searchQuery.isEmpty) {
      return products;
    }
    return products
        .where((product) =>
            product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7EC),
      body: isSeeMore
          ? _buildSeeMoreProducts(context, categories, products)
          : isSearching
              ? _buildSearchResults(context)
              : _buildHomeProducts(context),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    List<Product> filteredProducts = _getFilteredProducts(products);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search here...",
                    hintStyle: MyTextTheme.body.copyWith(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          isSearching = false; // Close search mode
                        });
                      },
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

              // Search Results
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Text(AppLocalizations.of(context)!
                            .translate('no_products_found')))
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return ListTile(
                            leading: Image.network(
                                product.imageUrl ?? brownweetImage),
                            title: Text(product.name),
                            subtitle: Text(
                              AppLocalizations.of(context)!
                                  .translate('rating')
                                  .replaceFirst(
                                      '%s', product.rating.toString()),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                    productId: product.id.toString(),
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
        ),
      ),
    );
  }

  Widget _buildHomeProducts(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 8.0, right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      HomeScreenWidget()
                          .buildOfferCart(50, brownweetImage, context),
                      const SizedBox(width: 12),
                      HomeScreenWidget()
                          .buildOfferCart(50, brownweetImage, context),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!
                          .translate('select_by_category'),
                      style: MyTextTheme.headline.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSeeMore = true;
                          selectedCategory = ''; // Reset category selection
                          filteredProducts = products; // Show all products
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate('see_all'),
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
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSeeMore = true;
                                  selectedCategory = category.id;
                                  filterProductsByCategory(category.id);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: HomeScreenWidget()
                                    .buildSelectByCatagoryCircle(
                                  category.imageUrl!,
                                  context.isArabic
                                      ? category.categoryarabicName
                                      : category.categoryName,
                                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.translate('our_products'),
                      style: MyTextTheme.headline.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSeeMore = true;
                          selectedCategory = '';
                          filteredProducts = products;
                        });
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate('see_all'),
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
                            final product = state.products[index];
                            return HomeScreenWidget().buildOrderProductsList(
                              productId: product.id.toString(),
                              productImage: product.imageUrl!,
                              productName: context.isArabic
                                  ? product.arabicName
                                  : product.name,
                              productarabicName: product.arabicName,
                              description: product.description,
                              arabicDescription: product.arabicDescription,
                              starRating: product.rating,
                              context: context,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                      productId: product.id.toString(),
                                    ),
                                  ),
                                );
                              },
                            );
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
                  controller: _searchController,
                  readOnly: true,
                  onTap: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)!.translate('search_here'),
                    hintStyle: MyTextTheme.body.copyWith(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    suffixIcon: const Icon(Icons.search, color: Colors.green),
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

  Widget _buildSeeMoreProducts(
      BuildContext context, List<Category> categories, List<Product> products) {
    if (filteredProducts.isEmpty) {
      filteredProducts = products;
    }

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          isSeeMore = false;
        });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(selectedCategory.isEmpty
              ? AppLocalizations.of(context)!.translate('all_products')
              : categories
                  .firstWhere((cat) => cat.id == selectedCategory)
                  .categoryName),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  isSeeMore = false;
                });
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = selectedCategory == category.id;
                    return GestureDetector(
                      onTap: () => filterProductsByCategory(category.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            context.isArabic
                                ? category.categoryarabicName
                                : category.categoryName,
                            style: MyTextTheme.body.copyWith(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Text(AppLocalizations.of(context)!
                            .translate('no_products_found')))
                    : GridView.builder(
                        itemCount: filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailsScreen(
                                    productId: product.id.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[500],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Image.network(
                                            product.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                brownweetImage,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
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
                                              context.isArabic
                                                  ? product.arabicName
                                                  : product.name,
                                              style: MyTextTheme.body.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              AppLocalizations.of(context)!
                                                  .translate('rating')
                                                  .replaceFirst(
                                                      '%s',
                                                      product.rating
                                                          .toString()),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      height: 28,
                                      width: 28,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      child: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return FutureBuilder<bool>(
                                            future:
                                                wishListServices.isInWishList(
                                                    product.id.toString()),
                                            builder: (context, snapshot) {
                                              final isInWishlist =
                                                  snapshot.data ?? false;
                                              return IconButton(
                                                constraints:
                                                    const BoxConstraints(
                                                  minWidth: 36,
                                                  minHeight: 36,
                                                ),
                                                padding: EdgeInsets.zero,
                                                icon: Icon(
                                                  isInWishlist
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: isInWishlist
                                                      ? Colors.red
                                                      : Colors.grey,
                                                  size: 18,
                                                ),
                                                onPressed: () async {
                                                  try {
                                                    if (isInWishlist) {
                                                      await wishListServices
                                                          .removeFromWishList(
                                                              product.id
                                                                  .toString());
                                                    } else {
                                                      await wishListServices
                                                          .addToWishList(
                                                        productId: product.id
                                                            .toString(),
                                                        productName:
                                                            product.name,
                                                        productarabicName:
                                                            product.arabicName,
                                                        description:
                                                            product.description,
                                                        arabicDescription: product
                                                            .arabicDescription,
                                                      );
                                                    }

                                                    setState(() {});

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          isInWishlist
                                                              ? AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .translate(
                                                                      'remove_from_wishlist')
                                                              : AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .translate(
                                                                      'add_to_wishlist'),
                                                        ),
                                                        backgroundColor:
                                                            Colors.green,
                                                      ),
                                                    );
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content:
                                                            Text(e.toString()),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
