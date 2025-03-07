import 'package:flutter/material.dart';

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
