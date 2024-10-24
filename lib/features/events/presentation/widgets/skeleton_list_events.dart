import 'package:flutter/material.dart';

import 'skeleton_cell_event.dart';

class SkeletonListEvents extends StatelessWidget {
  const SkeletonListEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (context, index) {
        return const SkeletonCellEvent();
      },
    );
  }
}
