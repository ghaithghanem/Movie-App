import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubit/message/conversations/chat_input/chat_input_bloc.dart';

class MicAnimationWidget extends StatefulWidget {
  final ChatInputState state;
  const MicAnimationWidget({
    super.key,
    required this.state,
  });

  @override
  _MicAnimationWidgetState createState() => _MicAnimationWidgetState();
}

class _MicAnimationWidgetState extends State<MicAnimationWidget>
    with TickerProviderStateMixin {
  late Animation<double> micTranslateTop;
  late Animation<double> micRotationFirst;
  late Animation<double> micTranslateRight;
  late Animation<double> micTranslateLeft;
  late Animation<double> micRotationSecond;
  late Animation<double> micTranslateDown;
  late Animation<double> micInsideTrashTranslateDown;
  late Animation<double> trashWithCoverTranslateTop;
  late Animation<double> trashCoverRotationFirst;
  late Animation<double> trashCoverTranslateLeft;
  late Animation<double> trashCoverRotationSecond;
  late Animation<double> trashCoverTranslateRight;
  late Animation<double> trashWithCoverTranslateDown;
  AnimationController? _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animationController!.forward();
    //Mic
    // Add status listener to reset the animation after completion
    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<ChatInputBloc>().add(ResetRecording());
        _animationController!.reset(); // Reset animation
        if (kDebugMode) {
          print(
              'check state of animation here   ${widget.state.cancelRecording}');
        }
      }
    });

    micTranslateTop = Tween(begin: 0.0, end: -150.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    micTranslateRight = Tween(begin: 0.0, end: -150.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    micRotationFirst = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.0, 0.2),
      ),
    );

    micTranslateRight = Tween(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.0, 0.1),
      ),
    );

    micTranslateLeft = Tween(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.1, 0.2),
      ),
    );

    micRotationSecond = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.2, 0.45),
      ),
    );

    micTranslateDown = Tween(begin: 0.0, end: 150.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.45, 0.79, curve: Curves.easeInOut),
      ),
    );

    micInsideTrashTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    trashWithCoverTranslateTop = Tween(begin: 30.0, end: -10.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.45, 0.6),
      ),
    );

    trashCoverRotationFirst = Tween(begin: 0.0, end: -pi / 3).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.6, 0.7),
      ),
    );

    trashCoverTranslateLeft = Tween(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.6, 0.7),
      ),
    );

    trashCoverRotationSecond = Tween(begin: 0.0, end: pi / 3).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.8, 0.9),
      ),
    );

    trashCoverTranslateRight = Tween(begin: 0.0, end: 18.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.8, 0.9),
      ),
    );

    trashWithCoverTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatInputBloc, ChatInputState>(
      builder: (context, state) {
        return animationUi(context, state);
      },
    );
  }

  Widget animationUi(BuildContext context, ChatInputState state) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: _animationController!,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, 10)
                    ..translate(micTranslateRight.value)
                    ..translate(micTranslateLeft.value)
                    ..translate(0.0, micTranslateTop.value)
                    ..translate(0.0, micTranslateDown.value)
                    ..translate(0.0, micInsideTrashTranslateDown.value),
                  child: Transform.rotate(
                    angle: micRotationFirst.value,
                    child: Transform.rotate(
                      angle: micRotationSecond.value,
                      child: child,
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.mic,
                color: Color(0xFFef5552),
                size: 30,
              ),
            ),
            AnimatedBuilder(
              animation: trashWithCoverTranslateTop,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(0.0, trashWithCoverTranslateTop.value)
                    ..translate(0.0, trashWithCoverTranslateDown.value),
                  child: child,
                );
              },
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: trashCoverRotationFirst,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..translate(trashCoverTranslateLeft.value)
                          ..translate(trashCoverTranslateRight.value),
                        child: Transform.rotate(
                          angle: trashCoverRotationSecond.value,
                          child: Transform.rotate(
                            angle: trashCoverRotationFirst.value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: const Image(
                      image: AssetImage('assets/images/trash_cover.png'),
                      width: 30,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 1.5),
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
