part of '../../../view/message_view/conversation_view.dart';

class ConversationFormWidget extends StatefulWidget {
  const ConversationFormWidget(
      {super.key,
      required this.message,
      required this.currentUserId,
      this.width,
      this.index});
  final MessageEntity message;
  final String currentUserId;
  final double? width;
  final int? index;
  @override
  State<ConversationFormWidget> createState() => _ConversationFormWidgetState();
}

class _ConversationFormWidgetState extends State<ConversationFormWidget> {
  PlayerController _waveformController = PlayerController();
  late final RecorderController recorderController;
  bool isPlayAudio = false;
  String? path;
  String? musicFile;
  bool isRecording = false;
  bool isRecordingCompleted = false;

  List<double>? _waveformData;
  late Directory appDirectory;

  File? file;
  late StreamSubscription<PlayerState> playerStateSubscription;
  final playerWaveStyle = const PlayerWaveStyle(
    fixedWaveColor: Colors.grey,
    liveWaveColor: Colors.blueAccent,
    spacing: 6,
  );
  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  Future<void> _getfile() async {
    path = widget.message.voiceMessageId;

    if (path != null && Uri.parse(path!).isAbsolute) {
      print("path voice msg $path");
      try {
        // Download the file locally
        Directory tempDir = await getTemporaryDirectory();
        String localPath = "${tempDir.path}/audio.m4a";

        await Dio().download(path!, localPath); // Download the audio file
        file = File(localPath); // Save file reference

        // After download, prepare the player with the local file
        _preparePlayer();
      } catch (e) {
        print("Error loading audio: $e");
      }
    }
  }

  void _preparePlayer() async {
    if (file?.path == null) {
      print('File path is null');
      return;
    }

    try {
      /// Prepare the player with the local path
      await _waveformController.preparePlayer(
        path: file!.path, // Use the local file path
        shouldExtractWaveform: widget.index?.isEven ?? true,
      );

      /// Optionally extract waveform data if needed
      await _waveformController.extractWaveformData(
          path: file!.path,
          noOfSamples: playerWaveStyle.getSamplesForWidth(widget.width ?? 200));
    } catch (e) {
      print('Error preparing player: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initialiseControllers();
    _waveformController = PlayerController();
    _preparePlayer();
    playerStateSubscription =
        _waveformController.onPlayerStateChanged.listen((_) {
      setState(() {});
    });
    _getfile();
  }

  @override
  void dispose() {
    //_audioPlayer.dispose();
    recorderController.dispose();
    playerStateSubscription.cancel();
    _waveformController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hiveService = injector<HiveService>();
    final savedId = hiveService.getUserId();
    final isSender = widget.message.sender?.id == savedId;
    print("test idddd ${savedId}");
    return ChatBubble(
      clipper: ChatBubbleClipper1(
        type: isSender ? BubbleType.sendBubble : BubbleType.receiverBubble,
      ),
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      margin: const EdgeInsets.only(top: 20),
      backGroundColor: isSender ? Colors.teal : Colors.grey[200],
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (path != null || file?.path != null)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_waveformController.playerState.isStopped)
                    IconButton(
                      onPressed: () async {
                        _waveformController.playerState.isPlaying
                            ? await _waveformController.pausePlayer()
                            : await _waveformController.startPlayer(
                                finishMode: FinishMode.loop);
                      },
                      icon: Icon(_waveformController.playerState.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow),
                      color: Colors.black,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                  AudioFileWaveforms(
                    size: Size(MediaQuery.of(context).size.width / 2, 70),
                    playerController: _waveformController,
                    waveformType: widget.index?.isOdd ?? false
                        ? WaveformType.fitWidth
                        : WaveformType.long,
                    playerWaveStyle: playerWaveStyle,
                  )
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  widget.message.message ?? '',
                  style: TextStyle(
                    color: isSender ? Colors.white : Colors.black,
                  ),
                ),
              ),
            const SizedBox(height: 5),
            Text(
              widget.message.timestamp != null
                  ? DateFormat('HH:mm').format(widget.message.timestamp!)
                  : '',
              style: TextStyle(
                color: isSender ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
