import 'package:flutter/material.dart';

import '../../../../../shared/resources/colors_manager.dart';

class DoubleDivider extends StatelessWidget {
  const DoubleDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Divider(
            color: ColorsManager.grayMedium,
            height: 1,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Divider(
            color: ColorsManager.grayMedium,
            height: 1,
          ),
        ),
      ],
    );
  }
}
