import 'dart:async';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cubit/message/get_message/get_message_cubit.dart';

class BottomIN extends StatefulWidget {
  final double width;
  final double height;
  final FocusNode textFieldFocusNode;
  final String senderId;
  final String receiverId;
  final ScrollController scrollController; // Add this parameter

  const BottomIN({
    Key? key,
    required this.height,
    required this.width,
    required this.textFieldFocusNode,
    required this.senderId,
    required this.receiverId,
    required this.scrollController,
// Add this parameter
  }) : super(key: key);

  @override
  _BottomINState createState() => _BottomINState();
}

class _BottomINState extends State<BottomIN> with TickerProviderStateMixin {
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
  double _size = 50.0;
  bool expand = false;
  bool shouldActivate = false;
  double oldX = 0;
  double oldY = 0;
  int scount = 0;
  double vheight = 200.0;
  FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
  bool _mRecorderIsInited = false;
  bool showLockUi = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );
    _animationController!.forward();
    //Mic

    _micTranslateTop = Tween(begin: 0.0, end: -150.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _micRotationFirst = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.0, 0.2),
      ),
    );

    _micTranslateRight = Tween(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.0, 0.1),
      ),
    );

    _micTranslateLeft = Tween(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.1, 0.2),
      ),
    );

    _micRotationSecond = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.2, 0.45),
      ),
    );

    _micTranslateDown = Tween(begin: 0.0, end: 150.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.45, 0.79, curve: Curves.easeInOut),
      ),
    );

    _micInsideTrashTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    //Trash Can

    _trashWithCoverTranslateTop = Tween(begin: 30.0, end: -25.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.45, 0.6),
      ),
    );

    _trashCoverRotationFirst = Tween(begin: 0.0, end: -pi / 3).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.6, 0.7),
      ),
    );

    _trashCoverTranslateLeft = Tween(begin: 0.0, end: -18.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.6, 0.7),
      ),
    );

    _trashCoverRotationSecond = Tween(begin: 0.0, end: pi / 3).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.8, 0.9),
      ),
    );

    _trashCoverTranslateRight = Tween(begin: 0.0, end: 18.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.8, 0.9),
      ),
    );

    _trashWithCoverTranslateDown = Tween(begin: 0.0, end: 55.0).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Interval(0.95, 1.0, curve: Curves.easeInOut),
      ),
    );

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000),
    );
    _recordController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _recordController!.repeat(reverse: true);

    _animation = Tween(begin: 1.0, end: 0.0).animate(_recordController!)
      ..addListener(() {
        setState(() {});
      });
    this.position = Offset(widget.width - 60, widget.height - 54);
    this.oldX = widget.width - 60;
    this.oldY = widget.height - 54;
    // Audio settings
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });

    super.initState();
  }

  void _updateSize() {
    setState(() {
      _size = expand ? 50.0 : 80.0;
      position = expand ? Offset(oldX, oldY) : Offset(oldX - 15, oldY - 15);
      expand = !expand;
      shouldActivate = !shouldActivate;
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _recordController?.dispose();
    this._recordController = null;
    _myRecorder.closeRecorder();
    super.dispose();
  }

  Stream<int> stopWatchStream() {
    late StreamController<int> streamController; // Mark as `late`
    Timer? timer;
    Duration timerInterval = Duration(seconds: 1);
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
    _mRecorderIsInited = true;
  }

  void _startRecording() {
    setState(() {
      isRecording = true;
      _recordDuration = 0;
      _startTimer();
    });
  }

  void _sendvoiceMsg() async {
    final String? recordedFilePath = await _myRecorder.stopRecorder();
    await _sendMessage(voiceMessagePath: recordedFilePath);
  }

  void _stopRecording() async {
    await _myRecorder.stopRecorder();
    setState(() {
      isRecording = false;
      _timer?.cancel(); // Stop the timer
    });
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

  void scrollUp() {
    final double start = 0;
    widget.scrollController.animateTo(
      start,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _sendMessage({String? voiceMessagePath}) async {
    final message = _controller.text.trim();

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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    child: Card(
                      margin: EdgeInsets.only(left: 18, right: 2, bottom: 25),
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
                      padding: const EdgeInsets.only(bottom: 25, right: 5),
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
        if (value.length > 0) {
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
          icon: Icon(Icons.emoji_emotions, color: Color(0xFF128C7E)),
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
                icon: Icon(Icons.attach_file, color: Color(0xFF128C7E))),
            IconButton(
                onPressed: () {},
                icon: Icon(
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
                    icon: Icon(Icons.arrow_downward),
                  ),
                ),
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.all(5),
      ),
      onTap: () {
        widget.textFieldFocusNode.requestFocus();
      },
    );
  }

  Widget _buildRecordingUI() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          const Icon(Icons.mic, color: Colors.redAccent),
          const SizedBox(width: 10),
          Text(
            _formatDuration(_recordDuration),
            style: const TextStyle(color: Colors.grey),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.redAccent),
            onPressed: _stopRecording, // Stop recording
          ),
        ],
      ),
    );
  }

  Widget audioBox() {
    return Container(
      margin: EdgeInsets.only(right: marginBack, left: 8.0, bottom: 4.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30.0),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(51, 51, 51, 0.6),
                blurRadius: 0.0,
                offset: Offset(0, 0))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AnimatedOpacity(
            opacity: _animation!.value,
            duration: Duration(milliseconds: 100),
            child: Material(
                color: Colors.transparent,
                child: InkWell(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(Icons.mic, color: Colors.red)),
                    onTap: () {})),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 48,
              alignment: Alignment.centerLeft,
              child: Text(_formatDuration(_recordDuration),
                  style: const TextStyle(color: Colors.grey)),
            ),
          ),
          isRecording
              ? GestureDetector(
                  onTap: () {
                    if (isRecording) {
                      _stopRecording();
                    }
                    //_resetUi();
                    //_resetTimer();
                  },
                  child: Text("Cancel", textAlign: TextAlign.center))
              : Shimmer.fromColors(
                  direction: ShimmerDirection.rtl,
                  child: Text(
                    "Swipe to cancel",
                    textAlign: TextAlign.center,
                  ),
                  baseColor: Colors.red,
                  highlightColor: Colors.yellow),
          SizedBox(width: marginText),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: ScreenUtil().setSp(238),
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(18),
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
          SizedBox(
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
    return EmojiPicker(onEmojiSelected: (emoji, category) {
      setState(() {
        //_controller.text = _controller.text + emoji?.emoji;
      });
    });
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
              child: Icon(
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
                )),
          ],
        ),
      ),
    );
  }
}
