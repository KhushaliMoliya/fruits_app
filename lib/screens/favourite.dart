import 'package:flutter/material.dart';
import 'package:fruits_app/screens/cart.dart';
import 'package:fruits_app/screens/home.dart';
import 'package:fruits_app/screens/product_detail.dart';
import 'package:fruits_app/screens/profile.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  static List<Map<String, dynamic>> favouritedItems = [];

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Favourite Products"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: FavouritePage.favouritedItems.isEmpty
          ? const Center(
              child: Text(
                "No Favourite Products",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: FavouritePage.favouritedItems.length,
              itemBuilder: (context, index) {

                final product = FavouritePage.favouritedItems[index];

                return Card(
                  margin: const EdgeInsets.all(10),

                  child: Padding(
                    padding: const EdgeInsets.all(10),

                    child: Column(
                      children: [

                        /// PRODUCT ROW
                        Row(
                          children: [

                            product["image"] != null &&
                                    product["image"].toString().toLowerCase().startsWith('http')
                                ? Image.network(
                                    product["image"],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                  )
                                : Image.asset(
                                    product["image"] ?? 'assets/toma.avif',
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    product["name"],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),

                                  const SizedBox(height: 5),

                                  Text(product["price"]),

                                ],
                              ),
                            ),

                            /// DELETE BUTTON
                            IconButton(
                              icon: const Icon(Icons.delete,color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  FavouritePage.favouritedItems.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height:10),

                        /// PRODUCT DETAILS BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),

                            onPressed: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailPage(
                                    name: product["name"],
                                    price: product["price"],
                                    oldPrice: product["oldPrice"] ?? "",
                                    image: product["image"],
                                    description: product["description"] ?? "Fresh and organic fruit.",
                                  ),
                                ),
                              );

                            },

                            child: const Text("Product Details"),
                          ),
                        )

                      ],
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: BottomNavigationBar(

        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,

        onTap: (index){

          if(index==0){
            Navigator.push(context,
                MaterialPageRoute(builder: (_) =>  HomePage()));
          }

          if(index==1){
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FavouritePage()));
          }

          if(index==2){
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CartPage()));
          }

          if(index==3){
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ProfilePage()));
          }

        },

        items: const [

          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: ""),

          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: ""),

          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: ""),

          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: ""),

        ],
      ),
    );
  }
}