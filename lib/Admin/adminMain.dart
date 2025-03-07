import 'package:ecommerce/Admin/Screens/authAccount.dart';
import 'package:ecommerce/Admin/Screens/dashBoard.dart';
import 'package:ecommerce/Admin/Screens/proDucts.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2;
  bool _isLoggedIn = false; // Track login status

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
      _selectedIndex = 0; // Redirect to Dashboard after login
    });
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Sign Out"),
          content: Text("Are you sure you want to sign out?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isLoggedIn = false;
                  _selectedIndex = 2; // Redirect to login page
                });
              },
              child: Text("Sign Out"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideMenu(
            onMenuSelected: _onItemTapped,
            selectedIndex: _selectedIndex,
            isLoggedIn: _isLoggedIn,
            onLogout: _handleLogout,
          ),
          Expanded(
            child: _selectedIndex == 2
                ? AdminAuthentication(onLoginSuccess: _handleLoginSuccess)
                : _selectedIndex == 0
                    ? DashboardPage()
                    : ProductsPage(),
          ),
        ],
      ),
    );
  }
}

class SideMenu extends StatelessWidget {
  final Function(int) onMenuSelected;
  final int selectedIndex;
  final bool isLoggedIn;
  final VoidCallback onLogout;

  SideMenu({
    required this.onMenuSelected,
    required this.selectedIndex,
    required this.isLoggedIn,
    required this.onLogout,
  });

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
          if (isLoggedIn) buildMenuItem(Icons.dashboard, 'Dashboard', 0),
          if (isLoggedIn) buildMenuItem(Icons.list, 'Products', 1),
          buildMenuItem(isLoggedIn ? Icons.logout : Icons.login,
              isLoggedIn ? 'Sign Out' : 'Login', 2,
              isLogout: isLoggedIn),
        ],
      ),
    );
  }

  Widget buildMenuItem(IconData icon, String title, int index,
      {bool isLogout = false}) {
    bool isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (isLogout) {
            onLogout(); // Handle logout
          } else {
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
