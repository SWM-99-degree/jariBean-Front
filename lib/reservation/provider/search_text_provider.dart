import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchTextProvider = StateNotifierProvider<SearchTextStateNotifier,
    String>((ref) {
  return SearchTextStateNotifier();
});

class SearchTextStateNotifier extends StateNotifier<String>{
  SearchTextStateNotifier() : super('');

  set searchText(String keyword) {
    state = keyword;
  }
}