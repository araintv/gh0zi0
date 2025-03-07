import 'package:ecommerce/Services/snackBar.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final Uint8List image;
  final String title;
  final String price;
  final String category;

  Product(
      {required this.image,
      required this.title,
      required this.price,
      required this.category});
}

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> products = [];
  List<String> categories = ["Electronics", "Clothing", "Books", "Furniture"];
  final String apiUrl = "https://api.cloudinary.com/v1_1/dxptbyyvp/upload";

  bool isUploading = false;

  Future<void> pickImage() async {
    try {
      if (kIsWeb) {
        final html.FileUploadInputElement uploadInput =
            html.FileUploadInputElement();
        uploadInput.accept = 'image/*';
        uploadInput.click();

        uploadInput.onChange.listen((event) {
          final files = uploadInput.files;
          if (files != null && files.isNotEmpty) {
            final reader = html.FileReader();
            reader.readAsArrayBuffer(files[0]);

            reader.onLoadEnd.listen((event) {
              _showAddProductDialog(reader.result as Uint8List);
            });
          }
        });
      } else {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          withData: true,
        );

        if (result != null && result.files.first.bytes != null) {
          _showAddProductDialog(result.files.first.bytes!);
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _showAddProductDialog(Uint8List image) {
    TextEditingController titleController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    String selectedCategory = categories.first;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Product"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.memory(
                image,
                height: 200,
                width: 200,
                gaplessPlayback: true,
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  products.add({
                    "image": image,
                    "title": titleController.text,
                    "price": priceController.text,
                    "category": selectedCategory,
                  });
                });
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields['upload_preset'] = 'ecommerce'
        ..files.add(http.MultipartFile.fromBytes('file', imageBytes,
            filename: 'upload.jpg'));

      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());
        return jsonResponse['url'];
      } else {
        CustomSnackBar(
            context, Text("Failed to upload image: ${response.statusCode}"));
        // print("Failed to upload image: ${response.statusCode}");
        return "";
      }
    } catch (e) {
      CustomSnackBar(context, Text("Error uploading image: $e"));

      // print("Error uploading image: $e");
      return "";
    }
  }

  Future<void> uploadProducts() async {
    setState(() {
      isUploading = true;
    });
    for (var product in products) {
      String imageUrl = await uploadImage(product["image"]);
      if (imageUrl.isNotEmpty) {
        await FirebaseFirestore.instance.collection("products").add({
          "productImage": imageUrl,
          "productName": product["title"],
          "productCategory": product["category"],
          "price": product["price"],
        });
      }
    }
    setState(() {
      isUploading = false;
    });
    // print("All products uploaded successfully!");
    CustomSnackBar(context, Text("All products uploaded successfully!"));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1500
        ? 5
        : screenWidth > 1000
            ? 3
            : 2;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          uploadProducts();
        },
        child: isUploading
            ? CircularProgressIndicator()
            : Icon(
                Icons.upload,
                color: Colors.black,
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: products.length + 1,
          itemBuilder: (context, index) {
            if (index == products.length) {
              return GestureDetector(
                onTap: pickImage,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Icon(Icons.add, size: 50, color: Colors.blue),
                  ),
                ),
              );
            } else {
              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          products[index]["image"],
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Title: ${products[index]["title"]}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.010,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Price: \$${products[index]["price"]}",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: screenWidth * 0.010,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Category: ${products[index]["category"]}",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: screenWidth * 0.010,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
