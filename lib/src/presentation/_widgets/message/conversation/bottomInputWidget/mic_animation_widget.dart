import 'package:flutter/material.dart';

class MicAnimationWidget extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> micTranslateTop;
  final Animation<double> micRotationFirst;
  final Animation<double> micTranslateRight;
  final Animation<double> micTranslateLeft;
  final Animation<double> micRotationSecond;
  final Animation<double> micTranslateDown;
  final Animation<double> micInsideTrashTranslateDown;
  final Animation<double> trashWithCoverTranslateTop;
  final Animation<double> trashCoverRotationFirst;
  final Animation<double> trashCoverTranslateLeft;
  final Animation<double> trashCoverRotationSecond;
  final Animation<double> trashCoverTranslateRight;
  final Animation<double> trashWithCoverTranslateDown;

  const MicAnimationWidget({
    Key? key,
    required this.animationController,
    required this.micTranslateTop,
    required this.micRotationFirst,
    required this.micTranslateRight,
    required this.micTranslateLeft,
    required this.micRotationSecond,
    required this.micTranslateDown,
    required this.micInsideTrashTranslateDown,
    required this.trashWithCoverTranslateTop,
    required this.trashCoverRotationFirst,
    required this.trashCoverTranslateLeft,
    required this.trashCoverRotationSecond,
    required this.trashCoverTranslateRight,
    required this.trashWithCoverTranslateDown,
  }) : super(key: key);

  @override
  _MicAnimationWidgetState createState() => _MicAnimationWidgetState();
}

class _MicAnimationWidgetState extends State<MicAnimationWidget> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: widget.animationController,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 10)
                    ..translate(widget.micTranslateRight.value)
                    ..translate(widget.micTranslateLeft.value)
                    ..translate(0.0, widget.micTranslateTop.value)
                    ..translate(0.0, widget.micTranslateDown.value)
                    ..translate(0.0, widget.micInsideTrashTranslateDown.value),
                  child: Transform.rotate(
                    angle: widget.micRotationFirst.value,
                    child: Transform.rotate(
                      angle: widget.micRotationSecond.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: Icon(
                Icons.mic,
                color: Color(0xFFef5552),
                size: 30,
              ),
            ),
            AnimatedBuilder(
              animation: widget.trashWithCoverTranslateTop,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, widget.trashWithCoverTranslateTop.value)
                    ..translate(0.0, widget.trashWithCoverTranslateDown.value),
                  child: child,
                );
              },
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: widget.trashCoverRotationFirst,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..translate(widget.trashCoverTranslateLeft.value)
                          ..translate(widget.trashCoverTranslateRight.value),
                        child: Transform.rotate(
                          angle: widget.trashCoverRotationSecond.value,
                          child: Transform.rotate(
                            angle: widget.trashCoverRotationFirst.value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Image(
                      image: AssetImage('assets/images/trash_cover.png'),
                      width: 30,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.5),
                    child: Image(
                      image: AssetImage('assets/images/trash_container.png'),
                      width: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
