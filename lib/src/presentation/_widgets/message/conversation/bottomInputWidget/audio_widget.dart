import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cubit/message/conversations/chat_input/chat_input_bloc.dart';

class AudioWidget extends StatefulWidget {
  const AudioWidget({super.key});

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  Animation? _animation;
  int _recordDuration = 0;
  bool isRecording = false;
  bool cancelRecording = false;
  double _dragOffset = 0.0;
  final double _maxDragDistance = 100.0;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatInputBloc, ChatInputState>(
      builder: (context, state) {
        return audioBox(context, state);
      },
    );
  }

  Widget audioBox(BuildContext context, ChatInputState state) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        context
            .read<ChatInputBloc>()
            .add(DragUpdateEvent(state.dragOffset + details.delta.dx));
      },
      onHorizontalDragEnd: (details) {
        if (state.dragOffset.abs() > _maxDragDistance / 2) {
          cancelRecording = true;
          _cancelRecording();
        } else {
          _stopRecording();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 4.0),
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
              opacity: _animation?.value ?? 1.0,
              duration: const Duration(milliseconds: 100),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: const Icon(Icons.mic, color: Colors.red),
                  onTap: () {
                    _startRecording();
                  },
                ),
              ),
            ),
            Expanded(
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
                    child: Transform.translate(
                      offset: Offset(state.dragOffset, 0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.red,
                        highlightColor: Colors.yellow,
                        child: const Text(
                          "Swipe to cancel",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Future<void> _startRecording() async {
    await _requestPermissions();
    // Initialize your recorder here (assuming _myRecorder is defined)
    // Start recording logic
    setState(() {
      isRecording = true;
      _recordDuration = 0;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _recordDuration++;
        });
      });
    });
  }

  Future<void> _stopRecording() async {
    // Logic to stop recording
    setState(() {
      isRecording = false;
      _timer?.cancel();
    });
  }

  Future<void> _cancelRecording() async {
    // Logic to handle canceling the recording
    setState(() {
      isRecording = false;
      _timer?.cancel();
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}
