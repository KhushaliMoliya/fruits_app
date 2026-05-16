import 'package:flutter/material.dart';
import 'package:fruits_app/screens/orders.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
        backgroundColor: Colors.green,
      ),

      body: Orders.orderList.isEmpty
          ? const Center(
              child: Text(
                "No Orders Yet 🛒",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: Orders.orderList.length,
              itemBuilder: (context, index) {

                final order = Orders.orderList[index];

                /// ✅ Safe items list
                final List items = order["items"] ?? [];

                /// ✅ Safe date
                String date = order["date"] ?? "";
                if (date.length > 16) {
                  date = date.substring(0, 16);
                }

                /// ✅ Safe total
                double total =
                    double.tryParse(order["total"].toString()) ?? 0;

                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(10),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// DATE
                        Text(
                          "Order Date: $date",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// ITEMS
                        Column(
                          children: items.map<Widget>((item) {

                            double price =
                                double.tryParse(item["price"].toString()) ?? 0;

                            return ListTile(
                              contentPadding: EdgeInsets.zero,

                              leading: Image.asset(
                                item["image"],
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              ),

                              title: Text(item["name"] ?? ""),

                              trailing: Text(
                                "₹${price.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );

                          }).toList(),
                        ),

                        const Divider(),

                        /// TOTAL
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${total.toStringAsFixed(0)}",
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )

                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}