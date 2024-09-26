import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  const RetryButton({super.key, required this.retryAction, required this.text});

  final void Function() retryAction;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Divider(),
         Center(
            child: TextButton(
              onPressed: () => retryAction.call(),
              child: const Text('Retry'),
            ),
          ),
      ],
    );
  }
}
