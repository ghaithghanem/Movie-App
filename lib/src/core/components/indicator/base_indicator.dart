import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BaseIndicator extends StatelessWidget {
  const BaseIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitSpinningLines(
        color: Colors.green,
        size: 50.0,
      ),
    );
  }
}
