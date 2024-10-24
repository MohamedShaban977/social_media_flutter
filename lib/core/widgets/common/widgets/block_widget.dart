import 'package:flutter/material.dart';
import 'package:hauui_flutter/core/constants/app_colors.dart';
import 'package:hauui_flutter/core/widgets/custom/custom_progress_indicator.dart';

class BlockWidget extends StatelessWidget {
  const BlockWidget({
    super.key,
    this.backIcon = Icons.arrow_back_ios,
  });

  final IconData? backIcon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white.withOpacity(0.2),
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          child: Icon(backIcon),
        ),
      ),
      body: const Center(
        child: CustomProgressIndicator(),
      ),
    );
  }
}
