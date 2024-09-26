import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../config/router/app_router.gr.dart';



class MsgFloatingButtonWidget extends StatefulWidget {
  const MsgFloatingButtonWidget({super.key});

  @override
  State<MsgFloatingButtonWidget> createState() => _MsgFloatingButtonWidgetState();
}

class _MsgFloatingButtonWidgetState extends State<MsgFloatingButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(onPressed: (){
      context.router.push(SelectContactRoute());
    },
    child: Icon(Icons.chat),
    );
  }
}
