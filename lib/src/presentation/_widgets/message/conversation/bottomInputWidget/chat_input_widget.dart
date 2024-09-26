import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cubit/message/conversations/chat_input/chat_input_bloc.dart';
import 'bottomsheet_widget.dart';

class ChatInputUI extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final FocusNode textFieldFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatInputBloc, ChatInputState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildTextInputUI(context, state),
            if (state.isEmojiPickerVisible) emojiSelect(),
          ],
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
          icon: Icon(Icons.emoji_emotions, color: Color(0xFF128C7E)),
          onPressed: () {
            // Toggle emoji picker
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
                  builder: (builder) => bottomSheet(),
                );
              },
              icon: Icon(Icons.attach_file, color: Color(0xFF128C7E)),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.camera_alt, color: Color(0xFF128C7E)),
            ),
            // Send button
            state.isSendButtonActive
                ? CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFF128C7E),
                    child: IconButton(
                      onPressed: () {
                        final chatInputBloc = context.read<ChatInputBloc>();
                        final messageText = _controller.text.trim();
                        const voiceMessagePath = null;

                        if (chatInputBloc.state.isSendButtonActive ||
                            messageText != null) {
                          chatInputBloc
                              .add(SendMessage(messageText, voiceMessagePath));
                          _controller.clear();
                        }
                      },
                      icon: Icon(Icons.send, color: Colors.white),
                    ),
                  )
                : CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFF128C7E),
                    child: IconButton(
                      onPressed: () {
                        // Add send message logic for recording or other actions
                      },
                      icon: Icon(Icons.mic, color: Color(0xFF128C7E)),
                    ),
                  ),
          ],
        ),
        contentPadding: EdgeInsets.all(5),
      ),
      onTap: () {
        textFieldFocusNode.requestFocus();
      },
    );
  }

  Widget emojiSelect() {
    return EmojiPicker(
      onEmojiSelected: (category, Emoji emoji) {
        _controller.text = _controller.text + emoji.emoji;
      },
    );
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
