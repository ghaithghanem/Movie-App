import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../../../config/router/app_router.gr.dart';
import '../../../../core/components/card/create_groupe/avatar_card.dart';
import '../../../../core/components/card/select_contact/ContactCard.dart';
import '../../../../data/models/message_model/select_item_model.dart';


class CreateGroupeWidget extends StatefulWidget {
  const CreateGroupeWidget({super.key});

  @override
  State<CreateGroupeWidget> createState() => _CreateGroupeWidgetState();
}

class _CreateGroupeWidgetState extends State<CreateGroupeWidget> {
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
  List<ChatModel> groupmember = [];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
            itemCount: contacts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  height: groupmember.length > 0 ? 90 : 10,
                );
              }
              return InkWell(
                onTap: () {
                  setState(() {
                    if (contacts[index - 1].select == true) {
                      groupmember.remove(contacts[index - 1]);
                      contacts[index - 1].select = false;
                    } else {
                      groupmember.add(contacts[index - 1]);
                      contacts[index - 1].select = true;
                    }
                  });
                },
                child: ContactCard(
                  contact: contacts[index - 1],
                ),
              );
            }),
        groupmember.length > 0
            ? Align(
          child: Column(
            children: [
              Container(
                height: 75,
                color: Colors.white,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      if (contacts[index].select == true)
                        return InkWell(
                          onTap: () {
                            setState(() {
                              groupmember.remove(contacts[index]);
                              contacts[index].select = false;
                            });
                          },
                          child: AvatarCard(
                            chatModel: contacts[index],
                          ),
                        );
                      return Container();
                    }),
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ),
          alignment: Alignment.topCenter,
        )
            : Container(),
      ],
    );
  }
}
