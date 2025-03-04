import 'package:ecommerce/Screens/Authentication.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data' as typed_data;
import 'dart:html' as html;

import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardPage(),
    // OrdersPage(),
    ProductsPage(),
    AdminAuthentication(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenu(
              onMenuSelected: _onItemTapped, selectedIndex: _selectedIndex),
          Expanded(
            child: _pages[_selectedIndex],
          )
        ],
      ),
    );
  }
}

class AdminAuthentication extends StatelessWidget {
  const AdminAuthentication({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(32.0),
                    width: constraints.maxWidth * 0.3,
                    height: constraints.maxHeight * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Login as Admin',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black38,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.black38,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.visibility_off),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Text(
                              'Sign In',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  final Function(int) onMenuSelected;
  final int selectedIndex;

  SideMenu({required this.onMenuSelected, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(height: 50),
          Text("Aldinar Trading",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 30,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          buildMenuItem(Icons.dashboard, 'Dashboard', 0),
          buildMenuItem(Icons.list, 'Products', 1),
          buildMenuItem(Icons.logout, 'Logout', 2),
        ],
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, int index) {
    bool isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (index != -1) {
            onMenuSelected(index);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.blueAccent, blurRadius: 10)]
                : [],
          ),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.black),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  final List<Map<String, String>> orders = [
    {
      'id': '1KNGZ6BvFtHHfApJ8jY9',
      'date': '2022-06-09 00:01:29',
      'status': 'Completed',
      'price': '250 \$',
      'title': 'High-Value Orders',
    },
    {
      'id': 'Oelmuk7zzvRldDY9BXUx',
      'date': '2022-06-08 23:15:00',
      'status': 'Packaging',
      'price': '770 \$',
      'title': 'Processing Orders',
    },
    {
      'id': 'Rxzn7K0ZQhlx8tpuwXRF',
      'date': '2022-06-29 12:33:07',
      'status': 'Packaging',
      'price': '90 \$',
      'title': 'Urgent Shipments',
    },
    {
      'id': 'S7vrFIXsxFTdzPEwY4iK',
      'date': '2022-06-29 11:58:45',
      'status': 'Packaging',
      'price': '460 \$',
      'title': 'Recently Delivered',
    },
    {
      'id': 'cVfnRn4M4u15WJacQ6CB',
      'date': '2022-06-08 23:15:19',
      'status': 'Delivered',
      'price': '180 \$',
      'title': 'Recently Delivered',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildOrderCards(),
            SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                double screenWidth = constraints.maxWidth;
                double fontSize =
                    screenWidth * 0.025; // Scale font size based on width
                double paddingSize = screenWidth * 0.01; // Dynamic padding

                return Padding(
                  padding: EdgeInsets.all(paddingSize),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DataTable(
                        columnSpacing: screenWidth * 0.03,
                        dividerThickness: 2,
                        columns: [
                          DataColumn(
                            label: Text('Order Id',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize)),
                          ),
                          DataColumn(
                            label: Text('Order Date',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize)),
                          ),
                          DataColumn(
                            label: Text('Item Title',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize)),
                          ),
                          DataColumn(
                            label: Text('Status',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize)),
                          ),
                          DataColumn(
                            label: Text('Total Price',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize)),
                          ),
                          DataColumn(
                            label: Text('Action',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: fontSize)),
                          ),
                        ],
                        rows: orders.map((order) {
                          return DataRow(
                            cells: [
                              DataCell(Text(order['id']!,
                                  style: TextStyle(
                                      fontSize: fontSize * 0.40,
                                      fontWeight: FontWeight.w500))),
                              DataCell(Text(order['date']!,
                                  style: TextStyle(
                                      fontSize: fontSize * 0.40,
                                      fontWeight: FontWeight.w500))),
                              DataCell(Text(order['title']!,
                                  style: TextStyle(
                                      fontSize: fontSize * 0.40,
                                      fontWeight: FontWeight.w500))),
                              DataCell(Text(order['status']!,
                                  style: TextStyle(
                                      fontSize: fontSize * 0.40,
                                      fontWeight: FontWeight.w500,
                                      color:
                                          getStatusColor(order['status']!)))),
                              DataCell(Text(order['price']!,
                                  style: TextStyle(
                                      fontSize: fontSize * 0.40,
                                      fontWeight: FontWeight.w500))),
                              DataCell(
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    print(
                                        "Selected: $value"); // Handle selection
                                  },
                                  itemBuilder: (BuildContext context) => [
                                    PopupMenuItem(
                                        value: 'view',
                                        child: Text('View Details')),
                                    PopupMenuItem(
                                        value: 'edit',
                                        child: Text('Edit Order')),
                                    PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete Order')),
                                  ],
                                  child: TextButton(
                                    onPressed: null,
                                    child: Text('View',
                                        style: TextStyle(
                                            fontSize: fontSize * 0.40,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.greenAccent;
      case 'Packaging':
        return Colors.orange;
      case 'Delivered':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  Widget _buildOrderCards() {
    List<Map<String, dynamic>> orderData = [
      {'title': 'All Orders', 'count': 5, 'color': Colors.teal},
      {'title': 'Packaging', 'count': 3, 'color': Colors.yellow},
      {'title': 'Delivered', 'count': 1, 'color': Colors.blue},
      {'title': 'Completed', 'count': 1, 'color': Colors.green},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemCount: orderData.length,
      itemBuilder: (context, index) {
        return Card(
          color: Colors.blueGrey[800],
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article, color: orderData[index]['color']),
                SizedBox(height: 10),
                Text(
                  orderData[index]['title'],
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  orderData[index]['count'].toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// class OrdersPage extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return
//   }

// }

class Product {
  final Uint8List image;
  final String title;
  final String price;

  Product({required this.image, required this.title, required this.price});
}

class ProductsPage extends StatefulWidget {
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Map<String, dynamic>> products = [];

  Future<void> pickImage() async {
    try {
      if (kIsWeb) {
        final html.FileUploadInputElement uploadInput =
            html.FileUploadInputElement();
        uploadInput.accept = 'image/*';
        uploadInput.click();

        uploadInput.onChange.listen((event) {
          final files = uploadInput.files;
          if (files!.isNotEmpty) {
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 1500
        ? 5
        : screenWidth > 1000
            ? 3
            : 2;

    return Padding(
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
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}
