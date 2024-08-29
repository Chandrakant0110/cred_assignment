import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final double listItemHeight = 120.0;
  bool isOffline = false;

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
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
    } on SocketException {
      setState(() {
        isOffline = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : isOffline
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/Error.svg',
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    const Text(
                      'No connection! :(',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 0, 15, 0),
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
                                      isListView = !isListView;
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
                        const SizedBox(
                          height: 16,
                        ),
                        for (int i = 0; i < sections.length; i++) ...[
                          Text(
                            sections[i]['template_properties']['header']
                                ['title'],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          sectionCard(
                            isListView,
                            sections[i],
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget sectionCard(bool isListView, dynamic sectionData) {
    final numberOfItemsInSection =
        sectionData['template_properties']['items'].length;

    final int numberOfRows =
        isListView ? numberOfItemsInSection : numberOfItemsInSection ~/ 3 + 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double gridItemWidth = (constraints.maxWidth - 16) / 3;
        final double gridItemHeight = gridItemWidth + 4;

        return Container(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOutCubic,
            height: isListView
                ? numberOfRows * listItemHeight + 2
                : numberOfRows * gridItemHeight + 2,
            child: Stack(
              children: List.generate(numberOfItemsInSection, (index) {
                final itemData =
                    sectionData['template_properties']['items'][index];
                return _buildAnimatedItem(
                    index, constraints, isListView, itemData);
              }),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedItem(int index, BoxConstraints constraints,
      bool isListView, dynamic itemData) {
    final double gridItemWidth = (constraints.maxWidth - 16) / 3;
    final double gridItemHeight = gridItemWidth;

    // Determining the grid or list positions
    final int row = isListView ? index ~/ 1 : index ~/ 3;
    final int column = isListView ? 0 : index % 3;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      left: isListView ? 0 : column * gridItemWidth,
      top: row * (isListView ? listItemHeight : gridItemHeight),
      width: isListView ? constraints.maxWidth : gridItemWidth,
      height: isListView ? listItemHeight : gridItemHeight,
      child: Container(
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.1,
                        ),
                      ),
                      child: Image.network(
                        itemData['display_data']['icon_url'],
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    if (!isListView)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          itemData['display_data']['name'],
                          overflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                  ],
                ),
                isListView
                    ? const SizedBox(
                        width: 12,
                      )
                    : const SizedBox.shrink(),
                isListView
                    ? Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemData['display_data']['name'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 15),
                            ),
                            Text(
                              itemData['display_data']['description'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
