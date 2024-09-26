import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SelectitemAppbarWidget extends StatefulWidget implements PreferredSizeWidget {
  const SelectitemAppbarWidget({super.key});

  @override
  State<SelectitemAppbarWidget> createState() => _SelectitemAppbarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SelectitemAppbarWidgetState extends State<SelectitemAppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          context.router.maybePop(true); // Pops the current route and returns to the previous one
        },
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Select Contact",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            "256 contacts",
            style: TextStyle(
              fontSize: 13,
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
            size: 26,
          ),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          padding: const EdgeInsets.all(0),
          onSelected: (value) {
            print(value);
          },
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("Invite a friend"),
                    Spacer(),
                    Icon(
                      Icons.add,
                      size: 26,
                      color: Colors.green,
                    ),
                  ],
                ),
                value: "Invite a friend",
              ),
              const PopupMenuItem(
                child: Row(
                  children: [
                    Text("Contacts"),
                    Spacer(),
                    Icon(
                      Icons.add_call,
                      size: 26,
                      color: Colors.green,
                    ),
                  ],
                ),
                value: "Contacts",
              ),
              const PopupMenuItem(
                child: Row(
                  children: [
                    Text("Refresh"),
                    Spacer(),
                    Icon(
                      Icons.refresh,
                      size: 26,
                      color: Colors.green,
                    ),
                  ],
                ),
                value: "Refresh",
              ),
              const PopupMenuItem(
                child: Row(
                  children: [
                    Text("Help"),
                    Spacer(),
                    Icon(
                      Icons.help_outline,
                      size: 26,
                      color: Colors.green,
                    ),
                  ],
                ),
                value: "Help",
              ),
            ];
          },
        ),
      ],
    );
  }
}
