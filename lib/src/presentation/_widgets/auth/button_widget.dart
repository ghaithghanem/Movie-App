import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors/my_colors.dart';


class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.press,
      this.isLoading = false})
      : super(key: key);
  final String? text;
  final bool isLoading;
  final Function? press;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: ScreenUtil().setHeight(40),
      child: TextButton(
        style: TextButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          foregroundColor: Colors.white,
          backgroundColor: MyColors.black,
        ),
        onPressed: press as void Function()?,
        child: isLoading
            ? const CupertinoActivityIndicator()
            : Text(
                text!,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(20),
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w500),
              ),
      ),
    );
  }
}
