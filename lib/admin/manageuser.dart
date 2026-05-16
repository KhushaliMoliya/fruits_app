
import 'package:flutter/material.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {

  List<Map<String, String>> users = [
    {
      "name": "Kushal Visani",
      "email": "kushal@gmail.com",
      "role": "User"
    },
    {
      "name": "Bansi Moliya",
      "email": "bansi@gmail.com",
      "role": "User"
    },
    {
      "name": "Khushi Moliya",
      "email": "kmoliya@gmail.com",
      "role": "Admin"
    },
  ];

  void deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
  }

  void showUserDetails(Map<String, String> user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("User Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Name: ${user["name"]}"),
              Text("Email: ${user["email"]}"),
              Text("Role: ${user["role"]}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),

      appBar: AppBar(
        title: const Text("Manage Users", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "All Users",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {

                  final user = users[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),

                    child: ListTile(

                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        child: const Icon(Icons.person, color: Colors.blue),
                      ),

                      title: Text(user["name"]!),

                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user["email"]!),
                          Text(
                            user["role"]!,
                            style: TextStyle(
                              color: user["role"] == "Admin"
                                  ? Colors.red
                                  : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              deleteUser(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// ADD USER BUTTON (UI ONLY)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          // UI only
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
