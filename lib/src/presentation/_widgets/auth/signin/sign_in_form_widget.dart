import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/src/presentation/_widgets/auth/text_field_widget.dart';
import '../../../../../main.dart';
import '../../../../config/router/app_router.gr.dart';
import '../../../../core/database/hive.dart';
import '../../../../core/theme/colors/my_colors.dart';
import '../../../cubit/auth/export_auth_cubits.dart';
import '../../../cubit/auth/user_manager/auth_cubit.dart';
import '../button_widget.dart';

final RegExp emailValidatorRegExp =
RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Please Enter your password";
const String kShortPassError = "Password is too short";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";


class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  late String? email;
  late String? password;
  bool remember = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //late final HiveService _hiveService;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: MyColors.blue,
                onChanged: (value) {
                  setState(() {
                    remember = value!;
                  });
                },
              ),
              const Text(
                "Remember me",
                style: TextStyle(
                    //color: MyColors.grey,
                    fontSize: 14.0,
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w400),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _onForgotPasswordPressed(context),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(
                      //color: MyColors.grey,
                      fontSize: 14.0,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          BlocListener<LoginCubit, LoginState>(listener: (context, state) {
            if (state is LoginSuccess) {
              // Save the "Remember Me" preference
              if (remember) {
                _saveUserCredentials();

              }
              context.router.replace(MasterRoute());
            }
            if (state is LoginError) {
              _showSnackBar(context, state);
            }
          }, child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
            return ButtonWidget(
              text: "Sign In",
              isLoading: state is LoginLoading ? true : false,
              press: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _onContinuePressed(context);
                }
              },
            );
          }))
        ],
      ),
    );
  }

  void _saveUserCredentials() {
      //final hiveService = context.read<HiveService>();
    final hiveService = GetIt.instance<HiveService>();
    hiveService.saveRememberMe(remember);
      //_hiveService.saveRememberMe(remember);
  }

  void _clearUserCredentials() {
    final hiveService = context.read<HiveService>();
    hiveService.clearAuthToken();
  }

  void _showSnackBar(BuildContext context, state) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(state.error!.toString().split("] ")[1]),
    ));
  }

  void _onContinuePressed(BuildContext context) {
    BlocProvider.of<LoginCubit>(context).login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      remember
    );
  }

  void _onForgotPasswordPressed(BuildContext context) {
    Navigator.pushNamed(context, '/ForgotPassword');
  }

  TextFieldWidget buildPasswordFormField() {
    return TextFieldWidget(
      controller: _passwordController,
      isLast: true,
      obscureText: true,
      isPassword: true,
      labelText: "Password",
      hintText: "Enter your password",
      suffixIcon: Icons.visibility,
      onSaved: (newValue) => password = newValue,
      backgroundColor: MyColors.edittext,
      iconColor: MyColors.black,
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        } else if (value.length < 5) {
          return kShortPassError;
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
        } else if (value.length >= 8) {}
        return;
      },
    );
  }

  TextFieldWidget buildEmailFormField() {
    return TextFieldWidget(
      controller: _emailController,
      textInputType: TextInputType.emailAddress,
      labelText: "Email",
      hintText: "Enter your email",
      iconColor: MyColors.black,
      suffixIcon: Icons.email,
      onSaved: (newValue) => email = newValue,
      backgroundColor: MyColors.edittext,
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      onChanged: (value) {
        if (value.isNotEmpty) {
        } else if (emailValidatorRegExp.hasMatch(value)) {}
        return;
      },
    );
  }
}

