import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Product.dart';

void main() {
  runApp(MaterialApp(
    home: Tutorial12(),
  ));
}

class Tutorial12 extends StatefulWidget {
  @override
  _Tutorial12State createState() => _Tutorial12State();
}

class _Tutorial12State extends State<Tutorial12> {
  late Future<List<Product>> futureProducts;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('http://192.168.110.46:8000/api/product'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Error, cannot load products');
    }
  }

  Future<void> addProduct() async {
    final response = await http.post(
      Uri.parse('http://192.168.110.46:8000/api/product'),
      body: {'name': _controller.text},
    );

    if (response.statusCode == 201) {
      setState(() {
        futureProducts = fetchProducts();
      });
    } else {
      throw Exception('Failed to add product');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {
            futureProducts = fetchProducts();
          });
          return Future.value();
        },
        child: FutureBuilder<List<Product>>(
          future: futureProducts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data?[index].name ?? ''),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Product'),
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: "Product Name"),
                ),
                actions: [
                  TextButton(
                    child: Text('Save'),
                    onPressed: () {
                      addProduct();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}