// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';

// class ManageProductsPage extends StatefulWidget {
//   const ManageProductsPage({super.key});

//   @override
//   State<ManageProductsPage> createState() => _ManageProductsPageState();
// }

// class _ManageProductsPageState extends State<ManageProductsPage> {
//   final nameController = TextEditingController();
//   final priceController = TextEditingController();
//   final descriptionController = TextEditingController();

//   final picker = ImagePicker();

//   XFile? selectedImage;
//   Uint8List? imageBytes;
//   String? imageUrl;

//   bool loading = false;

//   String? selectedCategory;
//   String? selectedStock;
//   String? editId;

//   final List<String> stockList = ["In Stock", "Out of Stock"];

//   @override
//   void dispose() {
//     nameController.dispose();
//     priceController.dispose();
//     descriptionController.dispose();
//     super.dispose();
//   }

//   Future<void> pickImage() async {
//     final file = await picker.pickImage(source: ImageSource.gallery);

//     if (file != null) {
//       imageBytes = await file.readAsBytes();
//       selectedImage = file;
//       imageUrl = null;
//       setState(() {});
//     }
//   }

//   Future<String> uploadImage(XFile file) async {
//     final ref = FirebaseStorage.instance
//         .ref()
//         .child("products/${DateTime.now().millisecondsSinceEpoch}.jpg");

//     await ref.putData(await file.readAsBytes());

//     return await ref.getDownloadURL();
//   }

//   Future<void> saveProduct() async {
//     if (nameController.text.isEmpty ||
//         priceController.text.isEmpty ||
//         descriptionController.text.isEmpty ||
//         selectedCategory == null ||
//         selectedStock == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Fill all fields")),
//       );
//       return;
//     }

//     setState(() => loading = true);

//     try {
//       String finalImage = imageUrl ?? "";

//       if (selectedImage != null) {
//         finalImage = await uploadImage(selectedImage!);
//       }

//       final data = {
//         "name": nameController.text.trim(),
//         "price": double.parse(priceController.text.trim()),
//         "description": descriptionController.text.trim(),
//         "category": selectedCategory,
//         "stock": selectedStock,
//         "image": finalImage,
//         "published": true,
//         // "createdAt": FieldValue.serverTimestamp(),
//       };

//       if (editId == null) {
//         await FirebaseFirestore.instance.collection("product").add(data);
//       } else {
//         await FirebaseFirestore.instance
//             .collection("product")
//             .doc(editId)
//             .update(data);
//       }

//       clearFields();

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Saved Successfully")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("$e")),
//       );
//     }

//     setState(() => loading = false);
//   }

//   void clearFields() {
//     nameController.clear();
//     priceController.clear();
//     descriptionController.clear();

//     selectedCategory = null;
//     selectedStock = null;
//     selectedImage = null;
//     imageBytes = null;
//     imageUrl = null;
//     editId = null;

//     setState(() {});
//   }

//   void editProduct(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;

//     nameController.text = data["name"];
//     priceController.text = data["price"].toString();
//     descriptionController.text = data["description"];

//     selectedCategory = data["category"];
//     selectedStock = data["stock"];
//     imageUrl = data["image"];

//     editId = doc.id;

//     setState(() {});
//   }

//   Future<void> deleteProduct(String id) async {
//     await FirebaseFirestore.instance.collection("product").doc(id).delete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Manage Products"),
//         backgroundColor: Colors.green,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection("category").snapshots(),
//         builder: (context, catSnapshot) {
//           if (!catSnapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final categories = catSnapshot.data!.docs
//               .map((e) => (e.data() as Map<String, dynamic>)["name"].toString())
//               .toList();

//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 ElevatedButton(
//                   onPressed: pickImage,
//                   child: const Text("Select Image"),
//                 ),

//                 const SizedBox(height: 10),

//                 Container(
//                   height: 130,
//                   width: double.infinity,
//                   color: Colors.grey.shade200,
//                   child: imageBytes != null
//                       ? Image.memory(imageBytes!, fit: BoxFit.cover)
//                       : imageUrl != null && imageUrl!.isNotEmpty
//                           ? Image.network(imageUrl!, fit: BoxFit.cover)
//                           : const Icon(Icons.image),
//                 ),

//                 const SizedBox(height: 10),

//                 TextField(
//                   controller: nameController,
//                   decoration: const InputDecoration(labelText: "Name"),
//                 ),

//                 TextField(
//                   controller: priceController,
//                   decoration: const InputDecoration(labelText: "Price"),
//                   keyboardType: TextInputType.number,
//                 ),

//                 TextField(
//                   controller: descriptionController,
//                   decoration: const InputDecoration(labelText: "Description"),
//                 ),

//                 DropdownButtonFormField(
//                   value: selectedCategory,
//                   hint: const Text("Category"),
//                   items: categories
//                       .map((e) => DropdownMenuItem(
//                             value: e,
//                             child: Text(e),
//                           ))
//                       .toList(),
//                   onChanged: (v) => setState(() => selectedCategory = v),
//                 ),

//                 DropdownButtonFormField(
//                   value: selectedStock,
//                   hint: const Text("Stock"),
//                   items: stockList
//                       .map((e) => DropdownMenuItem(
//                             value: e,
//                             child: Text(e),
//                           ))
//                       .toList(),
//                   onChanged: (v) => setState(() => selectedStock = v),
//                 ),

//                 const SizedBox(height: 10),

