import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubit/message/conversations/chat_input/chat_input_bloc.dart';
import '../../../../cubit/message/get_message/get_message_cubit.dart';
import 'audio_widget.dart';
import 'chat_input_widget.dart';
import 'mic_animation_widget.dart';

class ChatScreen extends StatefulWidget {
  final double width;
  final double height;
  final FocusNode textFieldFocusNode;
  final String senderId;
  final String receiverId;
  final ScrollController scrollController;

  const ChatScreen(
      {super.key,
      required this.width,
      required this.height,
      required this.textFieldFocusNode,
      required this.senderId,
      required this.receiverId,
      required this.scrollController}); // Add this parameter

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _micTranslateTop;
  late Animation<double> _micRotationFirst;
  late Animation<double> _micTranslateRight;
  late Animation<double> _micTranslateLeft;
  late Animation<double> _micRotationSecond;
  late Animation<double> _micTranslateDown;
  late Animation<double> _micInsideTrashTranslateDown;

  // Trash Can animations...
  late Animation<double> _trashWithCoverTranslateTop;
  late Animation<double> _trashCoverRotationFirst;
  late Animation<double> _trashCoverTranslateLeft;
  late Animation<double> _trashCoverRotationSecond;
  late Animation<double> _trashCoverTranslateRight;
  late Animation<double> _trashWithCoverTranslateDown;

  bool cancelRecording = false;
  bool isRecording = false;
  bool sendButton = false;

  Future<void> scrollDown() async {
    await Future.delayed(Duration(milliseconds: 300));
    final double end = widget.scrollController.position.maxScrollExtent;
    widget.scrollController.jumpTo(end);
    print('Scroll down executed');
  }

  Future<void> onFieldSubmitted() async {
    // Move the scroll position to the bottom
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _sendMessage({String? voiceMessagePath}) async {
    final message = _controller.text.trim();
    print('Voice message path heeeeer: $voiceMessagePath');
    await context.read<GetMessageCubit>().sendMessage(
          widget.senderId,
          widget.receiverId,
          message.isNotEmpty ? message : null,
          voiceMessagePath,
        );

    _controller.clear();
    onFieldSubmitted();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatInputBloc(),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Stack(
          children: [
            if (cancelRecording)
              MicAnimationWidget(
                animationController: _animationController,
                micTranslateTop: _micTranslateTop,
                micRotationFirst: _micRotationFirst,
                micTranslateRight: _micTranslateRight,
                micTranslateLeft: _micTranslateLeft,
                micRotationSecond: _micRotationSecond,
                micTranslateDown: _micTranslateDown,
                micInsideTrashTranslateDown: _micInsideTrashTranslateDown,
                trashWithCoverTranslateTop: _trashWithCoverTranslateTop,
                trashCoverRotationFirst: _trashCoverRotationFirst,
                trashCoverTranslateLeft: _trashCoverTranslateLeft,
                trashCoverRotationSecond: _trashCoverRotationSecond,
                trashCoverTranslateRight: _trashCoverTranslateRight,
                trashWithCoverTranslateDown: _trashWithCoverTranslateDown,
              )
            else
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: Card(
                          margin: EdgeInsets.only(
                              left: 18, right: 2, bottom: 25, top: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: isRecording
                              ? AudioWidget() // Show recording UI if recording
                              : ChatInputUI(),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 25, right: 5, top: 10),
                          child: GestureDetector(
                            onTap: () {
                              if (sendButton) {
                                _sendMessage();
                              } else {
                                if (isRecording) {
                                  setState(() {
                                    _stopRecording();
                                    showLockUi =
                                        false; // Hide lock UI when recording stops
                                  });
                                } else {
                                  setState(() {
                                    _startRecording();
                                    showLockUi =
                                        false; // Reset lock UI initially
                                  });
                                }
                              }
                            },
                            onLongPressStart: (_) {
                              HapticFeedback.mediumImpact();
                              setState(() {
                                isRecording = true;
                                _startRecording(); // Start recording
                                // Start timer for lock UI
                                timerStream = stopWatchStream();
                                timerSubscription =
                                    timerStream?.listen((int newTick) {
                                  setState(() {
                                    minutesStr = ((newTick / 60) % 60)
                                        .floor()
                                        .toString()
                                        .padLeft(2, '0');
                                    secondsStr = (newTick % 60)
                                        .floor()
                                        .toString()
                                        .padLeft(2, '0');
                                    if (secondsStr == '03') {
                                      showLockUi =
                                          true; // Show lock UI after 3 seconds
                                    }
                                  });
                                });
                              });
                            },
                            onLongPressMoveUpdate: (details) {
                              // Hide lock UI when user swipes past a certain point
                              if (details.globalPosition.dy <
                                  MediaQuery.of(context).size.height - 150) {
                                setState(() {
                                  longRecording = true;
                                  showLockUi = false; // Hide lock UI on swipe
                                });
                              }
                            },
                            onLongPressEnd: (_) {
                              HapticFeedback.lightImpact();
                              if (isRecording && !longRecording) {
                                setState(() {
                                  isRecording = false;
                                  showLockUi =
                                      false; // Hide lock UI when recording stops
                                });
                                _stopRecording();
                              }
                            },
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFF128C7E),
                              child: Icon(
                                sendButton ? Icons.send : Icons.mic,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  show ? emojiSelect() : Container(),
                ],
              ),
            showLockUi
                ? Positioned(
                    left: MediaQuery.of(context).size.width - 62,
                    top: MediaQuery.of(context).size.height - 200,
                    child: Container(
                      height: 100, // Customize height as needed
                      width: 54,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        color: Colors.black38,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.lock, color: Colors.white),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
