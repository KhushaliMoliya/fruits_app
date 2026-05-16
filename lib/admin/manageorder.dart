import 'package:flutter/material.dart';

class ManageOrdersPage extends StatefulWidget {
  const ManageOrdersPage({super.key});

  @override
  State<ManageOrdersPage> createState() => _ManageOrdersPageState();
}

class _ManageOrdersPageState extends State<ManageOrdersPage> {

  // 🔥 Order List (Dynamic Data)
  List<Map<String, dynamic>> orders = List.generate(6, (index) {
    return {
      "orderId": "#ORD00$index",
      "customerName": "Customer $index",
      "totalPrice": "₹${(index + 1) * 120}",
      "status": index % 3 == 0
          ? "Pending"
          : index % 3 == 1
              ? "Delivered"
              : "Cancelled",
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Manage Orders",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      backgroundColor: const Color(0xfff4f6fa),

      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return orderCard(
            index: index,
            orderId: order["orderId"],
            customerName: order["customerName"],
            totalPrice: order["totalPrice"],
            status: order["status"],
          );
        },
      ),
    );
  }

  // ================= ORDER CARD =================
  Widget orderCard({
    required int index,
    required String orderId,
    required String customerName,
    required String totalPrice,
    required String status,
  }) {
    Color statusColor;

    if (status == "Pending") {
      statusColor = Colors.orange;
    } else if (status == "Delivered") {
      statusColor = Colors.green;
    } else {
      statusColor = Colors.red;
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔹 Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderId,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "Customer: $customerName",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 5),

            Text(
              "Total: $totalPrice",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
            ),

            const SizedBox(height: 10),

            // 🔥 WORKING BUTTONS
            if (status == "Pending")
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        setState(() {
                          orders[index]["status"] = "Delivered";
                        });
                      },
                      child: const Text("Accept"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          orders[index]["status"] = "Cancelled";
                        });
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}