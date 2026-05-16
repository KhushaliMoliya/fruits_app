import 'package:flutter/material.dart';
import 'package:fruits_app/screens/home.dart';
import 'package:fruits_app/screens/favourite.dart';
import 'package:fruits_app/screens/buynow.dart';
import 'package:fruits_app/screens/profile.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static List<Map<String, dynamic>> cartItems = [];

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _currentIndex = 2;

  final List<Color> itemBackgroundColors = [
    const Color(0xFFFFF3CD),
    const Color(0xFFD4EDDA),
    const Color(0xFFF8D7DA),
  ];

  Color _getItemBackgroundColor(int index) {
    return itemBackgroundColors[index % itemBackgroundColors.length];
  }

  /// REMOVE PRODUCT
  void removeItem(int index) {
    setState(() {
      CartPage.cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Product removed from cart")),
    );
  }

  /// SUBTOTAL
  double get subtotalAmount {
    double total = 0;

    for (var item in CartPage.cartItems) {
      double price = double.tryParse(item['price'].toString()) ?? 0;
      total += price;
    }

    return total;
  }

  /// TOTAL
  double get totalAmount {
    return subtotalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 20),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'My Cart',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18),
        ),

        centerTitle: true,
      ),

      body: CartPage.cartItems.isEmpty
          ? const Center(
              child: Text(
              'Cart is currently empty.',
              style: TextStyle(color: Colors.grey),
            ))
          : SingleChildScrollView(
              child: Column(
                children: [

                  /// ITEM COUNT
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${CartPage.cartItems.length} items',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.grey),
                      ),
                    ),
                  ),

                  /// CART ITEMS
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: CartPage.cartItems.length,
                    itemBuilder: (context, index) {

                      final item = CartPage.cartItems[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: _getItemBackgroundColor(index),
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: Row(
                          children: [

                            item['image'] != null &&
                                    item['image'].toString().toLowerCase().startsWith('http')
                                ? Image.network(
                                    item['image'],
                                    width: 70,
                                    height: 70,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                  )
                                : Image.asset(
                                    item['image'] ?? 'assets/toma.avif',
                                    width: 70,
                                    height: 70,
                                  ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [

                                  /// PRODUCT NAME
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  /// PRODUCT DETAILS
                                  Text(
                                    item['details'] ?? "Fresh farm product",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              children: [

                                /// PRICE
                                Text(
                                  "₹${item['price']}",
                                  style: const TextStyle(
                                      color: Color(0xFF4CAF50),
                                      fontWeight: FontWeight.bold),
                                ),

                                const SizedBox(height: 8),

                                /// REMOVE BUTTON
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    removeItem(index);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// SUMMARY
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [

                        _summaryRow(
                          "Subtotal",
                          "₹${subtotalAmount.toStringAsFixed(2)}",
                        ),

                        const Divider(),

                        _summaryRow(
                          "Total",
                          "₹${totalAmount.toStringAsFixed(2)}",
                          isBold: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// CONTINUE BUTTON
                  Padding(
                    padding: const EdgeInsets.all(16),

                    child: SizedBox(
                      width: double.infinity,
                      height: 50,

                      child: ElevatedButton(
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  BuyNowPage(),
                            ),
                          );

                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D5016),
                        ),

                        child: const Text(
                          "Continue",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _currentIndex,

        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,

        onTap: (index) {

          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) =>  HomePage()));
          }

          if (index == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const FavouritePage()));
          }

          if (index == 3) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        const ProfilePage()));
          }

        },

        items: const [

          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),

          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favourite"),

          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Cart"),

          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Account"),

        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value,
      {bool isBold = false}) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Text(title),

        Text(
          value,
          style: TextStyle(
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal),
        )

      ],
    );
  }
}