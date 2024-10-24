import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';
import 'package:hauui_flutter/features/on_boarding/presentation/screens/hobbies_view_model.dart';

import 'cell_hobby.dart';

class CellHobbyWithSubHobbies extends StatelessWidget {
  const CellHobbyWithSubHobbies({super.key, required this.hobby, required this.levelId});

  final HobbyModel hobby;
  final int levelId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          start: AppDimens.spacingNormal, end: AppDimens.spacingNormal, bottom: AppDimens.spacingNormal),
      child: Consumer(
        builder: (context, ref, child) {
          final selectedLocalHobbiesList = ref.watch(HobbiesViewModel.hobbiesSelectedProvider).selectedLocalHobbiesList;

          return Column(
            children: [
              CellHobby(
                title: hobby.name ?? '',
                isParentHobbies: true,
                isSelected: selectedLocalHobbiesList.any((element) => element.id == hobby.id),
                onChanged: (value) => _onChangeSelectedHobbies(value, ref, hobby),
              ),
              ...List.generate(
                  hobby.subHobbies!.length,
                  (i) => Padding(
                        padding: const EdgeInsets.only(top: AppDimens.spacingSmall),
                        child: CellHobby(
                          title: hobby.subHobbies![i].name ?? '',
                          isParentHobbies: false,
                          isSelected: selectedLocalHobbiesList.any((element) => element.id == hobby.subHobbies![i].id),
                          onChanged: (value) => _onChangeSelectedHobbies(value, ref, hobby.subHobbies![i]),
                        ),
                      )),
            ],
          );
        },
      ),
    );
  }

  void _onChangeSelectedHobbies(bool? isSelected, WidgetRef ref, HobbyModel hobbies) {
    if (isSelected ?? false) {
      ref.read(HobbiesViewModel.hobbiesSelectedProvider).addHobbiesLocal(hobbies);
    } else {
      ref.read(HobbiesViewModel.hobbiesSelectedProvider).removeHobbiesLocal(hobbies);
    }
  }
}
