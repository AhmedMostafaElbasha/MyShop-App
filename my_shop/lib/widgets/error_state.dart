import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.error,
            size: 40,
            color: Colors.black,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Error while loading the data, Please try again later..',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
