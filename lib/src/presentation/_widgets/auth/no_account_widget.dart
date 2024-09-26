import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main.dart';
import '../../../../main.dart';
import '../../../config/router/app_router.gr.dart';
import '../../../core/theme/colors/my_colors.dart';


class NoAccountWidget extends StatelessWidget {
  const NoAccountWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don’t have an account? ",
          style: TextStyle(
              //color: MyColors.grey,
              fontSize: ScreenUtil().setSp(15),
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.w400),
        ),
        GestureDetector(
          onTap: () => _onSignUpPressed(context),
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontSize: ScreenUtil().setSp(15),
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
                color: MyColors.blue),
          ),
        ),
      ],
    );
  }

  void _onSignUpPressed(BuildContext context) {
    context.router.replace(SignupRoute());
  }
}