//                 ElevatedButton(
//                   onPressed: loading ? null : saveProduct,
//                   child: Text(editId == null ? "Add Product" : "Update Product"),
//                 ),

//                 const SizedBox(height: 20),

//                 Expanded(
//                   child: StreamBuilder<QuerySnapshot>(
//                     stream: FirebaseFirestore.instance
//                       .collection("product")
//                         .orderBy("createdAt", descending: true)
//                         .snapshots(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(
//                             child: CircularProgressIndicator());
//                       }

//                       final docs = snapshot.data!.docs;

//                       return ListView.builder(
//                         itemCount: docs.length,
//                         itemBuilder: (context, index) {
//                           final doc = docs[index];
//                           final data = doc.data() as Map<String, dynamic>;

//                           return Card(
//                             child: ListTile(
//                               leading: data["image"] != null &&
//                                       data["image"].toString().startsWith("http")
//                                   ? Image.network(
//                                       data["image"],
//                                       width: 50,
//                                       fit: BoxFit.cover,
//                                     )
//                                   : null,
//                               title: Text(data["name"]),
//                               subtitle: Text("₹${data["price"]}"),
//                               trailing: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.edit),
//                                     onPressed: () => editProduct(doc),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.delete),
//                                     onPressed: () => deleteProduct(doc.id),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ManageProductsPage extends StatefulWidget {
  const ManageProductsPage({super.key});

  @override
  State<ManageProductsPage> createState() => _ManageProductsPageState();
}

class _ManageProductsPageState extends State<ManageProductsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  XFile? selectedFile;
  Uint8List? imageBytes;
  String? imageUrl;

  String? selectedCategory;
  String? selectedStock;
  String? editId;

  bool loading = false;

  final List<String> stockList = ["In Stock", "Out of Stock"];

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final bytes = await file.readAsBytes();

      setState(() {
        selectedFile = file;
        imageBytes = bytes;
        imageUrl = null;
      });
    }
  }

  Future<String> uploadImage(XFile file) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child("product_images/${DateTime.now().millisecondsSinceEpoch}.jpg");

    await ref.putData(await file.readAsBytes());

    return await ref.getDownloadURL();
  }

  Future<void> saveProduct() async {
    if (nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        selectedCategory == null ||
        selectedStock == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    try {
      setState(() => loading = true);

      String finalImage = imageUrl ?? "";

      if (selectedFile != null) {
        finalImage = await uploadImage(selectedFile!);
      }

      final data = {
        "name": nameController.text.trim(),
        "price": double.tryParse(priceController.text.trim()) ?? 0,
        "description": descriptionController.text.trim(),
        "category": selectedCategory,
        "stock": selectedStock,
        "image": finalImage,
        "published": true,
        "createdAt": Timestamp.now(),
      };

      if (editId == null) {
        await FirebaseFirestore.instance.collection("product").add(data);
      } else {
        await FirebaseFirestore.instance
            .collection("product")
            .doc(editId)
            .update(data);
      }

      clearFields();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  void clearFields() {
    nameController.clear();
    priceController.clear();
    descriptionController.clear();

    selectedCategory = null;
    selectedStock = null;
    selectedFile = null;
    imageBytes = null;
    imageUrl = null;
    editId = null;

    setState(() {});
  }

  void editProduct(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    nameController.text = data["name"] ?? "";
    priceController.text = (data["price"] ?? 0).toString();
    descriptionController.text = data["description"] ?? "";

    selectedCategory = data["category"];
    selectedStock = data["stock"];
    imageUrl = data["image"];
    imageBytes = null;
    selectedFile = null;

    editId = doc.id;

    setState(() {});
  }

  Future<void> deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance.collection("product").doc(id).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Deleted")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Delete error: $e")),
      );
    }
  }

  Widget buildImagePreview() {
    if (imageBytes != null) {
      return Image.memory(imageBytes!, fit: BoxFit.cover);
    }

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith("http")) {
        return Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
        );
      }
    }

    return const Icon(Icons.image, size: 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),
      appBar: AppBar(
        title: const Text("Manage Product"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("category").snapshots(),
        builder: (context, categorySnapshot) {
          if (!categorySnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = categorySnapshot.data!.docs
              .map((e) => (e.data() as Map<String, dynamic>)["name"].toString())
              .toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: loading ? null : pickImage,
                  child: const Text("Select Image"),
                ),

                const SizedBox(height: 10),

                Container(
                  height: 150,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: buildImagePreview(),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),

                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Price"),
                ),

                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),

                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  hint: const Text("Category"),
                  items: categories
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedCategory = v;
                    });
                  },
                ),

                DropdownButtonFormField<String>(
                  value: selectedStock,
                  hint: const Text("Stock"),
                  items: stockList
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      selectedStock = v;
                    });
                  },
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: loading ? null : saveProduct,
                  child: Text(editId == null ? "Add Product" : "Update Product"),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("product")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final docs = snapshot.data!.docs;

                      if (docs.isEmpty) {
                        return const Center(
                          child: Text("No products"),
                        );
                      }

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final doc = docs[index];
                          final data = doc.data() as Map<String, dynamic>;

                          return Card(
                            child: ListTile(
                              leading: data["image"] != null &&
                                      data["image"]
                                          .toString()
                                          .startsWith("http")
                                  ? Image.network(
                                      data["image"],
                                      width: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image),
                              title: Text(data["name"] ?? ""),
                              subtitle: Text("₹${data["price"]}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => editProduct(doc),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => deleteProduct(doc.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}