import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:movie_app/src/core/network/socketservice.dart';

import '../../../../main.dart';
import '../../../core/database/hive.dart';
import '../../../domain/entities/export_entities.dart';
import '../../cubit/message/get_message/get_message_cubit.dart';

class MessageListFormWidget extends StatelessWidget {
  const MessageListFormWidget({super.key, this.message, this.hasRadius = true});

  final MessageEntity? message;
  final bool hasRadius;

  @override
  Widget build(BuildContext context) {
    final socketService = injector<SocketService>();
    final hiveService = injector<HiveService>();

    return BlocBuilder<GetMessageCubit, GetMessageState>(
      builder: (context, state) {
        if (state is GetMessageError) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Text('Error: ${state.message}'),
          );
        } else if (state is GetMessageLoaded) {
          final updatedMessage = state.generalMessages.firstWhere(
            (msg) => msg.id == message?.id,
            orElse: () => message!,
          );

          final savedId = hiveService.getUserId();

          final bool isSender = updatedMessage.sender?.id == savedId;

          final profilePhoto = isSender
              ? updatedMessage.receiver?.profilePhoto
              : updatedMessage.sender?.profilePhoto;
          final firstName = isSender
              ? updatedMessage.receiver?.firstName
              : updatedMessage.sender?.firstName;
          final lastName = isSender
              ? updatedMessage.receiver?.lastName
              : updatedMessage.sender?.lastName;
          final status = updatedMessage.status;
          final userId = isSender
              ? updatedMessage.receiver?.id
              : updatedMessage.sender?.id;
          final bool online = state.onlineStatuses[userId] ?? false;

          return Container(
            margin: const EdgeInsets.all(8),
            child: Row(
              children: [
                if (profilePhoto != null)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(profilePhoto),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: online ? Colors.green : Colors.grey,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$firstName $lastName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            if (isSender)
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'You: ${message?.message ?? ''}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              color: isSender || status == 2
                                                  ? Colors.grey
                                                  : Colors.black,
                                              fontWeight:
                                                  isSender || status == 2
                                                      ? FontWeight.normal
                                                      : FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    if (isSender && status == 2)
                                      Image.asset(
                                        'assets/images/vu.png',
                                        width: 20,
                                        height: 20,
                                      )
                                    else
                                      Image.asset(
                                        'assets/images/notvu.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                  ],
                                ),
                              )
                            else
                              Expanded(
                                child: Text(
                                  message?.message ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: isSender || status == 2
                                            ? Colors.grey
                                            : Colors.black,
                                        fontWeight: isSender || status == 2
                                            ? FontWeight.normal
                                            : FontWeight.bold,
                                      ),
                                ),
                              ),
                            SizedBox(width: 10),
                            Text(
                              message?.timestamp != null
                                  ? DateFormat('HH:mm')
                                      .format(message!.timestamp!)
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.normal,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }
}
