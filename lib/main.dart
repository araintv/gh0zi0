import 'package:ecommerce/Screens/mainScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShopkaHomePage(),
    );
  }
}

class ShopkaHomePage extends StatefulWidget {
  @override
  _ShopkaHomePageState createState() => _ShopkaHomePageState();
}

class _ShopkaHomePageState extends State<ShopkaHomePage> {
  String selectedCategory = "All Categories";
  List<Map<String, dynamic>> cart = [];
  String searchQuery = "";

  final Map<String, List<Map<String, String>>> categoryData = {
    "All Categories": [
      {
        "name": "Men\'s Red T Shirt",
        "price": "12.99",
        "image":
            "https://condomshop.pk/cdn/shop/products/plain-red-tshirt_grande.jpg?v=1449214693"
      },
      {
        "name": "Men\'s Red T Shirt",
        "price": "8.99",
        "image":
            "https://www.militarykit.com/cdn/shop/products/kids-olive-green-cotton-t-shirt_grande.jpg?v=1662728300"
      },
      {
        "name": "Men\'s Black T Shirt",
        "price": "15.99",
        "image":
            "https://www.wyze.com/cdn/shop/products/ShirtBlack2.png?v=1644350195&width=1946"
      },
    ],
    "Electronics": [
      {
        "name": "Laptop",
        "price": "520.99",
        "image":
            "https://i5.walmartimages.com/seo/HP-15-6-Laptop-Intel-Core-i5-1135G7-2-4GHz-Intel-Iris-Xe-Graphics-8GB-Ram-512GB-SSD-Windows-11-Natural-Silver-15-dy2152wm_1ba66cba-c16d-45b1-b051-536ddbc0ea94.f9c34f840f118549ad2fdbdfd931f3ae.jpeg"
      },
      {
        "name": "Smartphone",
        "price": "205.99",
        "image":
            "https://mymart.pk/cdn/shop/files/A3xblack_420x.png?v=1716551082"
      },
      {
        "name": "Tablet",
        "price": "345.99",
        "image":
            "https://http2.mlstatic.com/D_NQ_NP_716579-MLU75571665891_042024-O.webp"
      },
    ],
    "Computers": [
      {
        "name": "Gaming PC",
        "price": "12.99",
        "image": "https://via.placeholder.com/150"
      },
      {
        "name": "Monitor",
        "price": "12.99",
        "image": "https://via.placeholder.com/150"
      },
      {
        "name": "Keyboard",
        "price": "12.99",
        "image": "https://via.placeholder.com/150"
      },
    ],
    "Home & Garden": [
      {
        "name": "Sofa",
        "price": "12.99",
        "image": "https://via.placeholder.com/150"
      },
      {
        "name": "Lamp",
        "price": "12.99",
        "image": "https://via.placeholder.com/150"
      },
      {
        "name": "Table",
        "price": "12.99",
        "image": "https://via.placeholder.com/150"
      },
    ],
  };

  void addToCart(Map<String, String> item) {
    setState(() {
      int index = cart.indexWhere((element) => element["name"] == item["name"]);
      if (index != -1) {
        cart[index]["quantity"]++;
      } else {
        cart.add({
          "name": item["name"],
          "image": item["image"],
          "quantity": 1,
          "price": double.tryParse(item["price"]!) ?? 0.0,
        });
      }
    });
  }

  void navigateToCartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartScreen(cart: cart, updateCart: updateCart)),
    );
  }

  void navigateToSignIn() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void updateCart() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    List<Map<String, String>> filteredItems = categoryData[selectedCategory]!
        .where((item) =>
            item["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text("Aldinar Trading",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            SizedBox(width: 20),
            Expanded(
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search Your Product',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[200],
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            SizedBox(width: 20),
            TextButton(
                onPressed: () {
                  navigateToSignIn();
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                )),
            SizedBox(width: 20),
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: width * 0.025,
                  ),
                  onPressed: navigateToCartScreen,
                ),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 5,
                    top: 5,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: Text(
                          cart.length.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: width * 0.0100,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
      body: Row(
        children: [
          Container(
            width: 230,
            color: Colors.grey[100],
            child: ListView(
              children: categoryData.keys.map((category) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                        searchQuery = "";
                      });
                    },
                    child: Container(
                      width: 30,
                      decoration: BoxDecoration(
                        color: selectedCategory == category
                            ? Colors.blue
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          if (selectedCategory == category)
                            BoxShadow(color: Colors.blueAccent, blurRadius: 10)
                        ],
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Text(
                        category,
                        style: TextStyle(
                            color: selectedCategory == category
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: filteredItems.map((item) {
                  return Card(
                    color: Colors.white,
                    elevation: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Image.network(item["image"]!,
                                fit: BoxFit.cover)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(item["name"]!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Price: \$${item["price"]}",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    ElevatedButton(
                                        onPressed: () => addToCart(item),
                                        style: ButtonStyle(
                                            shape: WidgetStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    side: BorderSide(
                                                        color: Colors.black)))),
                                        child: Text(
                                          "Add to Cart",
                                          style: TextStyle(color: Colors.black),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final VoidCallback updateCart;

  CartScreen({required this.cart, required this.updateCart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void updateQuantity(int index, int change) {
    setState(() {
      if (widget.cart[index]["quantity"] + change > 0) {
        widget.cart[index]["quantity"] += change;
      } else {
        widget.cart.removeAt(index);
      }
      widget.updateCart();
    });
  }

  double calculateTotalPrice() {
    return widget.cart
        .fold(0, (sum, item) => sum + (item["price"] * item["quantity"]));
  }

  void placeOrder() {
    if (widget.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your cart is empty! Add items to proceed.")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Order"),
        content: Text(
            "Your total is \$${calculateTotalPrice().toStringAsFixed(2)}.\nProceed to checkout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Order Placed Successfully! 🎉")),
              );
              setState(() {
                widget.cart.clear();
              });
              widget.updateCart();
            },
            child: Text("Place Order"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Column(
        children: [
          Expanded(
            child: widget.cart.isEmpty
                ? Center(child: Text("Your cart is empty!"))
                : GridView.count(
                    crossAxisCount: 5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(widget.cart.length, (index) {
                      var item = widget.cart[index];
                      double totalPrice = item["price"] * item["quantity"];

                      return Card(
                        color: Colors.white,
                        elevation: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(item["image"],
                                height: 250, fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(item["name"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text("Price: \$${item["price"]}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove,
                                              color: Colors.black,
                                            ),
                                            onPressed: () =>
                                                updateQuantity(index, -1),
                                          ),
                                          Text(item["quantity"].toString(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black)),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add,
                                              color: Colors.black,
                                            ),
                                            onPressed: () =>
                                                updateQuantity(index, 1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                  ),
          ),
          if (widget.cart.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      "Total Amount: \$${calculateTotalPrice().toStringAsFixed(2)}",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: Colors.orange,
                                )))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Place Order Now!",
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                              fontSize: 25)),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
