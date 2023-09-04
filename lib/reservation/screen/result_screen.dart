import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:jari_bean/reservation/screen/simplified_filter_screen.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';

class ResultScreen extends ConsumerWidget {
  static String get routerName => '/result';
  final String cafeId;
  const ResultScreen({
    required this.cafeId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final param = ref.watch(searchQueryProvider);
    return DefaultLayout(
      title: "검색 결과",
      child: Column(
        children: [
          SimplifiedFilterScreen(),
        ],
      ),
    );
  }
}
