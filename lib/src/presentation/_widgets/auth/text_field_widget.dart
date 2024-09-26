import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors/my_colors.dart';


class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    Key? key,
    this.textInputType,
    this.isLast = false,
    this.isDate = false,
    this.isPassword = false,
    required this.labelText,
    required this.hintText,
    required this.suffixIcon,
    this.onSaved,
    required this.validator,
    required this.onChanged,
    this.controller,
    this.obscureText = false,
    this.backgroundColor = Colors.white,
    this.iconColor,
  }) : super(key: key);

  final TextInputType? textInputType;
  final String labelText;
  final String hintText;
  final bool? isDate;
  final bool? isPassword;
  final IconData? suffixIcon;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<dynamic>? onChanged;
  final bool obscureText;
  final bool? isLast;
  final TextEditingController? controller;
  final Color backgroundColor;
  final Color? iconColor;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _isHidden = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 17),
              ),
            ),
          ),
          child: child!,
        );
      },
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800, 8),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        widget.controller!.text = "${picked.toLocal()}".split(' ')[0]; // Format the date as YYYY-MM-DD
      });
      widget.onChanged!(picked);
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      controller: widget.controller,
      readOnly: widget.isDate! ? true : false,
      textInputAction: widget.isLast! ? TextInputAction.done : TextInputAction.next,
      obscureText: widget.isPassword! ? _isHidden : widget.obscureText,
      keyboardType: widget.textInputType,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: TextStyle(
        color: Colors.black,
        fontSize: ScreenUtil().setSp(15),
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorStyle: TextStyle(
          color: const Color.fromARGB(255, 197, 50, 39),
          fontSize: ScreenUtil().setSp(12),
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        suffixIcon: widget.isDate!
            ? IconButton(
          onPressed: () => _selectDate(context),
          icon: Icon(widget.suffixIcon, color: widget.iconColor),
          color: widget.iconColor ,
            //color: iconColor,
        )
            : widget.isPassword!
            ? IconButton(
          onPressed: () => _togglePasswordView(),
          icon: Icon(
            _isHidden ? Icons.visibility : Icons.visibility_off,
            //color: iconColor,
            color: widget.iconColor ,
          ),
        )
            : Icon(widget.suffixIcon,color: widget.iconColor,),
        focusColor: MyColors.yellow,
        hintStyle: TextStyle(
          color: MyColors.grey,
          fontSize: ScreenUtil().setSp(15),
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
          color: MyColors.grey,
          fontSize: ScreenUtil().setSp(15),
          fontFamily: 'OpenSans',
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12), // Set the corner radius here
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12), // Set the corner radius here
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12), // Set the corner radius here
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 197, 50, 39)), // Border color when error
          borderRadius: BorderRadius.circular(12), // Corner radius
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 197, 50, 39)), // Border color when error and focused
          borderRadius: BorderRadius.circular(12), // Corner radius
        ),
        filled: true, // Ensure the background is filled
        fillColor: widget.backgroundColor,
        contentPadding: EdgeInsets.symmetric(
          vertical: ScreenUtil().setHeight(12),
          horizontal: ScreenUtil().setWidth(15),
        ),
      ),
    );
  }
}
