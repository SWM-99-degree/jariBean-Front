import 'package:jari_bean/common/models/model_with_id.dart';
import 'package:jari_bean/common/models/offset_pagination_model.dart';

import '../models/pagination_params.dart';

abstract class IPaginationBaseRepository<T extends IModelWithId> {
  Future<OffsetPagination<T>> paginate({
    required PaginationParams paginationParams,
  });
}
