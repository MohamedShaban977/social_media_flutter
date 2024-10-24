import 'package:hauui_flutter/core/extensions/map_extensions.dart';

class UserHobbiesRequestBody {
  final List<UserHobby> userHobbies;

  UserHobbiesRequestBody({
    required this.userHobbies,
  });

  Map<String, dynamic> toJson() => {
        "user_hobbies": List<dynamic>.from(userHobbies.map((x) => x.toJson())),
      }..removeNullValues();
}

class UserHobby {
  final int? hobbyId;
  final int? levelId;

  UserHobby({
    this.hobbyId,
    this.levelId,
  });

  Map<String, dynamic> toJson() => {
        "hobby_id": hobbyId,
        "level_id": levelId,
      }..removeNullValues();
}
