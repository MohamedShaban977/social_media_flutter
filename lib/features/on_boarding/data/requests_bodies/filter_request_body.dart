import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class FilterRequestBody {
  final String? filter;
  final int? page;
  final int? perPage;
  final String? keyword;
  final String? searchKey;
  final int? parentHobby;

  FilterRequestBody({
    this.filter,
    this.page,
    this.perPage,
    this.keyword,
    this.searchKey,
    this.parentHobby,
  });

  Map<String, dynamic> toJson() => {
        "filter": filter,
        "page": page,
        "per_page": perPage,
        "keyword": keyword,
        "search_key": searchKey,
        "parent_hobby": parentHobby,
      }..removeNullValues();
}
