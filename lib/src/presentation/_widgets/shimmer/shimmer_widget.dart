import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/colors/my_colors.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({Key? key, this.height, this.width}) : super(key: key);
  final double? height, width;
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        period: const Duration(milliseconds: 1000),
        baseColor: Theme.of(context).highlightColor.withOpacity(0.5),
        highlightColor: MyColors.backgroundGey.withOpacity(0.04),
        enabled: true,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).primaryColor,
          ),
        ));
  }
}
