import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  bool isGrid = true;
  List<dynamic> categories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http
        .get(Uri.parse('https://api.mocklets.com/p6839/explore-cred'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        categories = data['sections'];
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
        actions: [
          IconButton(
            icon: Icon(isGrid ? Icons.grid_view : Icons.list),
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : isGrid
              ? buildGridView()
              : buildListView(),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final section = categories[index];
        return buildCategoryCard(section);
      },
    );
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final section = categories[index];
        return buildCategoryCard(section);
      },
    );
  }

  Widget buildCategoryCard(dynamic section) {
    return Card(
      child: ListTile(
        leading:
            Image.network(section['template_properties']['items'][0]['display_data']['icon_url']),
        title: Text(section['template_properties']['header']['title']),
        subtitle: Text(section['template_properties']['header']['identifier']),
        onTap: () {
          Navigator.pop(
              context, section['template_properties']['header']['title']);
        },
      ),
    );
  }
}
