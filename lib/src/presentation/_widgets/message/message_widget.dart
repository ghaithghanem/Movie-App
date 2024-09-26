part of '../../view/message_view/get_messages_view.dart';

class _MessageWidget extends HookWidget {
  const _MessageWidget({
    required this.message,
    required this.whenScrollBottom,
    required this.hasReachedMax,
    required this.whenScrollTop,
    required this.isTopLoading,
  });

  final List<MessageEntity>? message;
  final Future<void> Function() whenScrollBottom;
  final bool hasReachedMax;
  final Future<void> Function() whenScrollTop;
  final bool isTopLoading;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    useAutomaticKeepAlive();
    final filteredMessages = useState<List<MessageEntity>?>(message);


    final listener = useMemoized(
          () => () async {
        final isBottom = scrollController.position.maxScrollExtent == scrollController.offset &&
            scrollController.position.pixels == scrollController.position.maxScrollExtent;

        if (isBottom && !hasReachedMax) {
          await whenScrollBottom.call();
        }

        final isTop = scrollController.position.pixels == scrollController.position.minScrollExtent;

        /* if (isTop && !isTopLoading) {
          whenScrollTop.call();
        } */
      },
    );
    useEffect(() {
      filteredMessages.value = message;
      scrollController.addListener(listener);



      return () => scrollController.removeListener(listener);
    }, [message , ]);

    return CustomRefreshIndicator(
      onRefresh: () async {
        //await whenScrollTop.call();
      },
      child: ListView(
        shrinkWrap: true,
        controller: scrollController,
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(),
        children: [

          MessageFilter(
                messages: message, // Pass original messages list
                onFilterChanged: (filtered) {
                  filteredMessages.value = filtered;
                },
              ),


          ListView.builder(
              itemCount: message?.length ?? 0,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final tag = UniqueKey();
                return GestureDetector(
                  onTap: () => context.router.push(
                    ConversationRoute(
                      messageDetail: filteredMessages.value?[index], // Use filtered messages here
                      heroTag: tag,
                    ),
                  ),
                  child: Hero(
                    tag: tag,
                    child: MessageListFormWidget(
                      message: filteredMessages.value?[index],

                    ),
                  ),
                );
              }

          ),
          if (!hasReachedMax) const BaseIndicator(),



        ],
      ),

    );
  }
}

/*
 return CustomRefreshIndicator(
      onRefresh: () async {
        await whenScrollTop.call();
      },
      child: CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: MessageFilter(
                  messages: message, // Pass original messages list
                  onFilterChanged: (filtered) {
                    filteredMessages.value = filtered;
                  },
                ),
              ),
            ),
          ),

          if (isTopLoading)

            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: const BaseIndicator(),
              ),
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                if (index >= (filteredMessages.value?.length ?? 0)) {
                  return const BaseIndicator();
                }
                final tag = UniqueKey();
                return GestureDetector(
                  onTap: () => context.router.push(
                    ConversationRoute(
                      messageDetail: filteredMessages.value?[index], // Use filtered messages here
                      heroTag: tag,
                    ),
                  ),
                  child: Hero(
                    tag: tag,
                    child: MessageListFormWidget(
                      message: filteredMessages.value?[index],
                    ),
                  ),
                );
              },
              childCount: (filteredMessages.value?.length ?? 0) + (hasReachedMax ? 0 : 1),
            ),

          ),

        ],
      ),

    );
 */