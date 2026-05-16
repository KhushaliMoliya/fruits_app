import 'package:flutter/material.dart';
import 'package:fruits_app/screens/product_detail.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  final List<Map<String, dynamic>> allProducts;

  const CategoryPage({
    super.key,
    required this.category,
    required this.allProducts,
  });

  List<Map<String, dynamic>> get filteredList {
    if (category == "All") return allProducts;

    if (category == "Winter") {
      return allProducts.where((item) => item["name"] == "Orange").toList();
    }

    if (category == "Summer") {
      return allProducts.where((item) => item["name"] == "Watermelon").toList();
    }

    if (category == "Monsoon") {
      return allProducts.where((item) => item["name"] == "Pineapple").toList();
    }

    return allProducts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        backgroundColor: Colors.green,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (context, index) {
          final product = filteredList[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(
                    name: product["name"],
                    price: product["price"],
                    oldPrice: product["oldPrice"],
                    image: product["image"],
                    description: product["description"],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(product["image"]),
                  ),
                  const SizedBox(height: 5),
                  Text(product["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(product["price"],
                      style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}