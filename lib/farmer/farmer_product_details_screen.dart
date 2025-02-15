import 'dart:convert';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> productData;

  ProductDetailScreen({required this.productData});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  TextEditingController _productNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _productNameController.text = widget.productData['productname'] ?? '';
    _descriptionController.text = widget.productData['description'] ?? '';
  }

  // Function to make a phone call
  void _makePhoneCall(String phoneNumber) async {
    final Uri phoneUri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print('Could not launch $phoneUri');
    }
  }

  // Function to update product details
  Future<void> _updateProduct() async {
    final url = Uri.parse('$baseurl/UpdateProductView/?productId=${widget.productData['id']}');

    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "productname": _productNameController.text,
        "description": _descriptionController.text,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        widget.productData['productname'] = _productNameController.text;
        widget.productData['description'] = _descriptionController.text;
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product!')),
      );
    }
  }

  // Function to delete product
  Future<void> _deleteProduct() async {
    final url = Uri.parse('$baseurl/UpdateProductView/?ProductId=${widget.productData['id']}');

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product!')),
      );
    }
  }

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
                child: widget.productData['image_url'] != null
                    ? Image.network(
                        '$baseurl${widget.productData['image_url']}',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.image, size: 150, color: Colors.grey),
              ),
              SizedBox(height: 20),

              // Editable Product Name
              _isEditing
                  ? TextField(
                      controller: _productNameController,
                      decoration: InputDecoration(labelText: 'Product Name'),
                    )
                  : Text(
                      widget.productData['productname'] ?? 'No product name',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
              SizedBox(height: 10),

              // Editable Description
              Text('Description:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              SizedBox(height: 5),
              _isEditing
                  ? TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                    )
                  : Text(
                      widget.productData['description'] ?? 'No description available',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
              SizedBox(height: 15),

              // Product Date
              Text(
                'Date: ${widget.productData['date'] ?? 'No date available'}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.green),
              ),
              SizedBox(height: 15),

              // Farmer Contact Info
              Text(
                'Contact: ${widget.productData['contact'] ?? 'No contact available'}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue),
              ),
              SizedBox(height: 20),

              // Farmer ID
              Text(
                'Farmer ID: ${widget.productData['farmer'] ?? 'Not available'}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
              ),
              SizedBox(height: 30),

              // Buttons: Call, Edit, Delete, Save
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Call Button
                  ElevatedButton.icon(
                    onPressed: () {
                      String? phoneNumber = widget.productData['contact'];
                      if (phoneNumber != null && phoneNumber.isNotEmpty) {
                        _makePhoneCall(phoneNumber);
                      } else {
                        print('No contact number available');
                      }
                    },
                    icon: Icon(Icons.call),
                    label: Text('Call Farmer'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),

                  // Edit Button
                  if (!_isEditing)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isEditing = true;
                        });
                      },
                      icon: Icon(Icons.edit),
                      label: Text('Edit'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    ),

                  // Save Button
                  if (_isEditing)
                    ElevatedButton.icon(
                      onPressed: _updateProduct,
                      icon: Icon(Icons.save),
                      label: Text('Save'),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    ),

                  // Delete Button
                  ElevatedButton.icon(
                    onPressed: _deleteProduct,
                    icon: Icon(Icons.delete),
                    label: Text('Delete'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
