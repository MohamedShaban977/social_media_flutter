import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_constants.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/enums/filter.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/core/network/api_constants.dart';
import 'package:hauui_flutter/core/network/base_response.dart';
import 'package:hauui_flutter/features/on_boarding/data/models/user_hobbies_model.dart';
import 'package:hauui_flutter/features/on_boarding/data/repositories/on_boarding_repository.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/filter_request_body.dart';
import 'package:hauui_flutter/features/on_boarding/data/requests_bodies/user_hobbies_request_body.dart';

class HobbiesViewModel {
  static final getHobbiesProvider =
      NotifierProvider<HobbiesNotifier, AsyncValue<List<HobbyModel>>>(() => HobbiesNotifier());

  static final hobbiesPageNumberProvider = StateProvider<int>((ref) => ApiConstants.firstPage);

  static final isLastHobbiesPageProvider = StateProvider<bool>((ref) => false);

  static final hobbiesSelectedProvider = ChangeNotifierProvider<HobbiesSelectedChangeNotifier>((ref) {
    return HobbiesSelectedChangeNotifier();
  });

  static final addUserHobbiesProvider =
      StateNotifierProvider<AddUserHobbiesNotifier, AsyncValue<BaseResponse<String>>>((ref) {
    return AddUserHobbiesNotifier(const AsyncValue.loading());
  });

  static final getUserHobbiesProvider =
      StateNotifierProvider<UserHobbiesNotifier, AsyncValue<List<UserHobbiesModel>>>((ref) {
    return UserHobbiesNotifier(const AsyncValue.data([]));
  });

  static void navigateToSelectHobbiesScreen(int levelId) {
    Navigator.pushNamed(
      navigatorKey.currentContext!,
      RoutesNames.onBoardingHobbiesRoute,
      arguments: {
        AppConstants.routeSelectHobbiesKey: levelId,
      },
    );
  }
}

class HobbiesNotifier extends Notifier<AsyncValue<List<HobbyModel>>> {
  @override
  AsyncValue<List<HobbyModel>> build() => const AsyncValue.loading();

  String? keyword;

  Future<void> getHobbiesList({
    // required FilterRequestBody filterRequestBody,
    int? hobbiesPageNumber,
    String? keyword,
  }) async {
    final pageNumber = hobbiesPageNumber ?? ref.read(HobbiesViewModel.hobbiesPageNumberProvider);
    if (pageNumber == ApiConstants.firstPage) state = const AsyncValue.loading();

    if (!ref.read(HobbiesViewModel.isLastHobbiesPageProvider) || pageNumber == ApiConstants.firstPage) {
      final result = await getIt<OnboardingRepository>().getHobbiesList(
          filterRequestBody: FilterRequestBody(
        page: pageNumber!,
        perPage: ApiConstants.defaultPageSize,
        filter: Filter.top.name,
        keyword: keyword,
      ));

      result.fold(
        (error) {
          state = AsyncValue.error(
            error,
            StackTrace.fromString(HandleFailure.mapFailureToMsg(error)),
          );
        },
        (response) {
          state = AsyncValue.data(
              pageNumber == ApiConstants.firstPage ? response.data ?? [] : [...state.value ?? [], ...?response.data]);
          ref.read(HobbiesViewModel.hobbiesPageNumberProvider.notifier).state = pageNumber + 1;
          ref.read(HobbiesViewModel.isLastHobbiesPageProvider.notifier).state =
              (response.data ?? []).length < ApiConstants.defaultPageSize;
        },
      );
    }
  }
}

class HobbiesSelectedChangeNotifier extends ChangeNotifier {
  final List<UserHobby> userHobbies = [];
  List<HobbyModel> selectedLocalHobbiesList = [];
  Map<int, List<HobbyModel>> hobbiesWithLevel = {};
  bool isDisabledButton = true;
  int minimumHobbiesSelected = 2;

  void fillHobbiesLocalFromHobbiesWithLevel(List<HobbyModel> hobbiesList) {
    selectedLocalHobbiesList.clear();
    selectedLocalHobbiesList.addAll(hobbiesList);
    notifyListeners();
  }

