import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? leading;

  const AppBarWidget({
    Key? key,
    this.title = '',
    this.leading,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(ScreenUtil().setHeight(50));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Text(
        title!,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      centerTitle: true,
    );
  }
}
