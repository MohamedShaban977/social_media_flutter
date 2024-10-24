import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_dimens.dart';
import 'package:hauui_flutter/core/constants/app_images.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_image.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController searchController;
  final String hintText;

  final void Function()? onSubmitted;

  const SearchWidget({
    super.key,
    required this.searchController,
    required this.hintText,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: AppDimens.customSpacing12,
            end: AppDimens.spacingSmall,
          ),
          child: CustomImage.svg(
            src: AppSvg.icSearch,
          ),
        ),
      ),
      textInputAction: TextInputAction.search,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      onSubmitted: onSubmitted == null ? null : (value) => onSubmitted!(),
    );
  }
}
