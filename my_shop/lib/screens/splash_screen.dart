import 'package:flutter/material.dart';
import 'package:my_shop/widgets/loading_state.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingState(),
    );
  }
}
