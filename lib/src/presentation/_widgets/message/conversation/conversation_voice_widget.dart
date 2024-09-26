import 'dart:async';

import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

class VoiceMessageWidget extends StatefulWidget {
  const VoiceMessageWidget({Key? key}) : super(key: key);

  @override
  State<VoiceMessageWidget> createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  Timer? _timer;
  int _recordDuration = 0;

  void _startRecording() {
    setState(() {
      _recordDuration = 0;
      _startTimer();
    });
  }

  void _stopRecording() {
    setState(() {
      _timer?.cancel();

      /// Handle recording completion and voice message logic
      /// For example, save the voice recording and reset the state
    });
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

  @override
  Widget build(BuildContext context) {
    return VoiceMessageView(
      controller: VoiceController(
        audioSrc:
            'https://dl.solahangs.com/Music/1403/02/H/128/Hiphopologist%20-%20Shakkak%20%28128%29.mp3',
        onComplete: () {
          // Handle completion
        },
        onPause: () {
          // Handle pause
        },
        onPlaying: () {
          _startRecording();
        },
        onError: (err) {
          // Handle error
          print('Error: $err');
        },
        maxDuration: const Duration(seconds: 10),
        isFile: false,
      ),
      innerPadding: 12,
      cornerRadius: 20,
    );
  }
}
