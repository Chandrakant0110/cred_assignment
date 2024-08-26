import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExploreScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const ExploreScreen(),
      );

  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool isListView = false;
  bool isLoading = false;
  List<dynamic> sections = [];

  Future<void> fetchData() async {
    final response = await http
        .get(Uri.parse('https://api.mocklets.com/p6839/explore-cred'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        sections = data['sections'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 72,
            ),
            const Text(
              'explore',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CRED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isListView) {
                            isListView = false;
                          } else {
                            isListView = true;
                          }
                        });
                      },
                      child: Image.asset(
                        isListView
                            ? 'assets/images/mode=on.png'
                            : 'assets/images/mode=off.png',
                        scale: 2,
                      ),
                    ),
                    const SizedBox(
                      width: 32,
                    ),
                    Image.asset(
                      'assets/images/Drop Down.png',
                      scale: 1.7,
                    )
                  ],
                ),
              ],
            ),
            Text(
              isListView ? 'data' : 'Not a list',
            ),
          ],
        ),
      ),
    );
  }
  
}
