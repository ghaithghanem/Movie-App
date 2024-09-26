import 'dart:io';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/router/app_router.gr.dart';
import '../../../../core/theme/colors/my_colors.dart';
import '../../../_widgets/auth/app_bar_widget.dart';
import '../../../_widgets/auth/signup/sign_up_form_widget.dart';
import '../../../_widgets/image_picker/imager_picker_widget.dart';
import '../../../cubit/image_picker/export_image_picker_cubits.dart';

@RoutePage()
class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        //backgroundColor: MyColors.yellow,
        appBar: AppBar(
          title: Text("Sign Up"),
          leading: Padding(
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(10)),
          child: Row(
              children: [
              Expanded( //TODO: Add Expanded here
              child:  IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    context.router.replace(SigninRoute());
                  },
                    ),
              ),
          SizedBox(width: 18.w,),
          Expanded( //TODO: Add Expanded here
          child:
          Image.asset(
                  'assets/images/logo_movie_app.png',
                  height: ScreenUtil().setHeight(50),
                  width: ScreenUtil().setWidth(50),
                ),
          )
              ],
            ),

          ),
        ),


      body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: ScreenUtil().setHeight(20)),
                    const SignUpFormWidget(),
                    SizedBox(height: ScreenUtil().setHeight(30)),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}