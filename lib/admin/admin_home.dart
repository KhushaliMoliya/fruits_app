import 'package:flutter/material.dart';
import 'package:fruits_app/admin/manageproduct.dart';
import 'package:fruits_app/admin/managecategiry.dart';
import 'package:fruits_app/admin/manageuser.dart';
import 'package:fruits_app/admin/deliveryperson.dart';
import 'package:fruits_app/admin/manageorder.dart';
import 'package:fruits_app/screens/LoginScreen.dart'; // ✅ ADD THIS

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),

      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      // ================= DRAWER =================
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CircleAvatar(radius: 35),
                  SizedBox(height: 10),
                  Text(
                    "Admin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "admin@gmail.com",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            drawerItem(Icons.dashboard, "Dashboard", () {
              Navigator.pop(context);
            }),

            drawerItem(Icons.people, "Manage Users", () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ManageUsersPage()));
            }),

            drawerItem(Icons.category, "Manage Categories", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ManageCategoryPage()));
            }),

            drawerItem(Icons.shopping_bag, "Manage Products", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ManageProductsPage()));
            }),

            drawerItem(Icons.shopping_cart, "Manage Orders", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ManageOrdersPage()));
            }),

            drawerItem(Icons.delivery_dining, "Delivery Person", () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const DeliveryPersonPage()));
            }),

            const Spacer(),

            // 🔴 LOGOUT (RED COLOR + REDIRECT)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false, // ❌ remove all previous routes
                );
              },
            ),
          ],
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Admin ",
              style:
                  TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: summaryCard(
                      "Users", "120", Icons.people, Colors.blue),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: summaryCard("Products", "80",
                      Icons.shopping_bag, Colors.orange),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: summaryCard("Orders", "45",
                      Icons.shopping_cart, Colors.green),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: summaryCard("Delivery", "10",
                      Icons.delivery_dining, Colors.purple),
                ),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Quick Actions",
              style:
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            Column(
              children: [
                actionTile(
                  context,
                  "Manage Users",
                  Icons.people,
                  Colors.blue,
                  const ManageUsersPage(),
                ),
                actionTile(
                  context,
                  "Manage Categories",
                  Icons.category,
                  Colors.purple,
                  const ManageCategoryPage(),
                ),
                actionTile(
                  context,
                  "Manage Products",
                  Icons.shopping_bag,
                  Colors.orange,
                  const ManageProductsPage(),
                ),
                actionTile(
                  context,
                  "Manage Orders",
                  Icons.receipt_long,
                  Colors.green,
                  const ManageOrdersPage(),
                ),
                actionTile(
                  context,
                  "Delivery Person",
                  Icons.delivery_dining,
                  Colors.deepPurple,
                  const DeliveryPersonPage(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerItem(
      IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: const TextStyle(color: Colors.black)),
      onTap: onTap,
    );
  }

  Widget summaryCard(String title, String count, IconData icon,
      Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget actionTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}