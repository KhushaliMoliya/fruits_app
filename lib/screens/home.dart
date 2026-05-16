import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fruits_app/screens/cart.dart';
import 'package:fruits_app/screens/favourite.dart';
import 'package:fruits_app/screens/product_detail.dart';
import 'package:fruits_app/screens/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? _timer;
  final PageController _pageController = PageController();

  int _currentIndex = 0;
  int currentPage = 0;

  bool isDarkMode = false;
  String searchText = "";
  String selectedCategory = "All";

  Set<String> favouriteItems = {};

  final List<String> categories = ["All", "Summer", "Winter", "Monsoon"];

  final List<String> sliderImages = [
    "assets/f1.png",
    "assets/f2.png",
    "assets/f3.png",
  ];

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  bool isNetworkImage(String image) {
    return image.toLowerCase().startsWith("http");
  }

  String formatPrice(dynamic price) {
    if (price == null) return "₹0";

    if (price is num) {
      return "₹${price.toStringAsFixed(price % 1 == 0 ? 0 : 2)}";
    }

    return "₹${price.toString()}";
  }

  bool parseStock(dynamic stock) {
    if (stock is bool) return stock;

    if (stock is String) {
      return stock.toLowerCase() == "in stock";
    }

    return false;
  }

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted || !_pageController.hasClients) return;

      currentPage = (currentPage + 1) % sliderImages.length;

      _pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void toggleFavourite(Map<String, dynamic> product) {
    final productName = product["name"] as String;

    if (!favouriteItems.contains(productName)) {
      setState(() {
        favouriteItems.add(productName);
        FavouritePage.favouritedItems.add(product);
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => FavouritePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.green,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage()),
                );
              },
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/profile.png"),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getGreeting(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "User",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Search fruits...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor:
                    isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          SizedBox(
            height: 150,
            child: PageView.builder(
              controller: _pageController,
              itemCount: sliderImages.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  sliderImages[index],
                  fit: BoxFit.cover,
                );
              },
            ),
          ),

          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.green : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                  .collection("product")
                  .where("published", isEqualTo: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No products available",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }

                final products = snapshot.data!.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;

                  return <String, dynamic>{
                    "id": doc.id,
                    "name": data["name"]?.toString() ?? "",
                    "price": formatPrice(data["price"]),
                    "image": data["image"]?.toString() ?? "assets/toma.avif",
                    "category": data["category"]?.toString() ?? "All",
                    "stock": parseStock(data["stock"]),
                    "description": data["description"]?.toString() ?? "",
                  };
                }).toList();

                final filteredProducts = products.where((product) {
                  final name = product["name"] as String;
                  final category = product["category"] as String;

                  final matchesSearch = name
                      .toLowerCase()
                      .contains(searchText.toLowerCase());

                  final matchesCategory =
                      selectedCategory == "All" || category == selectedCategory;

                  return matchesSearch && matchesCategory;
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Text(
                      "No products match your search",
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredProducts.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];

                    final name = product["name"] as String;
                    final image = product["image"] as String;
                    final stock = product["stock"] as bool;
                    final price = product["price"] as String;
                    final description = product["description"] as String;

                    final isFav = favouriteItems.contains(name);

                    return GestureDetector(
                      onTap: stock
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailPage(
                                    name: name,
                                    price: price,
                                    oldPrice: "₹0",
                                    image: image,
                                    description: description,
                                  ),
                                ),
                              );
                            }
                          : null,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        color:
                            isDarkMode ? Colors.grey.shade900 : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    toggleFavourite(product);
                                  },
                                ),
                              ),

                              Expanded(
                                child: Center(
                                  child: isNetworkImage(image)
                                      ? Image.network(
                                          image,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) =>
                                                  const Icon(
                                            Icons.broken_image,
                                            size: 60,
                                          ),
                                        )
                                      : Image.asset(
                                          image,
                                          height: 80,
                                        ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    stock
                                        ? "In Stock"
                                        : "Out of Stock",
                                    style: TextStyle(
                                      color: stock
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavouritePage()),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartPage()),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favourite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          ),
        ],
      ),
    );
  }
}