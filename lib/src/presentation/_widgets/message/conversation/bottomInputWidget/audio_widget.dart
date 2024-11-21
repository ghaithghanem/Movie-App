import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cubit/message/conversations/chat_input/chat_input_bloc.dart';

class AudioWidget extends StatefulWidget {
  final ChatInputState state;
  const AudioWidget({super.key, required this.state});

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget>
    with TickerProviderStateMixin {
  Animation? _animation;
  double _dragOffset = 0.0;
  final double _maxDragDistance = 100.0;
  double marginBack = 38.0;
  double marginText = 36.0;
  AnimationController? _animationController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and Animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _animationController!.forward();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController!.repeat(reverse: true);

    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
    if (widget.state.isRecording) {
      _startTimer(widget.state.recordDuration);
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatInputBloc, ChatInputState>(
      builder: (context, state) {
        return audioBox(context, state);
      },
    );
  }

  Widget audioBox(BuildContext context, ChatInputState state) {
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
                _formatDuration(
                    state.recordDuration), // Use the state's record duration
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          state.isRecording
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
                      context.read<ChatInputBloc>().add(CancelRecording());
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
              : const SizedBox.shrink(),
          SizedBox(width: marginText),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _startTimer(int newDuration) {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      newDuration += 1; // Increment seconds
      context.read<ChatInputBloc>().add(UpdateRecordingDuration(newDuration));
    });
  }
}
