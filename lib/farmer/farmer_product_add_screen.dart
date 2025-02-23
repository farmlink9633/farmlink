import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProductAddScreen extends StatefulWidget {
  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends State<ProductAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  File? _image;
  final _picker = ImagePicker();
  
  bool _isLoading = false; // Track loading state

  // Pick image from gallery or camera
  Future<void> _pickImage() async {
    final pickedFile =await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Make a multipart request to add the product
  Future<void> _addProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Start loading
      });

      final uri = Uri.parse('$baseurl/productadd/');
      var request = http.MultipartRequest('POST', uri);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Add text fields to request
      request.fields['productname'] = _productNameController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['contact'] = _contactController.text;
      request.fields['date'] = _dateController.text;
      request.fields['farmerid'] = prefs.getString('id')??'';

      // Add image to request
      if (_image != null) {
        final imageFile = await http.MultipartFile.fromPath(
          'image',
          _image!.path,
        );
        request.files.add(imageFile);
      }

      // Send the request
      final response = await request.send();
      setState(() {
        _isLoading = false; // Stop loading after response
      });

      // Display success or failure
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: const Color.fromARGB(255, 60, 111, 61),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add product!'),
          backgroundColor: const Color.fromARGB(255, 239, 88, 78),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromARGB(236, 215, 228, 212),
      appBar: AppBar(
        title: Text(
          'Add Product',
            style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 116, 140, 107),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                _buildTextFormField(
                  
                  controller: _productNameController,
                  label: 'Product Name',
                  icon: Icons.production_quantity_limits,
                  validator: (value) => value!.isEmpty ? 'Please enter the product name' : null,
                ),

                // Description
                _buildTextFormField(
                  controller: _descriptionController,
                  label: 'Description',
                  icon: Icons.description,
                  maxLines: 3,
                  validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                ),

                // Image Picker
                SizedBox(height: 20),
                GestureDetector(
                  onTap: _pickImage,
                  child: _image == null
                      ? Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 150, 165, 148),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 8, spreadRadius: 2)
                            ],
                          ),
                          child: Icon(Icons.add_a_photo, color: Colors.black54),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        ),
                ),

                // Date
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _dateController,
                  label: 'Date',
                  icon: Icons.calendar_today,
                  validator: (value) => value!.isEmpty ? 'Please enter the date' : null,
                ),

                // Contact
                SizedBox(height: 20),
                _buildTextFormField(
                  controller: _contactController,
                  label: 'Contact',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isEmpty ? 'Please enter the contact number' : null,
                ),

                SizedBox(height: 30),

                // Submit Button
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _addProduct,
                          child: Text(
                            'Add Product',
                          style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.white,
                            ),
                            ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 116, 140, 107),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build text form fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int? maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color.fromARGB(255, 89, 120, 90)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: const Color.fromARGB(255, 73, 110, 74) ),
          ),
        ),
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }
}
