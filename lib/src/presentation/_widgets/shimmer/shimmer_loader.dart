import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/src/presentation/_widgets/shimmer/shimmer_widget.dart';
import '../../../core/theme/colors/my_colors.dart';

class messagesShimmer extends StatelessWidget {
  const messagesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(padding: EdgeInsets.only(left: 10),
          child: Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          )
        ),
        Expanded(
            child: Column(
              children: [
                 Padding(
                  padding: EdgeInsets.only(left: 10, right: 180 ),
                  child : Container(
                    height: 10.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                    child:
                    Padding(
                      padding: EdgeInsets.only( left: 10 ),
                      child : Container(
                        height: 10.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    ),
                    Flexible(
                      child: Padding(
                      padding: EdgeInsets.only( left: 90 ),
                      child :
                      Container(
                        height: 10.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      ),
                    ),
                  ],
                ),
              ],
            )
        ),
      ],
    );
  }
}

class MovieShimmer extends StatelessWidget {
  const MovieShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 5.h ,),
        Flexible(
          child: Container(
            height: 170.h,
            width: 170.w,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                const BorderRadius.all(Radius.circular(16))),
          ),
        ),
        SizedBox(width: 10 ,),
        Flexible(
          child: Container(
            height: 170.h,
            width: 170.w,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                const BorderRadius.all(Radius.circular(16))),
          ),
        ),

      ],
    );
  }
}
