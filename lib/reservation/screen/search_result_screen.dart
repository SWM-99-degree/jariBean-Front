import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/cafe/component/cafe_description.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/component/pagination_list_view.dart';
import 'package:jari_bean/reservation/provider/search_result_provider.dart';
import 'package:jari_bean/reservation/screen/simplified_filter_screen.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';

class SearchResultScreen extends ConsumerWidget {
  static String get routerName => '/search/result';
  const SearchResultScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: "검색 결과",
      child: Column(
        children: [
          SimplifiedFilterScreen(),
          Expanded(
            child: PaginationListView<CafeDescriptionModel>(
              provider: searchResultProvider,
              itemBuilder: (context, ref, index, model) {
                return CafeDescription.fromModel(model: model);
              },
            ),
          ),
        ],
      ),
    );
  }
}
