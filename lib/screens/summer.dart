import 'package:flutter/material.dart';
import 'package:fruits_app/screens/favourite.dart';
import 'package:fruits_app/screens/product_detail.dart';
import 'package:fruits_app/screens/cart.dart';
import 'package:fruits_app/screens/profile.dart';

class SummerPage extends StatefulWidget {
  const SummerPage({super.key});

  @override
  State<SummerPage> createState() => _SummerPageState();
}

class _SummerPageState extends State<SummerPage> {

  List<bool> favouriteList = [false, false, false, false];

  final List<Map<String, String>> fruits = [
    {
      "name": "Strawberry",
      "price": "₹40/kg",
      "oldPrice": "₹50/kg",
      "image": "assets/featur-2.jpg"
    },
    {
      "name": "Mango",
      "price": "₹120/kg",
      "oldPrice": "₹140/kg",
      "image": "assets/mango.png"
    },
    {
      "name": "Banana",
      "price": "₹100/kg",
      "oldPrice": "₹120/kg",
      "image": "assets/Banana.png"
    },
    {
      "name": "Grapes",
      "price": "₹60/kg",
      "oldPrice": "₹80/kg",
      "image": "assets/greeps.png"
    },
  ];

  void toggleFavourite(int index){

    final fruit = fruits[index];

    setState(() {
      favouriteList[index] = !favouriteList[index];
    });

    if(favouriteList[index]){

      FavouritePage.favouritedItems.add({
        "name": fruit["name"],
        "price": fruit["price"],
        "image": fruit["image"],
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const FavouritePage()),
      );

    }else{

      FavouritePage.favouritedItems
          .removeWhere((item) => item["name"] == fruit["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),

      appBar: AppBar(
        title: const Text(
          "Summer Fruits",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.85,
        ),

        itemCount: fruits.length,

        itemBuilder: (context, index) {

          final fruit = fruits[index];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                )
              ],
            ),

            child: Column(
              children: [

                Expanded(
                  child: Stack(
                    children: [

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            fruit["image"]!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      Positioned(
                        top: 5,
                        right: 5,
                        child: IconButton(
                          icon: Icon(
                            favouriteList[index]
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.green,
                          ),
                          onPressed: (){
                            toggleFavourite(index);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  fruit["name"]!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  fruit["price"]!,
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(
                          name: fruit["name"]!,
                          price: fruit["price"]!,
                          oldPrice: fruit["oldPrice"]!,
                          image: fruit["image"]!,
                          description:
                          "${fruit["name"]} is a healthy summer fruit rich in vitamins.",
                        ),
                      ),
                    );
                  },

                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "View Details",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,

        onTap: (index) {

          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavouritePage()),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CartPage()),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
          ),

        ],
      ),
    );
  }
}