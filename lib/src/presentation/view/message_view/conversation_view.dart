import 'dart:async';
import 'dart:io';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/src/core/network/socketservice.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../main.dart';
import '../../../core/components/buttons/retry_button.dart';
import '../../../core/components/indicator/base_indicator.dart';
import '../../../core/database/hive.dart';
import '../../../core/theme/colors/my_colors.dart';
import '../../../domain/entities/export_entities.dart';
import '../../_widgets/message/conversation/bottom_input_widget.dart';
import '../../_widgets/shimmer/shimmer_loader.dart';
import '../../cubit/message/conversations/conversations_bloc.dart';
import '../../cubit/message/get_message/get_message_cubit.dart';

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
    final userId = await hiveService.getUserId();
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
      Future<void> scrollDown() async {
        await Future.delayed(Duration(milliseconds: 300));
        final double end = scrollController.position.maxScrollExtent;
        scrollController.jumpTo(end);
        print('Scroll down executed');
      }

      Future<void> _initConversation() async {
        try {
          final fetchedUserId = await _getUserId(hiveService);
          userId.value = fetchedUserId;
          final fetchUsirId2 = messageDetail?.sender?.id ?? '';
          final bool isSender = messageDetail?.isSender ?? false;
          if (fetchUsirId2 == fetchedUserId) {
            userId2.value = messageDetail?.receiver?.id ?? '';
          } else {
            userId2.value = messageDetail?.sender?.id ?? '';
          }

          context
              .read<ConversationsBloc>()
              .add(LoadConversationEvent(userId.value, userId2.value));

          isLoading.value = false;
        } catch (e) {
          print('Error fetching conversation: $e');
          isLoading.value = false;
        }
      }

      _initConversation();
      scrollDown();
      return null; // No cleanup needed
    }, [messageDetail]);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ConversationAppbarWidget(messageDetail: messageDetail),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/space_backG.jpg',
              fit: BoxFit.cover,
            ),
          ),
          isLoading.value
              ? Center(child: CircularProgressIndicator())
              : BlocBuilder<ConversationsBloc, ConversationsState>(
                  builder: (context, state) {
                    if (state is MessageError) {
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
                    } else if (state is GetConversationLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is GetConversationsLoaded) {
                      return Column(
                        children: [
                          Expanded(
                            child: _ConversationWidget(
                              whenScrollTop: () async {
                                context.read<ConversationsBloc>().add(
                                    LoadNextPageEvent(
                                        userId.value, userId2.value));
                              },
                              messages: state.conversationMessages,
                              hasReachedMax: context
                                  .watch<ConversationsBloc>()
                                  .hasReachedMax,
                              scrollController: scrollController,
                            ),
                          ),
                          BottomInputWidget(
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
                      /*return Center(child: Text('Unexpected state: $state')); */
                      return Column(
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
                                child: messagesShimmer(),
                              ),
                            ),
                          ),
                          BottomInputWidget(
                            width: width,
                            height: height,
                            textFieldFocusNode: textFieldFocusNode,
                            senderId: userId.value,
                            receiverId: userId2.value,
                            scrollController: scrollController,
                          ),
                        ],
                      );

                      /*BaseIndicator();*/
                    }
                  },
                ),
        ],
      ),
    );
  }
}
