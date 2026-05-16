import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fruits_app/screens/cart.dart';
import 'package:fruits_app/screens/orders.dart';

class BuyNowPage extends StatefulWidget {
  final Map<String, dynamic>? product;

  const BuyNowPage({super.key, this.product});

  @override
  State<BuyNowPage> createState() => _BuyNowPageState();
}

class _BuyNowPageState extends State<BuyNowPage> {

  String selectedPayment = "COD";
  String address = "21 Jump Street, New York";

  /// GOOGLE PAY
  Future<void> _launchGPay() async {
    final Uri url = Uri.parse('https://pay.google.com');

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  /// SUBTOTAL
  double calculateSubtotal() {
    double total = 0;

    if (widget.product != null) {
      double price =
          double.tryParse(widget.product!['price'].toString()) ?? 0;
      total += price;
    } else {
      for (var item in CartPage.cartItems) {
        double price =
            double.tryParse(item['price'].toString()) ?? 0;
        total += price;
      }
    }

    return total;
  }

  /// EDIT ADDRESS
  void _editAddress() {
    TextEditingController controller =
        TextEditingController(text: address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Address"),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: "Enter new address",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  address = controller.text;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    double subtotal = calculateSubtotal();
    double finalAmount = subtotal;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ADDRESS
            const Text(
              "Delivery Address",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 10),
                  Expanded(child: Text(address)),
                  TextButton(
                    onPressed: _editAddress,
                    child: const Text("Change",
                        style: TextStyle(color: Color(0xFF4CAF50))),
                  )
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// PAYMENT
            const Text(
              "Payment Method",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            _paymentOption(
              id: "GPAY",
              title: "Google Pay / UPI",
              icon: Icons.account_balance_wallet,
              color: Colors.blue,
              onTap: () {
                setState(() => selectedPayment = "GPAY");
                _launchGPay();
              },
            ),

            _paymentOption(
              id: "COD",
              title: "Cash on Delivery",
              icon: Icons.money,
              color: Colors.green,
              onTap: () {
                setState(() => selectedPayment = "COD");
              },
            ),

            const SizedBox(height: 25),

            /// ORDER SUMMARY
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            widget.product != null
                ? ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: widget.product!['image'] != null &&
                              widget.product!['image']
                                  .toString()
                                  .toLowerCase()
                                  .startsWith('http')
                          ? Image.network(
                              widget.product!['image'],
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                            )
                          : Image.asset(
                              widget.product!['image'] ?? 'assets/toma.avif',
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Text(widget.product!['name']),
                    trailing: Text("₹${widget.product!['price']}"),
                  )
                : Column(
                    children: CartPage.cartItems.map((item) {
                      double price =
                          double.tryParse(item['price'].toString()) ?? 0;

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: item['image'] != null &&
                                  item['image'].toString().toLowerCase().startsWith('http')
                              ? Image.network(
                                  item['image'],
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                                )
                              : Image.asset(
                                  item['image'] ?? 'assets/toma.avif',
                                  width: 45,
                                  height: 45,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        title: Text(item['name']),
                        trailing:
                            Text("₹${price.toStringAsFixed(0)}"),
                      );
                    }).toList(),
                  ),

            const Divider(height: 50),

            const Text(
              "Price Details",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            _priceRow("Subtotal", "₹${subtotal.toStringAsFixed(0)}"),
            const SizedBox(height: 8),
            _priceRow("Delivery Fee", "0"),
            const Divider(height: 30),

            _priceRow(
              "Total Amount",
              "₹${finalAmount.toStringAsFixed(0)}",
              isBold: true,
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      /// CONFIRM BUTTON
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () => _showSuccessDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            "Confirm Order",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _paymentOption({
    required String id,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    bool isSelected = selectedPayment == id;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4CAF50)
                : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected
              ? const Color(0xFFE8F5E9)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 15),
            Text(title),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFF4CAF50))
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String title, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: isBold ? 18 : 14,
                fontWeight:
                    isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal,
              color:
                  isBold ? const Color(0xFF4CAF50) : Colors.black,
            )),
      ],
    );
  }

  /// ✅ SUCCESS + SAVE ORDER
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                color: Color(0xFF4CAF50), size: 80),
            const SizedBox(height: 20),
            const Text("Success!",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Your order has been placed."),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {

                /// ✅ SAVE ORDER
                Orders.orderList.add({
                  "items": widget.product != null
                      ? [widget.product]
                      : List.from(CartPage.cartItems),
                  "total": calculateSubtotal(),
                  "date": DateTime.now().toString(),
                });

                /// ✅ CLEAR CART IF NEEDED
                if (widget.product == null) {
                  CartPage.cartItems.clear();
                }

                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Go to Home"),
            )
          ],
        ),
      ),
    );
  }
}
