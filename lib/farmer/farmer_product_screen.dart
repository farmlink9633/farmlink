import 'package:farmlink/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FarmersProductScreen extends StatefulWidget {
  @override
  _FarmersProductScreenState createState() => _FarmersProductScreenState();
}

class _FarmersProductScreenState extends State<FarmersProductScreen> {
  List products = [];
  List filteredProducts = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseurl/GetProductsData/'));

    if (response.statusCode == 200) {
      setState(() {
        products = json.decode(response.body);
        filteredProducts = products;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) => product['productname'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer'),
        backgroundColor: const Color.fromARGB(255, 150, 219, 152),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterProducts,
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: EdgeInsets.all(10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: product['image'] != null
                                  ? Image.network(baseurl+product['image'], fit: BoxFit.cover)
                                  : Icon(Icons.image, size: 50, color: Colors.grey),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(product['productname'],
                                      style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(height: 5),
                                  Text('₹${product['description']}',
                                      style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 5),
                                  Text(product['contact']),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action to add a new product
        },
        backgroundColor: const Color.fromARGB(255, 35, 134, 38),
        child: Icon(Icons.add),
      ),
    );
  }
}


