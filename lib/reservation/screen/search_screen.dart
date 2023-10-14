import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jari_bean/common/layout/default_screen_layout.dart';
import 'package:jari_bean/common/provider/location_provider.dart';
import 'package:jari_bean/reservation/component/search_box.dart';
import 'package:jari_bean/reservation/model/service_area_model.dart';
import 'package:jari_bean/reservation/provider/service_area_provider.dart';
import 'package:jari_bean/reservation/screen/query_filter_screen.dart';

class SearchScreen extends ConsumerWidget {
  final String? serviceAreaId;
  static String get routerName => '/search';
  const SearchScreen({
    this.serviceAreaId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ServiceAreaModel? serviceArea = ref
        .watch(serviceAreaProvider.notifier)
        .getServiceAreaById(serviceAreaId);
    final geocode = ref.watch(geocodeProvider);
    late final String? searchAreaName;
    if (serviceArea?.name != null) {
      searchAreaName = serviceArea!.name;
    } else if (geocode != defaultGeocodeString &&
        geocode != errorGeocodeString &&
        geocode != errorGeocodeStringNotServiceArea) {
      searchAreaName = geocode.split(' ').last;
    } else {
      searchAreaName = null;
    }

    return DefaultLayout(
      titleWidget: Hero(
        tag: 'searchBox',
        child: SearchBox(
          searchArea: searchAreaName,
          hintText: '카페를 검색해주세요',
        ),
      ),
      child: QueryFilterScreen(),
    );
  }
}
