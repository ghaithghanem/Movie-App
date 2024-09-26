import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../data/models/message_model/select_item_model.dart';
import '../../_widgets/message/create_groupe/create_groupe_widget.dart';

@RoutePage()
class CreateGroupeView extends HookWidget {
  const CreateGroupeView({super.key});


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Group",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Add participants",
              style: TextStyle(
                fontSize: 13,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                size: 26,
              ),
              onPressed: () {}),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF128C7E),
          onPressed: () {},
          child: Icon(Icons.arrow_forward)),
        body: CreateGroupeWidget(),
    );
  }

}