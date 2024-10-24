import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '/generated/locale_keys.g.dart';

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          LocaleKeys.destinationUnknown.tr(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    );
  }
}
