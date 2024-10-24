import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_globals.dart';
import 'package:hauui_flutter/core/constants/routes/routes_names.dart';
import 'package:hauui_flutter/core/extensions/context_extensions.dart';
import 'package:hauui_flutter/core/managers/theme/text_style_manager.dart';
import 'package:hauui_flutter/core/models/city_model.dart';
import 'package:hauui_flutter/core/models/int_key_string_value_model.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/dropdown_form_field_searchable_paginated_with_label_widget.dart';
import 'package:hauui_flutter/core/widgets/common/widgets/label_screen_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_button_with_loading_widget.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_text_button.dart';
import 'package:hauui_flutter/generated/locale_keys.g.dart';
import 'package:searchable_paginated_dropdown/searchable_paginated_dropdown.dart';

import 'countries_and_cities_view_model.dart';

class CountriesAndCitiesScreen extends ConsumerStatefulWidget {
  const CountriesAndCitiesScreen({super.key});

  @override
  ConsumerState<CountriesAndCitiesScreen> createState() => _CountriesAndCitiesScreenState();
}

class _CountriesAndCitiesScreenState extends ConsumerState<CountriesAndCitiesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ref.read(CountriesAndCitiesViewModel.getCitiesByCountryProvider.notifier).clearCities();
      // ref.invalidate(CountriesAndCitiesViewModel.disableButtonProvider);
      // await ref.read(CountriesAndCitiesViewModel.getCountriesProvider.notifier).getCountriesList();
    });
  }

  IntKeyStingValueModel? selectedCountry;
  CityModel? selectedCity;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<IntKeyStingValueModel>>>(
      CountriesAndCitiesViewModel.getCountriesProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(
          message: error.toString(),
        ),
      ),
    );
    ref.listen<AsyncValue<List<CityModel>>>(
      CountriesAndCitiesViewModel.getCitiesByCountryProvider,
      (previous, next) => next.whenOrNull(
        error: (error, stackTrace) => context.showToast(
          message: error.toString(),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.maybePop(context),
          child: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          CustomTextButton(
            label: LocaleKeys.skip.tr(),
            textStyle: TextStyleManager.semiBold(
              color: AppColors.veryDarkGrayishBlue,
              size: AppDimens.textSize18pt,
            ),
            onPressed: () => Navigator.of(context).pushNamed(RoutesNames.followTopUsersRoute),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
          child: Column(
            children: [
              const SizedBox(height: AppDimens.widgetDimen32pt),
              LabelScreenWidget(
                title: LocaleKeys.titleCountryAndCity.tr(),
                isAxisVirtual: true,
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),

              /// Drop down pagination country
              DropdownFormFieldSearchablePaginatedWithLabelWidget<IntKeyStingValueModel>(
                label: LocaleKeys.country.tr(),
                hintText: LocaleKeys.hintCountry.tr(),
                onChanged: (value) => onChangeCountrySelected(value, ref),
                paginatedRequest: (int pageNumber, String? keyword) async {
                  await ref
                      .read(CountriesAndCitiesViewModel.getCountriesProvider.notifier)
                      .getCountriesList(pageNumber, keyword);
                  final countriesState = ref.read(CountriesAndCitiesViewModel.getCountriesProvider);

                  return (countriesState.value ?? [])
                      .map((e) => SearchableDropdownMenuItem<IntKeyStingValueModel>(
                            label: e.name ?? '-',
                            child: Text(
                              e.name ?? '-',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            value: e,
                          ))
                      .toList();
                },
              ),
              const SizedBox(height: AppDimens.widgetDimen16pt),

              /// Drop down pagination city
              Consumer(
                builder: (context, ref, _) {
                  final selectCountry = ref.watch(CountriesAndCitiesViewModel.selectCountryProvider);
                  return DropdownFormFieldSearchablePaginatedWithLabelWidget<CityModel>(
                    label: LocaleKeys.city.tr(),
                    hintText: LocaleKeys.hintCity.tr(),
                    onChanged: (value) => onChangeCitySelected(value, ref),
                    isEnabled: selectCountry != null,
                    paginatedRequest: (int pageNumber, String? keyword) async {
                      if (ref.read(CountriesAndCitiesViewModel.selectCountryProvider) != null) {
                        await ref
                            .read(CountriesAndCitiesViewModel.getCitiesByCountryProvider.notifier)
                            .getCitiesByCountry(
                              ref.read(CountriesAndCitiesViewModel.selectCountryProvider)!.id!,
                              pageNumber: pageNumber,
                              searchKey: keyword,
                            );
                      }
                      final citiesState = ref.read(CountriesAndCitiesViewModel.getCitiesByCountryProvider);
                      return (citiesState.value ?? [])
                          .map((e) => SearchableDropdownMenuItem<CityModel>(
                                label: e.name ?? '-',
                                child: Text(
                                  e.name ?? '-',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                value: e,
                              ))
                          .toList();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingSmall),
          child: Consumer(
            builder: (context, ref, child) {
              final isDisableButton = ref.watch(CountriesAndCitiesViewModel.disableButtonProvider);
              return Center(
                child: CustomButtonWithLoading(
                  isDisabled: isDisableButton,
                  onPressed: () async => updateCityOnPressed(ref),
                  title: LocaleKeys.done.tr(),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  void onChangeCitySelected(CityModel? value, WidgetRef ref) {
    selectedCity = value;
    ref
        .read(CountriesAndCitiesViewModel.disableButtonProvider.notifier)
        .update((state) => state = selectedCity?.id == null);
  }

  Future<void> onChangeCountrySelected(IntKeyStingValueModel? value, WidgetRef ref) async {
    ref.read(CountriesAndCitiesViewModel.selectCountryProvider.notifier).update((state) => state = value);
    selectedCity = null;
    ref.read(CountriesAndCitiesViewModel.getCitiesByCountryProvider.notifier).clearCities();
    ref
        .read(CountriesAndCitiesViewModel.disableButtonProvider.notifier)
        .update((state) => state = selectedCity?.id == null);
    if (selectedCountry != null) {
      await ref
          .read(CountriesAndCitiesViewModel.getCitiesByCountryProvider.notifier)
          .getCitiesByCountry(selectedCountry!.id!);
    }
  }

  Future<void> updateCityOnPressed(WidgetRef ref) async {
    if (selectedCity != null) {
      await ref
          .read(CountriesAndCitiesViewModel.updateCityProvider.notifier)
          .updateProfileCity(cityId: selectedCity!.id!);
    } else {
      navigatorKey.currentContext!.showToast(message: LocaleKeys.failedToUpdateCity.tr());
    }
  }
}
