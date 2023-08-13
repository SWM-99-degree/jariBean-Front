import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MatchingHomeScreen extends ConsumerWidget {
  const MatchingHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Center(
          child: Text('MatchingHomeScreen'),
        )
      ],
    );
  }
}
