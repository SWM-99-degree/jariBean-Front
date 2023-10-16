import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/cafe/component/table_description.dart';
import 'package:jari_bean/cafe/provider/table_provider.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:jari_bean/reservation/screen/simplified_filter_screen.dart';

class CafeDetailTableScreen extends ConsumerWidget {
  final String cafeId;
  const CafeDetailTableScreen({
    required this.cafeId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableDisplayList = ref.watch(tableDisplayProvider(cafeId));
    final param = ref.watch(searchQueryProvider);
    return Column(
      children: [
        SimplifiedFilterScreen(),
        Expanded(
          child: ListView.builder(
            itemCount: tableDisplayList.length,
            padding: EdgeInsets.only(
              bottom: 10.h,
            ),
            itemBuilder: (context, index) {
              final tableDisplay = tableDisplayList[index];
              return TableDescriptionCard.fromModel(
                model: tableDisplay,
                startTime: param.startTime,
                endTime: param.endTime,
              );
            },
          ),
        ),
      ],
    );
  }
}
