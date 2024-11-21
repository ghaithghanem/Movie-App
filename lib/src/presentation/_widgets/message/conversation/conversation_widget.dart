part of '../../../view/message_view/conversation_view.dart';

class _ConversationWidget extends HookWidget {
  final List<MessageEntity> messages;
  final Future<void> Function() whenScrollTop;
  final bool hasReachedMax;
  final ScrollController scrollController;

  const _ConversationWidget({
    required this.messages,
    required this.whenScrollTop,
    required this.hasReachedMax,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final isLoadingMore = useState(false);

    // Listener for scroll events
    final listener = useMemoized(() => () async {
          // Check if the scroll has reached the top
          if (scrollController.position.pixels ==
                  scrollController.position.maxScrollExtent &&
              !hasReachedMax) {
            isLoadingMore.value = true;

            // Save the current scroll position
            final currentScrollOffset = scrollController.position.pixels;

            // Load older messages by calling whenScrollTop
            await whenScrollTop.call();

            // Restore the scroll position after loading more messages
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                scrollController.jumpTo(currentScrollOffset);
              }
            });

            isLoadingMore.value = false;
          }
        });

    useEffect(() {
      // Add the listener to the scroll controller
      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    }, [scrollController]);

    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      reverse: true,
      physics: const BouncingScrollPhysics(),
      itemCount: messages.length +
          (isLoadingMore.value ? 1 : 0), // Show loading indicator at the top
      itemBuilder: (_, index) {
        // Show loading indicator at the top
        if (index == messages.length) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Hero(
          tag:
              'conversation-hero-tag-${messages[index].id}', // Unique tag for each item
          child: ConversationFormWidget(
            index: index + 1,
            message: messages[index],
            currentUserId:
                "currentUserId", // Provide the actual current user ID
          ),
        );
      },
    );
  }
}

/*    final message = messages[messages.length - 1 - index];

        final message = messages[index];
        return ConversationFormWidget(
        message: message,
         key: ValueKey(message.id),
        currentUserId: currentUserId,
        );
        },
        childCount: messages.length + (hasReachedMax ? 0 : 1),
       findChildIndexCallback: (key) {
              final valueKey = key as ValueKey<String>;
              final val = messages.indexWhere((m) => m.id == valueKey.value);
              return val != -1 ? messages.length - 1 - val : null;
            }, */