  void addHobbiesLocal(HobbyModel hobby) {
    if (!selectedLocalHobbiesList.any((element) => element.id == hobby.id)) {
      selectedLocalHobbiesList.add(hobby);
      notifyListeners();
    }
  }

  void removeHobbiesLocal(HobbyModel hobby) {
    if (selectedLocalHobbiesList.any((element) => element.id == hobby.id)) {
      selectedLocalHobbiesList.removeWhere((element) => element.id == hobby.id);
      notifyListeners();
    }
  }

  void clearLocalList() {
    selectedLocalHobbiesList.clear();
    notifyListeners();
  }

  void onDeleteHobbiesFromChip(int index, int keyLevel, {HobbyModel? hobby}) {
    if (hobby != null) {
      removeHobbiesLocal(hobby);
    } else {
      final hobbiesItem = hobbiesWithLevel[keyLevel]![index];
      _removeHobbies(hobbiesItem, keyLevel);
    }
    _fillUserHobbies();
  }

  void _removeHobbies(HobbyModel hobbiesModel, int keyLevel) {
    if (hobbiesWithLevel.containsKey(keyLevel)) {
      hobbiesWithLevel[keyLevel]!.remove(hobbiesModel);
    }

    notifyListeners();
  }

  void convertHobbiesLocalToHobbiesWithLevel(int keyLevel) {
    if (!hobbiesWithLevel.containsKey(keyLevel)) {
      hobbiesWithLevel[keyLevel] = [];
    }

    if (hobbiesWithLevel.containsKey(keyLevel)) {
      for (var level in hobbiesWithLevel.values) {
        for (int i = 0; i < selectedLocalHobbiesList.length; i++) {
          if (level.any((element) => element.id == selectedLocalHobbiesList[i].id)) {
            level.removeWhere((element) => element.id == selectedLocalHobbiesList[i].id);
          }
        }
      }
    }
    hobbiesWithLevel[keyLevel]?.clear();
    hobbiesWithLevel[keyLevel]?.addAll(selectedLocalHobbiesList);

    _fillUserHobbies();
  }

  void fillHobbiesWithLevelInEditUser(List<UserHobbiesModel> userHobbies) {
    for (var userHobby in userHobbies) {
      if (!hobbiesWithLevel.containsKey(userHobby.id)) {
        hobbiesWithLevel[userHobby.id!] = [];
      }

      for (var hobby in userHobby.hobbies!) {
        hobbiesWithLevel[userHobby.id!]?.add(HobbyModel(
          id: hobby.id,
          name: hobby.name,
        ));
      }
    }
    _fillUserHobbies();
  }

  void _fillUserHobbies() {
    userHobbies.clear();

    final userHobbiesList = hobbiesWithLevel.entries.toList();
    for (var levelIds in userHobbiesList) {
      for (var hobbies in levelIds.value) {
        userHobbies.add(
          UserHobby(
            levelId: levelIds.key,
            hobbyId: hobbies.id,
          ),
        );
      }
    }
    isDisabledButton = userHobbies.length < minimumHobbiesSelected;
    notifyListeners();
  }
}

class AddUserHobbiesNotifier extends StateNotifier<AsyncValue<BaseResponse<String>>> {
  AddUserHobbiesNotifier(super._state);

  Future<void> addUserHobbies(UserHobbiesRequestBody userHobbiesRequestBody) async {
    state = const AsyncValue.loading();

    final result = await getIt<OnboardingRepository>().addUserHobbies(userHobbiesRequestBody);

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response),
    );
  }
}

class UserHobbiesNotifier extends StateNotifier<AsyncValue<List<UserHobbiesModel>>> {
  UserHobbiesNotifier(super._state);

  Future<void> getUserHobbies() async {
    state = const AsyncValue.loading();

    final result = await getIt<OnboardingRepository>().getUserHobbies();

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data ?? []),
    );
  }

  void clearUserHobbies() {
    state = const AsyncValue.data([]);
  }
}
