import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../config/router/app_router.gr.dart';
import '../../../../core/components/card/select_contact/ContactCard.dart';
import '../../../../core/components/card/select_contact/select_button_card.dart';
import '../../../../data/models/message_model/select_item_model.dart';

class SelectItemWidget extends StatefulWidget {
  const SelectItemWidget({super.key});

  @override
  State<SelectItemWidget> createState() => _SelectItemWidgetState();
}

class _SelectItemWidgetState extends State<SelectItemWidget> {
  List<ChatModel> contacts = [
    ChatModel(name: "Dev Stack", status: "A full stack developer"),
    ChatModel(name: "Balram", status: "Flutter Developer..........."),
    ChatModel(name: "Saket", status: "Web developer..."),
    ChatModel(name: "Bhanu Dev", status: "App developer...."),
    ChatModel(name: "Collins", status: "Raect developer.."),
    ChatModel(name: "Kishor", status: "Full Stack Web"),
    ChatModel(name: "Testing1", status: "Example work"),
    ChatModel(name: "Testing2", status: "Sharing is caring"),
    ChatModel(name: "Divyanshu", status: "....."),
    ChatModel(name: "Helper", status: "Love you Mom Dad"),
    ChatModel(name: "Tester", status: "I find the bugs"),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: contacts.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return InkWell(
              onTap: () {
                /* Navigator.push(context,
                        MaterialPageRoute(builder: (builder) => CreateGroup())); */
                context.router.push(CreateGroupeRoute());
              },
              child: SelectButtonCard(
                icon: Icons.group,
                name: "New group",
              ),
            );
          } else if (index == 1) {
            return SelectButtonCard(
              icon: Icons.person_add,
              name: "New contact",
            );
          }
          return ContactCard(
            contact: contacts[index - 2],
          );
        });
  }
}
