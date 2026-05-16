import 'package:flutter/material.dart';
import 'package:fruits_app/screens/cart.dart';
import 'package:fruits_app/screens/buynow.dart';
import 'package:fruits_app/screens/favourite.dart';

class ProductDetailPage extends StatefulWidget {
  final String name;
  final String price;
  final String oldPrice;
  final String image;
  final String description;

  const ProductDetailPage({
    super.key,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.description,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  int grams = 250;

  bool isFav = false;

  /// ⭐ Rating value (default)
  double rating = 4.0;

  Map<String, dynamic> get product => {
        "name": widget.name,
        "price": widget.price,
        "image": widget.image,
      };

  int get pricePerKg {
    final cleaned = widget.price.replaceAll(RegExp(r'[^0-9.]'), '');
    final parsed = double.tryParse(cleaned) ?? 0.0;
    return parsed.round();
  }

  double get totalPrice {
    return (pricePerKg / 1000) * grams;
  }

  Widget buildProductImage() {
    if (widget.image.toLowerCase().startsWith('http')) {
      return Image.network(
        widget.image,
        height: 200,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 80),
      );
    }
    return Image.asset(
      widget.image,
      height: 200,
      fit: BoxFit.contain,
    );
  }

  void addToCart() {
    CartPage.cartItems.add({
      "name": widget.name,
      "price": totalPrice,
      "image": widget.image,
      "quantity": grams
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${widget.name} added to cart"),
        backgroundColor: Colors.green,
      ),
    );
  }

 void buyNow() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BuyNowPage(
        product: {
          "name": widget.name,
          "price": totalPrice, // ✅ important
          "image": widget.image,
        },
      ),
    ),
  );
}

  void toggleFavourite() {
    setState(() {
      isFav = !isFav;
    });

    if (isFav) {
      FavouritePage.favouritedItems.add(product);
    } else {
      FavouritePage.favouritedItems
          .removeWhere((item) => item["name"] == widget.name);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            isFav ? "Added to Favourite ❤️" : "Removed from Favourite"),
      ),
    );
  }

  /// ⭐ Star Widget Builder
  Widget buildStar(int index) {
    return IconButton(
      onPressed: () {
        setState(() {
          rating = index + 1.0;
        });
      },
      icon: Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Center(
              child: buildProductImage(),
            ),

            const SizedBox(height: 20),

            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            

            const SizedBox(height: 10),

            Row(
              children: [
                Text(
                  widget.price,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.oldPrice,
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),

                const Spacer(),

                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: toggleFavourite,
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(widget.description),

            const SizedBox(height: 30),

            const Text(
              "Select Quantity",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              children: [
                qtyButton(250),
                qtyButton(500),
                qtyButton(1000),
                qtyButton(2000),
                qtyButton(3000),
              ],
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(grams >= 1000 ? "${grams/1000} kg" : "$grams gm"),
                  Text(
                    "₹${totalPrice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) => buildStar(index)),
                ),
                const SizedBox(width: 10),
                Text(
                  rating.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Spacer(),

            Row(
              children: [

                Expanded(
                  child: ElevatedButton(
                    onPressed: addToCart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text("Add To Cart"),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: OutlinedButton(
                    onPressed: buyNow,
                    child: const Text("Buy Now"),
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  Widget qtyButton(int value) {
    return ChoiceChip(
      label: Text(value >= 1000 ? "${value/1000} kg" : "$value gm"),
      selected: grams == value,
      onSelected: (_) {
        setState(() {
          grams = value;
        });
      },
    );
  }
}