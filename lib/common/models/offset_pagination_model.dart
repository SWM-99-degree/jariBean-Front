import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:json_annotation/json_annotation.dart';

abstract class OffsetPaginationBase {}

class OffsetPaginationError extends OffsetPaginationBase {
  final String message;
  OffsetPaginationError({required this.message});
}

class OffsetPaginationLoading extends OffsetPaginationBase {}

@JsonSerializable(
  genericArgumentFactories: true,
)
class OffsetPagination<T extends IModelWithId> extends OffsetPaginationBase {
  final List<T> content;
  final int page;
  final bool last;

  OffsetPagination({
    required this.content,
    required this.page,
    required this.last,
  });

  copyWith({
    List<T>? content,
    int? page,
    bool? last,
  }) {
    return OffsetPagination(
      content: content ?? this.content,
      page: page ?? this.page,
      last: last ?? this.last,
    );
  }
}

@JsonSerializable(
  genericArgumentFactories: true,
)
class OffsetPaginationFetchingMore<T extends IModelWithId>
    extends OffsetPagination<T> {
  OffsetPaginationFetchingMore({
    required super.content,
    required super.page,
    required super.last,
  });
}

@JsonSerializable(
  genericArgumentFactories: true,
)
class OffsetPaginationRefetching<T extends IModelWithId>
    extends OffsetPagination<T> {
  OffsetPaginationRefetching({
    required super.content,
    required super.page,
    required super.last,
  });
}
