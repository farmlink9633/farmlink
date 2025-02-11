import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> productData; // Pass the product data to the screen

  ProductDetailScreen({required this.productData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: productData['image_url'] != null
                    ? Image.network(
                        'http://example.com${productData['image_url']}', // Replace with your base URL
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.image,
                        size: 150,
                        color: Colors.grey,
                      ),
              ),
              SizedBox(height: 20),

              // Product Name
              Text(
                productData['productname'] ?? 'No product name',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 10),

              // Description
              Text(
                'Description:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5),
              Text(
                productData['description'] ?? 'No description available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 15),

              // Product Date
              Text(
                'Date: ${productData['date'] ?? 'No date available'}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 15),

              // Farmer Contact Info
              Text(
                'Contact: ${productData['contact'] ?? 'No contact available'}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),

              // Farmer ID (if needed for reference)
              Text(
                'Farmer ID: ${productData['farmer'] ?? 'Not available'}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 30),

              // Call button (optional, if you want to add an action for the contact number)
              ElevatedButton.icon(
                onPressed: () {
                  // Action when the button is pressed (e.g., make a call)
                },
                icon: Icon(Icons.call),
                label: Text('Call Farmer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
