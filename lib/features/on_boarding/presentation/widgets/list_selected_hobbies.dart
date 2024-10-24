import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/models/hobby_model.dart';

import 'cell_selected_hobby.dart';

class ListSelectedHobbies extends StatelessWidget {
  const ListSelectedHobbies({super.key, required this.hobbiesList, required this.onDeleted});

  final List<HobbyModel> hobbiesList;
  final void Function(int index) onDeleted;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingNormal),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: AppDimens.spacingSmall,
          runSpacing: AppDimens.spacingSmall,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.center,
          children: List.generate(
              hobbiesList.length,
              (index) => CellSelectedHobby(
                    label: hobbiesList[index].name ?? '-',
                    onDeleted: () => onDeleted(index),
                  )),
        ));
  }
}
