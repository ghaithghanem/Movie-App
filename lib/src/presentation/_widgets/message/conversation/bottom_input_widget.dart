import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cubit/message/get_message/get_message_cubit.dart';

class BottomInputWidget extends StatefulWidget {
  final double width;
  final double height;
  final FocusNode textFieldFocusNode;
  final String senderId;
  final String receiverId;
  final ScrollController scrollController; // Add this parameter

  const BottomInputWidget({
    super.key,
    required this.height,
    required this.width,
    required this.textFieldFocusNode,
    required this.senderId,
    required this.receiverId,
    required this.scrollController,
// Add this parameter
  });

  @override
  _BottomInputAreaState createState() => _BottomInputAreaState();
}

class _BottomInputAreaState extends State<BottomInputWidget>
    with TickerProviderStateMixin {
  final FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
  final TextEditingController _controller = TextEditingController();
  //Mic
  late Animation<double> _micTranslateTop;
  late Animation<double> _micRotationFirst;
  late Animation<double> _micTranslateRight;
  late Animation<double> _micTranslateLeft;
  late Animation<double> _micRotationSecond;
  late Animation<double> _micTranslateDown;
  late Animation<double> _micInsideTrashTranslateDown;

  //Trash Can
  late Animation<double> _trashWithCoverTranslateTop;
  late Animation<double> _trashCoverRotationFirst;
  late Animation<double> _trashCoverTranslateLeft;
  late Animation<double> _trashCoverRotationSecond;
  late Animation<double> _trashCoverTranslateRight;
  late Animation<double> _trashWithCoverTranslateDown;

  bool show = false;
  bool sendButton = false;
  bool showVoiceMessage = false;
  bool cancelRecording = false;
  //FocusNode focusNode = FocusNode();
  AnimationController? _recordController;
  bool isRecording = false;
  Timer? _timer;
  int _recordDuration = 0;
  AnimationController? _animationController;
  Animation? _animation;
  double marginBack = 38.0;
  double marginText = 36.0;
  String minutesStr = '00';
  String secondsStr = '00';
  int tcount = 10;
  var xs = Set();
  var ys = Set();
  int direction = -1;
  Offset? position;
  bool longRecording = false;
  bool flag = true;
  Stream<int>? timerStream;
  StreamSubscription<int>? timerSubscription;
  bool expand = false;
  bool shouldActivate = false;
  double oldX = 0;
  double oldY = 0;
  int scount = 0;
  double vheight = 200.0;

  bool showLockUi = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    _animationController!.forward();
    //Mic
    // Add status listener to reset the animation after completion
    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          cancelRecording = false; // Reset the flag after animation
          isRecording = false; // Reset recording state
        });
        _animationController!.reset(); // Reset animation
      }
    });
    _micTranslateTop = Tween(begin: 0.0, end: -150.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _micRotationFirst = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.0, 0.2),
      ),
    );

    _micTranslateRight = Tween(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.0, 0.1),
      ),
    );

    _micTranslateLeft = Tween(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.1, 0.2),
      ),
    );

    _micRotationSecond = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.2, 0.45),
      ),
    );

    _micTranslateDown = Tween(begin: 0.0, end: 150.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.45, 0.79, curve: Curves.easeInOut),
      ),
    );

    _micInsideTrashTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    //Trash Can

    _trashWithCoverTranslateTop = Tween(begin: 30.0, end: -25.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.45, 0.6),
      ),
    );

    _trashCoverRotationFirst = Tween(begin: 0.0, end: -pi / 3).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.6, 0.7),
      ),
    );

    _trashCoverTranslateLeft = Tween(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.6, 0.7),
      ),
    );

    _trashCoverRotationSecond = Tween(begin: 0.0, end: pi / 3).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.8, 0.9),
      ),
    );

    _trashCoverTranslateRight = Tween(begin: 0.0, end: 18.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.8, 0.9),
      ),
    );

    _trashWithCoverTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: const Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    _recordController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _recordController!.repeat(reverse: true);

    _animation = Tween(begin: 1.0, end: 0.0).animate(_recordController!)
      ..addListener(() {
        setState(() {});
      });
    position = Offset(widget.width - 60, widget.height - 54);
    oldX = widget.width - 60;
    oldY = widget.height - 54;
    // Audio settings
    openTheRecorder().then((value) {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _recordController?.dispose();
    _recordController = null;
    _myRecorder.closeRecorder();
    super.dispose();
  }

  Stream<int> stopWatchStream() {
    late StreamController<int> streamController; // Mark as `late`
    Timer? timer;
    Duration timerInterval = const Duration(seconds: 1);
    int counter = 0;

    void stopTimer() {
      timer?.cancel(); // Safely cancel the timer if it's not null
      timer = null;
      counter = 0;
      streamController.close(); // Now streamController is properly initialized
    }

    void tick(_) {
      counter++;
      streamController.add(counter); // Add to stream
      if (!flag) {
        stopTimer();
      }
    }

    void startTimer() {
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: stopTimer,
    );

    return streamController.stream;
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _myRecorder.openRecorder();
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/audio_record.m4a'; // Save in m4a or aac format
  }

  Future<void> _startRecording() async {
    // Request necessary permissions
    await _requestPermissions();

    if (!_myRecorder.isRecording) {
      await _myRecorder.openRecorder();
    }

    // Use internal app-specific directory to save the file
    final String filePath = await _getFilePath();

    // Record using AAC codec or other supported formats
    await _myRecorder.startRecorder(
      toFile: filePath,
      codec: Codec.aacMP4, // Recording as AAC
    );

    setState(() {
      isRecording = true;
      _recordDuration = 0;
      _startTimer(); // Start timer for tracking
    });

    if (kDebugMode) {
      print('Recording started, file path: $filePath');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final String? recordedFilePath = await _myRecorder.stopRecorder();

      if (recordedFilePath != null && File(recordedFilePath).existsSync()) {
        setState(() {
          isRecording = false;
          _timer?.cancel(); // Stop the timer
        });
        if (kDebugMode) {
          print('Recording stopped, file path: $recordedFilePath');
        }

        // Send the AAC/M4A file directly via sendMessage method
        await _sendMessage(voiceMessagePath: recordedFilePath);
      } else {
        if (kDebugMode) {
          print('No file was recorded or the file does not exist.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error while stopping the recording: $e');
      }
    }
  }

  void _cancelRecording() async {
    await _myRecorder.stopRecorder();
    setState(() {
      isRecording = false;
      _timer?.cancel(); // Stop the timer
      cancelRecording = true;
    });
    if (cancelRecording) {
      _animationController!.forward(); // Start the animation
    }
    // Reset the UI or handle recorded audio
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _recordDuration += 1;
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Future<void> scrollDown() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final double end = widget.scrollController.position.maxScrollExtent;
    widget.scrollController.jumpTo(end);
    if (kDebugMode) {
      print('Scroll down executed');
    }
  }

  Future<void> onFieldSubmitted() async {
    // Move the scroll position to the bottom
    widget.scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollUp() {
    const double start = 0;
    widget.scrollController.animateTo(
      start,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _sendMessage({String? voiceMessagePath}) async {
    final message = _controller.text.trim();
    if (kDebugMode) {
      print('Voice message path heeeeer: $voiceMessagePath');
    }
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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        children: [
          if (cancelRecording)
            _buildMicAnimation()
          else
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Card(
                        margin: const EdgeInsets.only(
                            left: 18, right: 2, bottom: 25, top: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: isRecording
                            ? audioBox() // Show recording UI if recording
                            : _buildTextInputUI(),
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
                                  showLockUi = false; // Reset lock UI initially
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
                            backgroundColor: const Color(0xFF128C7E),
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
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                      color: Colors.black38,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.lock, color: Colors.white),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextInputUI() {
    return TextFormField(
      focusNode: widget.textFieldFocusNode,
      controller: _controller,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      minLines: 1,
      onChanged: (value) {
        if (value.isNotEmpty) {
          setState(() {
            sendButton = true;
          });
        } else {
          setState(() {
            sendButton = false;
          });
        }
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: "Type a message ...",
        prefixIcon: IconButton(
          icon: const Icon(Icons.emoji_emotions, color: Color(0xFF128C7E)),
          onPressed: () {
            setState(() {
              setState(() {
                widget.textFieldFocusNode.unfocus();
                widget.textFieldFocusNode.canRequestFocus = false;
                show = !show;
              });
            });
          },
        ),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (builder) => bottomSheet());
                },
                icon: const Icon(Icons.attach_file, color: Color(0xFF128C7E))),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.camera_alt,
                  color: Color(0xFF128C7E),
                )),
            Flexible(
              child: Material(
                type: MaterialType.transparency,
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {
                      //scrollUp();
                      onFieldSubmitted();
                    },
                    icon: const Icon(Icons.arrow_downward),
                  ),
                ),
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.all(5),
      ),
      onTap: () {
        widget.textFieldFocusNode.requestFocus();
      },
    );
  }

  double _dragOffset = 0.0;
  final double _maxDragDistance = 100.0;
  Widget audioBox() {
    return Container(
      margin: EdgeInsets.only(right: marginBack, left: 8.0, bottom: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(51, 51, 51, 0.6),
            blurRadius: 0.0,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity: _animation!.value,
            duration: const Duration(milliseconds: 100),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: const Icon(Icons.mic, color: Colors.red),
                ),
                onTap: () {},
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 48,
              alignment: Alignment.centerLeft,
              child: Text(
                _formatDuration(_recordDuration),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          isRecording
              ? GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      // Update drag offset but limit it to the max drag distance
                      _dragOffset += details.delta.dx;
                      _dragOffset = _dragOffset.clamp(-_maxDragDistance, 0);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    // If dragged beyond half of the max distance, trigger the action
                    if (_dragOffset.abs() > _maxDragDistance / 2) {
                      cancelRecording = true;
                      _cancelRecording();
                    }
                    // Reset the drag offset after sliding
                    setState(() {
                      _dragOffset = 0;
                    });
                  },
                  child: Transform.translate(
                    offset: Offset(_dragOffset, 0), // Apply the sliding effect
                    child: Shimmer.fromColors(
                      direction: ShimmerDirection.rtl,
                      baseColor: Colors.red,
                      highlightColor: Colors.yellow,
                      child: const Text(
                        "Swipe to cancel",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      // Update drag offset but limit it to the max drag distance
                      _dragOffset += details.delta.dx;
                      _dragOffset = _dragOffset.clamp(-_maxDragDistance, 0);
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    // If dragged beyond half of the max distance, trigger the action
                    if (_dragOffset.abs() > _maxDragDistance / 2) {
                      cancelRecording = true;
                      _cancelRecording();
                    }
                    // Reset the drag offset after sliding
                    setState(() {
                      _dragOffset = 0;
                    });
                  },
                  child: Transform.translate(
                    offset: Offset(_dragOffset, 0), // Apply the sliding effect
                    child: Shimmer.fromColors(
                      direction: ShimmerDirection.rtl,
                      baseColor: Colors.red,
                      highlightColor: Colors.yellow,
                      child: const Text(
                        "Swipe to cancel",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
          SizedBox(width: marginText),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return SizedBox(
      height: ScreenUtil().setSp(238),
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: ScreenUtil().setSp(40),
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: ScreenUtil().setSp(40),
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: ScreenUtil().setSp(30),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: ScreenUtil().setSp(40),
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: ScreenUtil().setSp(40),
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icon, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: ScreenUtil().setSp(12),
              fontFamily: 'OpenSans',
            ),
          ),
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
      onEmojiSelected: (category, Emoji emoji) {
        setState(() {
          _controller.text = _controller.text + emoji.emoji;
        });
      },
    );
  }

  Widget _buildMicAnimation() {
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
                    ..translate(_micTranslateRight.value)
                    ..translate(_micTranslateLeft.value)
                    ..translate(0.0, _micTranslateTop.value)
                    ..translate(0.0, _micTranslateDown.value)
                    ..translate(0.0, _micInsideTrashTranslateDown.value),
                  child: Transform.rotate(
                    angle: _micRotationFirst.value,
                    child: Transform.rotate(
                      angle: _micRotationSecond.value,
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
                animation: _trashWithCoverTranslateTop,
                builder: (context, child) {
                  return Transform(
                    transform: Matrix4.identity()
                      ..translate(0.0, _trashWithCoverTranslateTop.value)
                      ..translate(0.0, _trashWithCoverTranslateDown.value),
                    child: child,
                  );
                },
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _trashCoverRotationFirst,
                      builder: (context, child) {
                        return Transform(
                          transform: Matrix4.identity()
                            ..translate(_trashCoverTranslateLeft.value)
                            ..translate(_trashCoverTranslateRight.value),
                          child: Transform.rotate(
                            angle: _trashCoverRotationSecond.value,
                            child: Transform.rotate(
                              angle: _trashCoverRotationFirst.value,
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
                )),
          ],
        ),
      ),
    );
  }
}
