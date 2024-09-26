import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../main.dart';
import '../../../../../main.dart';
import '../../../../config/router/app_router.gr.dart';
import '../../../../core/theme/colors/my_colors.dart';
import '../../../cubit/auth/export_auth_cubits.dart';
import '../../../cubit/image_picker/export_image_picker_cubits.dart';
import '../../image_picker/imager_picker_widget.dart';
import '../button_widget.dart';
import '../text_field_widget.dart';
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

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({super.key});

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  File? selectedImage;
  final _formKey = GlobalKey<FormState>();
  late String? email;
  late String? password;
  late String? confirmPassword;
  late String? firstName;
  late String? lastName;
  late String? username;
  late DateTime? dateOfBirth;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          BlocConsumer<ImagePickerCubit, ImagePickerState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : AssetImage('assets/images/logo_movie_app.png') as ImageProvider<Object>?,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: ImagePickerWidget(
                      onImageSelected: (image) {
                        print('Image selected: ${image.path}');
                        context.read<ImagePickerCubit>().emit(ImagePickerSuccess(image));
                      },
                    ),
                  ),
                ],
              );
            },
            listener: (BuildContext context, ImagePickerState state) {
              print('$state');
              if (state is ImagePickerSuccess) {
                setState(() {
                  selectedImage = state.image;
                });

                print('SignupView: Selected image path: ${selectedImage!.path}');
              }
              if (state is ImagePickerError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                ));
              }
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Text("Register Account",
              style: Theme.of(context).textTheme.headlineLarge),
          SizedBox(height: ScreenUtil().setHeight(10)),
          const Text(
            "Complete your details",
            textAlign: TextAlign.center,
            style: TextStyle(
                //color: Colors.black,
                fontSize: 17.0,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w300),
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          buildFirstNameFormField(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          buildLastNameFormField(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          buildUsernameFormField(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          buildEmailFormField(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          buildPasswordFormField(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          buildConfirmPasswordFormField(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          buildDateOfBirthFormField(),
          SizedBox(height: ScreenUtil().setHeight(20)),
          BlocConsumer<SignupCubit, SignupState>(
            listener: (context, state) {
              if (state is SignupSuccess) {
                _onNavigatePressed(context, state);
              }
              if (state is SignupError) {
                _showSnackBar(context, state);
              }
            },
            builder: (context, state) {
              return ButtonWidget(
                text: "Continue",
                isLoading: state is SignupLoading ? true : false,
                press: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _onContinuePressed(context);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _onContinuePressed(BuildContext context) {
    DateTime? parsedDateOfBirth = DateTime.tryParse(_dateOfBirthController.text.trim());
    if (parsedDateOfBirth == null) {
      // Handle invalid date of birth
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please enter a valid date of birth"),
      ));
      return;
    }

    BlocProvider.of<SignupCubit>(context).signup(
      _firstNameController.text.trim(),
      _lastNameController.text.trim(),
      _emailController.text.trim(),
      _usernameController.text.trim(),
      _passwordController.text.trim(),
      parsedDateOfBirth,
      selectedImage!.path,
    );
  }

  void _onNavigatePressed(BuildContext context, state) {
    context.router.replace(SigninRoute());
    // Implement navigation logic
  }

  void _showSnackBar(BuildContext context, state) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(state.error!.toString().split("] ")[1]),
    ));
  }

  TextFieldWidget buildFirstNameFormField() {
    return TextFieldWidget(
      controller: _firstNameController,
      labelText: "First Name",
      hintText: "Enter your first name",
      suffixIcon: Icons.person,
      iconColor: MyColors.black,
      backgroundColor: MyColors.edittext,
      onSaved: (newValue) => firstName = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return kNamelNullError;
        }
        return null;
      },
      onChanged: (value) {
        firstName = value;
      },
    );
  }

  TextFieldWidget buildLastNameFormField() {
    return TextFieldWidget(
      controller: _lastNameController,
      labelText: "Last Name",
      hintText: "Enter your last name",
      suffixIcon: Icons.person,
      iconColor: MyColors.black,
      backgroundColor: MyColors.edittext,
      onSaved: (newValue) => lastName = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return kNamelNullError;
        }
        return null;
      },
      onChanged: (value) {
        lastName = value;
      },
    );
  }

  TextFieldWidget buildUsernameFormField() {
    return TextFieldWidget(
      controller: _usernameController,
      suffixIcon: Icons.person,
      labelText: "Username",
      hintText: "Enter your username",
      onSaved: (newValue) => username = newValue,
      backgroundColor: MyColors.edittext,
      iconColor: MyColors.black,
      validator: (value) {
        if (value!.isEmpty) {
          return kNamelNullError; // Replace with appropriate error message if needed
        }
        return null;
      },
      onChanged: (value) {
        username = value;
      },
    );
  }

  TextFieldWidget buildEmailFormField() {
    return TextFieldWidget(
      controller: _emailController,
      textInputType: TextInputType.emailAddress,
      labelText: "Email",
      hintText: "Enter your email",
      suffixIcon: Icons.email,
      backgroundColor: MyColors.edittext,
      iconColor: MyColors.black,
      onSaved: (newValue) => email = newValue,
      validator: (value) {
        if (value!.isEmpty) {
          return kEmailNullError;
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          return kInvalidEmailError;
        }
        return null;
      },
      onChanged: (value) {
        email = value;
      },
    );
  }

  TextFieldWidget buildPasswordFormField() {
    return TextFieldWidget(
      controller: _passwordController,
      obscureText: true,
      isPassword: true,
      labelText: "Password",
      hintText: "Enter your password",
      suffixIcon: Icons.lock,
      onSaved: (newValue) => password = newValue,
      backgroundColor: MyColors.edittext,
      iconColor: MyColors.black,
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        } else if (value.length < 8) {
          return kShortPassError;
        }
        return null;
      },
      onChanged: (value) {
        password = value;
      },
    );
  }

  TextFieldWidget buildConfirmPasswordFormField() {
    return TextFieldWidget(
      controller: _confirmPasswordController,
      isLast: true,
      obscureText: true,
      isPassword: true,
      labelText: "Confirm Password",
      hintText: "Re-enter your password",
      suffixIcon: Icons.lock,
      onSaved: (newValue) => confirmPassword = newValue,
      backgroundColor: MyColors.edittext,
      iconColor: MyColors.black,
      onChanged: (value) {
        confirmPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return kPassNullError;
        } else if ((password != value)) {
          return kMatchPassError;
        }
        return null;
      },
    );
  }

  TextFieldWidget buildDateOfBirthFormField() {
    return TextFieldWidget(
      controller: _dateOfBirthController,
      labelText: "Date of Birth",
      hintText: "Enter your date of birth",
      suffixIcon: Icons.date_range_outlined,
      isDate: true,
      backgroundColor: MyColors.edittext,
      iconColor: MyColors.black,
      onSaved: (newValue) => dateOfBirth = DateTime.tryParse(newValue!),
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter your date of birth";
        } else if (DateTime.tryParse(value) == null) {
          return "Please enter a valid date";
        }
        return null;
      },
      onChanged: (value) {
        dateOfBirth = DateTime.tryParse(value);
      },
    );
  }
}
