import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/reservation/provider/table_provider.dart';
import 'package:jari_bean/reservation/provider/search_query_provider.dart';
import 'package:jari_bean/reservation/screen/simplified_filter_screen.dart';

class CafeDetailTableScreen extends ConsumerStatefulWidget {
  final String cafeId;
  const CafeDetailTableScreen({
    required this.cafeId,
    super.key,
  });

  @override
  ConsumerState<CafeDetailTableScreen> createState() =>
      _CafeDetailTableScreenState();
}

class _CafeDetailTableScreenState extends ConsumerState<CafeDetailTableScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset <
          _scrollController.position.minScrollExtent - 150) {
        ref.read(tableProvider(widget.cafeId).notifier).getTables(
              queryFilter: ref.read(searchQueryProvider),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tableDisplayList = ref.watch(tableDisplayProvider(widget.cafeId));
    final param = ref.watch(searchQueryProvider);
    return Column(
      children: [
        SimplifiedFilterScreen(),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: tableDisplayList.length,
            padding: EdgeInsets.only(
              bottom: 10.h,
            ),
            itemBuilder: (context, index) {
              final tableDisplay = tableDisplayList[index];
              return DefaultCardLayout.fromTableDisplayModel(
                cafeId: widget.cafeId,
                model: tableDisplay,
                startTime: param.startTime,
                endTime: param.endTime,
                context: context,
              );
            },
          ),
        ),
      ],
    );
  }
}
