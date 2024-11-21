import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubit/message/conversations/chat_input/chat_input_bloc.dart';
import '../../../../cubit/message/get_message/get_message_cubit.dart';
import 'audio_widget.dart';
import 'bottomsheet_widget.dart';
import 'mic_animation_widget.dart';

class ChatInputUI extends StatefulWidget {
  final double width;
  final double height;
  final FocusNode textFieldFocusNode;
  final String senderId;
  final String receiverId;
  final ScrollController scrollController;

  const ChatInputUI(
      {super.key,
      required this.width,
      required this.height,
      required this.textFieldFocusNode,
      required this.senderId,
      required this.receiverId,
      required this.scrollController});
  @override
  State<ChatInputUI> createState() => _ChatInputUIState();
}

class _ChatInputUIState extends State<ChatInputUI> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatInputBloc, ChatInputState>(
      listener: (context, state) {
        // Add any specific actions when state changes if necessary
        if (!state.cancelRecording && state.isRecording) {
          // Reset UI or perform actions when recording starts
        }
      },
      builder: (context, state) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: [
              state.cancelRecording
                  ? Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width - 50,
                                  child: Card(
                                    margin: const EdgeInsets.only(
                                        left: 18,
                                        right: 2,
                                        bottom: 25,
                                        top: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    child: state.cancelRecording
                                        ? _buildTextOfAnimation()
                                        : _buildTextOfAnimation(),
                                  ),
                                ),
                                _buildButtonInputUI(context, state),
                              ],
                            ),
                            if (state.isEmojiPickerVisible) emojiSelect(),
                          ],
                        ),
                        MicAnimationWidget(state: state),
                      ],
                    )
                  : Column(
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
                                child: state.isRecording
                                    ? AudioWidget(state: state)
                                    : _buildTextInputUI(context, state),
                              ),
                            ),
                            _buildButtonInputUI(context, state),
                          ],
                        ),
                        if (state.isEmojiPickerVisible) emojiSelect(),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextInputUI(BuildContext context, ChatInputState state) {
    return TextFormField(
      focusNode: textFieldFocusNode,
      controller: _controller,
      textAlignVertical: TextAlignVertical.center,
      keyboardType: TextInputType.multiline,
      maxLines: 5,
      minLines: 1,
      onChanged: (value) {
        // Dispatch event when text changes
        context.read<ChatInputBloc>().add(TextChanged(value));
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: "Type a message ...",
        prefixIcon: IconButton(
          icon: const Icon(Icons.emoji_emotions, color: Color(0xFF128C7E)),
          onPressed: () {
            context.read<ChatInputBloc>().add(ToggleEmojiPicker());
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
                  builder: (builder) => const bottomSheet(),
                );
              },
              icon: const Icon(Icons.attach_file, color: Color(0xFF128C7E)),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.camera_alt, color: Color(0xFF128C7E)),
            ),
            // Send button
          ],
        ),
        contentPadding: const EdgeInsets.all(5),
      ),
      onTap: () {
        textFieldFocusNode.requestFocus();
      },
    );
  }

  Widget _buildButtonInputUI(BuildContext context, ChatInputState state) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25, right: 5, top: 10),
        child: GestureDetector(
          onTap: () {},
          onLongPressStart: (_) {},
          onLongPressMoveUpdate: (details) {},
          onLongPressEnd: (_) {},
          child: state.isSendButtonActive
              ? CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFF128C7E),
                  child: IconButton(
                    onPressed: () {
                      final chatInputBloc = context.read<ChatInputBloc>();
                      final messageText = _controller.text.trim();
                      const voiceMessagePath = null;

                      if (chatInputBloc.state.isSendButtonActive) {
                        /*  chatInputBloc
                              .add(SendMessage(messageText, voiceMessagePath)); */
                        _sendMessage();
                        _controller.clear();
                      }
                    },
                    icon: const Icon(Icons.send, color: Colors.white),
                  ),
                )
              : CircleAvatar(
                  radius: 25,
                  backgroundColor: const Color(0xFF128C7E),
                  child: BlocBuilder<ChatInputBloc, ChatInputState>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          if (state.isRecording) {
                            // Stop recording when already recording
                            context.read<ChatInputBloc>().add(StopRecording(
                                  senderId: widget.senderId,
                                  receiverId: widget.receiverId,
                                ));
                          } else {
                            // Start recording when not recording
                            context.read<ChatInputBloc>().add(StartRecording());
                          }
                        },
                        icon: Icon(
                          state.isRecording
                              ? Icons.stop
                              : Icons.mic, // Change icon based on state
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
      onEmojiSelected: (category, Emoji emoji) {
        _controller.text = _controller.text + emoji.emoji;
      },
    );
  }

  Widget _buildTextOfAnimation() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: TextFormField(
            focusNode: textFieldFocusNode,
            controller: _controller,
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            minLines: 1,
            onChanged: (value) {
              // Dispatch event when text changes
              context.read<ChatInputBloc>().add(TextChanged(value));
            },
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "",
              contentPadding: EdgeInsets.all(5),
            ),
            onTap: () {
              textFieldFocusNode.requestFocus();
            },
          )),
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
  }
}

/*
class ChatScreen extends StatelessWidget {
  final String senderId;
  final String receiverId;

  ChatScreen({required this.senderId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatInputBloc(
        senderId,
        receiverId,
        context.read<GetMessageCubit>(),  // Assuming GetMessageCubit is already provided higher in the tree
      ),
      child: ChatInputUI(),
    );
  }
}

 */
