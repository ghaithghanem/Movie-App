import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors/my_colors.dart';
import '../../../_widgets/auth/no_account_widget.dart';
import '../../../_widgets/auth/signin/sign_in_form_widget.dart';

@RoutePage()
class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: MyColors.yellow,
      body:SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: ScreenUtil().setHeight(50)),
                      Image.asset('assets/images/logo_movie_app.png',
                          height: ScreenUtil().setHeight(90),
                          width: ScreenUtil().setWidth(90),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      Text("Welcome to MovieAPP",
                          style: Theme.of(context).textTheme.bodyMedium),
                      SizedBox(height: ScreenUtil().setHeight(50)),
                      const Text(
                        "Sign in with your email and password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                           //color: Colors.black,
                            fontSize: 17.0,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      const SignInForm(),
                      SizedBox(height: ScreenUtil().setHeight(30)),
                      const NoAccountWidget(),
                    ],
                  ),
                )),
          )) ,

    );
  }
}
