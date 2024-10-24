import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class SuggestHobbyRequestBody {
  final int? parentId;
  final String suggestedHobby;

  SuggestHobbyRequestBody({
    this.parentId,
    required this.suggestedHobby,
  });

  Map<String, dynamic> toJson() => {
        "parent_id": parentId,
        "suggested_hobby": suggestedHobby,
      }..removeNullValues();
}
