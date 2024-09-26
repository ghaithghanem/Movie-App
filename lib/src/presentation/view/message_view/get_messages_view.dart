import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../main.dart';
import '../../../config/router/app_router.gr.dart';
import '../../../core/components/buttons/retry_button.dart';
import '../../../core/components/indicator/RefreshIndicator.dart';
import '../../../core/components/indicator/base_indicator.dart';
import '../../../core/database/hive.dart';
import '../../../core/network/socketservice.dart';
import '../../../core/theme/colors/my_colors.dart';
import '../../../domain/entities/export_entities.dart';
import '../../_widgets/message/message_filter.dart';
import '../../_widgets/message/message_list_form_widget.dart';
import '../../_widgets/message/msg_floatingButton_widget.dart';
import '../../_widgets/shimmer/shimmer_loader.dart';
import '../../cubit/message/get_message/get_message_cubit.dart';

part '../../_widgets/message/message_widget.dart';

@RoutePage()
class GetMessagesView extends HookWidget {
  const GetMessagesView({super.key});

  Future<String> _getUserId(HiveService hiveService) async {
    final userId = await hiveService.getUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User ID not found');
    }
    return userId;
  }

  @override
  Widget build(BuildContext context) {
    print("GetMessagesView build method called");
    final hiveService = injector<HiveService>();
    final socketService = injector<SocketService>();

    useEffect(() {
      print("useEffect getmessages");

      void init() async {
        print("init getmessages");

        try {
          final userId = await _getUserId(hiveService);
          final currentState = context.read<GetMessageCubit>().state;
          print("state $currentState ");
          if (currentState is GetMessageLoaded) {
            print("State messages: ${currentState.generalMessages.length}");
          } else if (currentState is GetMessageInitial ||
              currentState is GetMessageLoading) {
            print("fetch messages...");
            context.read<GetMessageCubit>().getMessages();
          }
          socketService.connect(userId, context);
        } catch (e) {
          print('Error initializing socket or fetching messages: $e');
        }
      }

      init();
      return () {};
    }, []);

    return Scaffold(
      floatingActionButton: MsgFloatingButtonWidget(),
      body: BlocBuilder<GetMessageCubit, GetMessageState>(
        builder: (context, getMessagesState) {
          print("GetMessagesView build method called 3");
          print("here $getMessagesState");
          if (getMessagesState is GetMessageError) {
            return Padding(
              padding: const EdgeInsets.all(12),
              child: RetryButton(
                text: getMessagesState.message,
                retryAction: () =>
                    context.read<GetMessageCubit>().getMessages(),
              ),
            );
          }

          if (getMessagesState is GetMessageLoading) {
            return ListView.builder(
              itemCount: 10, // Number of shimmer items to show
              itemBuilder: (_, index) => Shimmer.fromColors(
                period: const Duration(milliseconds: 1000),
                baseColor: Theme.of(context).highlightColor.withOpacity(0.5),
                highlightColor: MyColors.backgroundGey.withOpacity(0.04),
                enabled: true,
                child: messagesShimmer(),
              ),
            );
          } else if (getMessagesState is GetMessageLoaded) {
            return _MessageWidget(
              hasReachedMax: context.watch<GetMessageCubit>().hasReachedMax,
              message: getMessagesState.generalMessages,
              whenScrollBottom: () async =>
                  context.read<GetMessageCubit>().getMessages(),
              whenScrollTop: () async =>
                  context.read<GetMessageCubit>().getNewMessages(),
              isTopLoading: context.watch<GetMessageCubit>().isTopLoading,
            );
          } else {
            print("heeeeeeeeereeeee  $getMessagesState");
            return const Center(
              child: Text('No messages '),
            );
          }

          return const BaseIndicator();
        },
      ),
    );
  }
}
