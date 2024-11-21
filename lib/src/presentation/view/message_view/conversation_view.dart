import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/src/core/network/socketservice.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../main.dart';
import '../../../core/components/buttons/retry_button.dart';
import '../../../core/components/indicator/base_indicator.dart';
import '../../../core/database/hive.dart';
import '../../../domain/entities/export_entities.dart';
import '../../_widgets/message/conversation/bottomInputWidget/chat_input_widget.dart';
import '../../cubit/message/conversations/conversations_bloc.dart';

part '../../_widgets/message/conversation/conversation_appbar_widget.dart';
part '../../_widgets/message/conversation/conversation_form_widget.dart';
part '../../_widgets/message/conversation/conversation_widget.dart';

@RoutePage()
class ConversationView extends StatelessWidget {
  const ConversationView({
    super.key,
    required this.messageDetail,
    required this.heroTag,
  });

  final MessageEntity? messageDetail;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return _ConversationView(
      messageDetail: messageDetail,
      heroTag: heroTag,
    );
  }
}

class _ConversationView extends HookWidget {
  const _ConversationView({
    this.messageDetail,
    required this.heroTag,
  });

  final MessageEntity? messageDetail;
  final Object heroTag;

  Future<String> _getUserId(HiveService hiveService) async {
    final userId = hiveService.getUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User ID not found');
    }
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    final hiveService = injector<HiveService>();
    final socketService = injector<SocketService>();

    // Hooks to manage state
    final isLoading = useState(true);
    final userId = useState<String>('');
    final userId2 = useState<String>('');
    final textFieldFocusNode = useFocusNode();
    final scrollController = useScrollController();

    useEffect(() {
      final bloc = context.read<ConversationsBloc>();
      Future<void> initConversation() async {
        try {
          bloc.add(ResetConversationEvent());

          final fetchedUserId = await _getUserId(hiveService);
          userId.value = fetchedUserId;
          final fetchUsirId2 = messageDetail?.sender?.id ?? '';
          final bool isSender = messageDetail?.isSender ?? false;
          if (fetchUsirId2 == fetchedUserId) {
            userId2.value = messageDetail?.receiver?.id ?? '';
          } else {
            userId2.value = messageDetail?.sender?.id ?? '';
          }

          // Activate the conversation when entering
          bloc.add(ActivateConversationEvent());

          bloc.add(LoadConversationEvent(userId.value, userId2.value));
          bloc.setCurrentConversation(userId.value, userId2.value);

          isLoading.value = false;
        } catch (e) {
          print('Error fetching conversation: $e');
          isLoading.value = false;
        }
      }

      initConversation();

      // Cleanup when leaving the conversation
      return () {
        bloc.add(DeactivateConversationEvent());
      };
    }, [messageDetail]);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: ConversationAppbarWidget(messageDetail: messageDetail),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/space_backG.jpg',
              fit: BoxFit.cover,
            ),
          ),

          // Check if initial loading is ongoing
          isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : BlocBuilder<ConversationsBloc, ConversationsState>(
                  builder: (context, state) {
                    if (state is MessageError) {
                      // Display error message with retry button
                      if (kDebugMode) {
                        print("Error encountered: ${state.message}");
                      }
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: RetryButton(
                          text: state.message,
                          retryAction: () => context
                              .read<ConversationsBloc>()
                              .add(LoadConversationEvent(
                                  userId.value, userId2.value)),
                        ),
                      );
                    } else if (state is GetConversationsLoading) {
                      // Show loading indicator during initial loading
                      return const Center(child: BaseIndicator());
                    } else if (state is GetConversationsLoaded) {
                      // Messages loaded successfully
                      return Column(
                        children: [
                          Expanded(
                            child: _ConversationWidget(
                              messages: state.conversationMessages,
                              hasReachedMax: context
                                  .watch<ConversationsBloc>()
                                  .hasReachedMax,
                              scrollController: scrollController,
                              whenScrollTop: () async {
                                context.read<ConversationsBloc>().add(
                                    LoadConversationEvent(
                                        userId.value, userId2.value));
                              },
                            ),
                          ),
                          if (state is LoadingMoreMessages)
                            const Padding(
                              padding: EdgeInsets.all(12),
                              child: BaseIndicator(),
                            ),
                          ChatInputUI(
                            width: width,
                            height: height,
                            textFieldFocusNode: textFieldFocusNode,
                            senderId: userId.value,
                            receiverId: userId2.value,
                            scrollController: scrollController,
                          ),
                        ],
                      );
                    } else {
                      // Show BaseIndicator as fallback in unexpected states
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount:
                                  10, // Dummy item count for loading effect
                              itemBuilder: (_, index) =>
                                  const BaseIndicator(), // Replace shimmer with BaseIndicator
                            ),
                          ),
                          ChatInputUI(
                            width: width,
                            height: height,
                            textFieldFocusNode: textFieldFocusNode,
                            senderId: userId.value,
                            receiverId: userId2.value,
                            scrollController: scrollController,
                          ),
                        ],
                      );
                    }
                  },
                ),
        ],
      ),
    );
  }
}
/*
 Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (_, index) => Shimmer.fromColors(
                                period: const Duration(milliseconds: 1000),
                                baseColor: Theme.of(context)
                                    .highlightColor
                                    .withOpacity(0.5),
                                highlightColor:
                                    MyColors.backgroundGey.withOpacity(0.04),
                                enabled: true,
                                child: const messagesShimmer(),
                              ),
                            ),
                          ),
                          ChatInputUI(
                            width: width,
                            height: height,
                            textFieldFocusNode: textFieldFocusNode,
                            senderId: userId.value,
                            receiverId: userId2.value,
                            scrollController: scrollController,
                          ),
                        ],
                      );
  */
