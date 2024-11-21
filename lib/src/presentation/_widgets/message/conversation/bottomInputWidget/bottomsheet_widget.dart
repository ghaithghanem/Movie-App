import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../image_picker/cam_widget.dart';

class bottomSheet extends StatefulWidget {
  const bottomSheet({super.key});

  @override
  State<bottomSheet> createState() => _bottomSheetState();
}

class _bottomSheetState extends State<bottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setSp(288),
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconCreation(Icons.insert_drive_file, Colors.indigo,
                        "Document", () {} // Placeholder
                        ),
                    SizedBox(
                      width: ScreenUtil().setSp(40),
                    ),
                    iconCreation(
                      Icons.camera_alt,
                      Colors.pink,
                      "Camera",
                      () {
                        //context.router.push(CameraScreenRoute());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => CameraApp()));
                      },
                    ),
                    SizedBox(
                      width: ScreenUtil().setSp(40),
                    ),
                    iconCreation(Icons.insert_photo, Colors.purple, "Gallery",
                        () {} // Placeholder
                        ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setSp(30),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    iconCreation(Icons.headset, Colors.orange, "Audio",
                        () {} // Placeholder
                        ),
                    SizedBox(
                      width: ScreenUtil().setSp(40),
                    ),
                    iconCreation(Icons.location_pin, Colors.teal, "Location",
                        () {} // Placeholder
                        ),
                    SizedBox(
                      width: ScreenUtil().setSp(40),
                    ),
                    iconCreation(Icons.person, Colors.blue, "Contact",
                        () {} // Placeholder
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(
      IconData icon, Color color, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap, // Use the callback
      child: Column(
        children: [
          Flexible(
            child: CircleAvatar(
              radius: 30,
              backgroundColor: color,
              child: Icon(
                icon,
                size: 29,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(12),
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
