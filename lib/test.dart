import 'package:flutter/material.dart';

class CredAnimation extends StatefulWidget {
  @override
  _CredAnimationState createState() => _CredAnimationState();
}

class _CredAnimationState extends State<CredAnimation> {
  bool _isGrid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("CRED"),
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGrid = !_isGrid;
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("data"),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: List.generate(2, (index) {
                    return _buildAnimatedItem(index, constraints);
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedItem(int index, BoxConstraints constraints) {
    // Determine grid or list positions
    final int row = _isGrid ? index ~/ 3 : index;
    final int column = _isGrid ? index % 3 : 0;

    final double gridItemWidth = constraints.maxWidth / 3;
    final double gridItemHeight = gridItemWidth;
    final double listItemHeight = 100.0;

    return AnimatedPositioned(
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOutCubic,
      left: _isGrid ? column * gridItemWidth : 0,
      top: _isGrid ? row * gridItemHeight : row * listItemHeight,
      width: _isGrid ? gridItemWidth : constraints.maxWidth,
      height: _isGrid ? gridItemHeight : listItemHeight,
      child: Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'Item $index',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
