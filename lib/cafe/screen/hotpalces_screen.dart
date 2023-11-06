import 'package:flutter/material.dart';
import 'package:jari_bean/cafe/model/cafe_description_model.dart';
import 'package:jari_bean/common/component/pagination_list_view.dart';
import 'package:jari_bean/common/layout/default_card_layout.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/reservation/provider/hotplace_cafes_provider.dart';

class HotplacesScreen extends StatelessWidget {
  static String get routerName => '/hotplaces';
  const HotplacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '핫플레이스',
      child: PaginationListView<CafeDescriptionModel>(
        provider: hotplaceCafesProvider,
        itemBuilder: (context, ref, index, model) =>
            DefaultCardLayout.fromModel(model: model),
      ),
    );
  }
}
