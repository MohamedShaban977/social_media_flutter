import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/errors/failure.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/models/city_model.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/models/user_model.dart';
import 'package:hauui_flutter/features/on_boarding/data/repositories/on_boarding_repository.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';

class CountriesAndCitiesViewModel {
  static final getCountriesProvider =
      StateNotifierProvider<CountriesNotifier, AsyncValue<List<IntKeyStingValueModel>>>((ref) {
    return CountriesNotifier(const AsyncValue.loading());
  });

  static final getCitiesByCountryProvider = StateNotifierProvider<CitiesNotifier, AsyncValue<List<CityModel>>>((ref) {
    return CitiesNotifier(const AsyncValue.loading());
  });

  static final updateCityProvider = StateNotifierProvider<UpdateCityNotifier, AsyncValue<UserModel?>>((ref) {
    return UpdateCityNotifier(const AsyncValue.loading());
  });

  static final disableButtonProvider = StateProvider<bool>((ref) => true);
  static final selectCountryProvider = StateProvider<IntKeyStingValueModel?>((_) => null);
}

class CountriesNotifier extends StateNotifier<AsyncValue<List<IntKeyStingValueModel>>> {
  CountriesNotifier(super._state);

  Future<void> getCountriesList(int? pageNumber, String? searchKey) async {
    state = const AsyncValue.loading();

    final result = await getIt<OnboardingRepository>().getCountriesList(pageNumber, searchKey);

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data ?? []),
    );
  }
}

class CitiesNotifier extends StateNotifier<AsyncValue<List<CityModel>>> {
  CitiesNotifier(super._state);

  Future<void> getCitiesByCountry(int countryId, {int? pageNumber, String? searchKey}) async {
    state = const AsyncValue.loading();

    final result = await getIt<OnboardingRepository>().getCitiesByCountry(countryId, pageNumber, searchKey);

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data ?? []),
    );
  }

  clearCities() {
    state = const AsyncValue.data([]);
    state = const AsyncValue.loading();
  }
}

class UpdateCityNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  UpdateCityNotifier(super._state);

  Future<void> updateProfileCity({required int cityId}) async {
    state = const AsyncValue.loading();

    final result = await getIt<OnboardingRepository>().updateProfileCity(cityId);

    result.fold(
      (error) => state = AsyncValue.error(HandleFailure.mapFailureToMsg(error), StackTrace.current),
      (response) => state = AsyncValue.data(response.data),
    );

    if (state.hasValue) {
      navigatorKey.currentContext!.showToast(message: LocaleKeys.updatedCitySuccessfully.tr());
      Navigator.of(navigatorKey.currentContext!).pushNamed(RoutesNames.followTopUsersRoute);
    } else {
      navigatorKey.currentContext!.showToast(message: LocaleKeys.failedToUpdateCity.tr());
    }
  }
}
