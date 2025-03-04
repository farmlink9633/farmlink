import 'dart:convert';
import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        SnackBar(
          content: Text(
            'Product updated successfully!',
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to update product!',
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }
  }

  // Function to delete product
  Future<void> _deleteProduct() async {
    // Show confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Product',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this product?',
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
          actions: [
            // No Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Return false
              },
              child: Text(
                'No',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
            // Yes Button
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Return true
              },
              child: Text(
                'Yes',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If user confirms deletion
    if (confirmDelete == true) {
      final url = Uri.parse('$baseurl/UpdateProductView/?ProductId=${widget.productData['id']}');

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        Navigator.pop(context); // Close the product detail screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Product deleted successfully!',
              style: GoogleFonts.poppins(),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete product!',
              style: GoogleFonts.poppins(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        title: Text(
          'Product Details',
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
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
                      decoration: InputDecoration(
                        labelText: 'Product Name',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                      style: GoogleFonts.poppins(),
                    )
                  : Text(
                      widget.productData['productname'] ?? 'No product name',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 68, 97, 69),
                      ),
                    ),
              SizedBox(height: 10),

              // Editable Description
              Text(
                'Description:',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(221, 74, 106, 67),
                ),
              ),
              SizedBox(height: 5),
              _isEditing
                  ? TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                      style: GoogleFonts.poppins(),
                      maxLines: 3,
                    )
                  : Text(
                      widget.productData['description'] ?? 'No description available',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
              SizedBox(height: 15),

              // Product Date
              Text(
                'Date: ${widget.productData['date'] ?? 'No date available'}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 37, 104, 39),
                ),
              ),
              SizedBox(height: 15),

              // Farmer Contact Info
              Text(
                'Contact: ${widget.productData['contact'] ?? 'No contact available'}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 58, 63, 59),
                ),
              ),
              SizedBox(height: 20),

              // Farmer ID
              Text(
                'Farmer ID: ${widget.productData['farmer'] ?? 'Not available'}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
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
                    label: Text(
                      'Call Farmer',
                      style: GoogleFonts.poppins(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 117, 162, 119),
                      foregroundColor: Colors.white, // Text and icon color
                    ),
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
                      label: Text(
                        'Edit',
                        style: GoogleFonts.poppins(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 129, 173, 138),
                        foregroundColor: Colors.white, // Text and icon color
                      ),
                    ),

                  // Save Button
                  if (_isEditing)
                    ElevatedButton.icon(
                      onPressed: _updateProduct,
                      icon: Icon(Icons.save),
                      label: Text(
                        'Save',
                        style: GoogleFonts.poppins(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 158, 182, 121),
                        foregroundColor: Colors.white, // Text and icon color
                      ),
                    ),

                  // Delete Button
                  ElevatedButton.icon(
                    onPressed: _deleteProduct,
                    icon: Icon(Icons.delete),
                    label: Text(
                      'Delete',
                      style: GoogleFonts.poppins(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 208, 139, 134),
                      foregroundColor: Colors.white, // Text and icon color
                    ),
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