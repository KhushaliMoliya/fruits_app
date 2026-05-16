 
import 'package:flutter/material.dart';

class DeliveryPersonPage extends StatefulWidget {
  const DeliveryPersonPage({super.key});

  @override
  State<DeliveryPersonPage> createState() => _DeliveryPersonPageState();
}

class _DeliveryPersonPageState extends State<DeliveryPersonPage> {

  List<Map<String, dynamic>> deliveryPersons = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int? editIndex;

  void addOrUpdatePerson() {

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        mobileController.text.isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all fields")),
      );
      return;
    }

    if (editIndex == null) {
      deliveryPersons.add({
        "name": nameController.text,
        "email": emailController.text,
        "mobile": mobileController.text,
        "password": passwordController.text,
      });
    } else {
      deliveryPersons[editIndex!] = {
        "name": nameController.text,
        "email": emailController.text,
        "mobile": mobileController.text,
        "password": passwordController.text,
      };
      editIndex = null;
    }

    clearFields();
    setState(() {});
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    mobileController.clear();
    passwordController.clear();
  }

  void editPerson(int index) {
    final person = deliveryPersons[index];

    nameController.text = person["name"];
    emailController.text = person["email"];
    mobileController.text = person["mobile"];
    passwordController.text = person["password"];

    editIndex = index;
    setState(() {});
  }

  void deletePerson(int index) {
    setState(() {
      deliveryPersons.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),

      appBar: AppBar(
        title: const Text("Delivery Persons", style: TextStyle(color: Colors.white)),
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
              "Add Delivery Person",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: nameController,
              decoration: inputDecoration("Name"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: emailController,
              decoration: inputDecoration("Email"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              decoration: inputDecoration("Mobile Number"),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: inputDecoration("Password"),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: addOrUpdatePerson,
                child: const Text("Add Person",style: TextStyle(color: Colors.white)), // ✅ FIXED TEXT
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: deliveryPersons.isEmpty
                  ? const Center(child: Text("No Delivery Persons Added"))
                  : ListView.builder(
                      itemCount: deliveryPersons.length,
                      itemBuilder: (context, index) {

                        final person = deliveryPersons[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.only(bottom: 10),

                          child: ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),

                            title: Text(person["name"]),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(person["email"]),
                                Text(person["mobile"]),
                              ],
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => editPerson(index),
                                ),

                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => deletePerson(index),
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
    );
  }

  InputDecoration inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

