part of '../../../view/message_view/conversation_view.dart';

class _ConversationWidget extends HookWidget {
  final List<MessageEntity> messages;
  final Future<void> Function() whenScrollTop;
  final bool hasReachedMax;
  final ScrollController scrollController; // Receive ScrollController

  _ConversationWidget({
    super.key,
    required this.messages,
    required this.whenScrollTop,
    required this.hasReachedMax,
    required this.scrollController,
  });

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

    useAutomaticKeepAlive();

    void scrollUp() {
      final double start = 0;
      scrollController.animateTo(
        start,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    void scrollDown() {
      final double end = scrollController.position.maxScrollExtent;
      scrollController.jumpTo(end);
      print('scroll work');
    }

    Future<void> ScrolllPagenating() async {
      // Move the scroll position to the bottom
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    void listenScrolling() {
      if (scrollController.position.atEdge) {
        final isTop = scrollController.position.pixels == 0;

        if (isTop) {
          //showSnackbar(context, text: 'Reached top');

          final snackBar = SnackBar(
            /// need to set following properties for best effect of awesome_snackbar_content
            elevation: 0,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 260,
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'ON top!',
              message: 'reach top !',

              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
              contentType: ContentType.failure,
            ),
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        } else {
          final snackBar = SnackBar(
            /// need to set following properties for best effect of awesome_snackbar_content
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'On bot!',
              message: 'reach end!',

              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
              contentType: ContentType.success,
            ),
          );

          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        }
      }
    }

    final isLoadingMore = useState(false); // Track loading state

    final listener = useMemoized(() => () async {
          final isBottom = scrollController.position.maxScrollExtent ==
                  scrollController.offset &&
              scrollController.position.pixels ==
                  scrollController.position.maxScrollExtent;

          if (isBottom && !hasReachedMax) {
            isLoadingMore.value = true;
            await whenScrollTop.call(); // Fetch the new messages
            isLoadingMore.value = false;
          }
        });

    useEffect(
      () {
        scrollController.addListener(listener);
        return () => scrollController.removeListener(listener);
      },
      [],
    );

    return FutureBuilder<String?>(
      future: _getUserId(hiveService),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No user ID found'));
        }

        final currentUserId = snapshot.data!;

        return ListView(
          controller: scrollController,
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          reverse: true, // Keep this for the reverse order
          physics: const BouncingScrollPhysics(),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /*
                Flexible(
                  child: Material(
                    type: MaterialType.transparency,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          //scrollUp();
                          ScrolllPagenating();
                        },
                        icon: Icon(Icons.arrow_downward),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Flexible(
                  child: Material(
                    type: MaterialType.transparency,
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          scrollDown();
                        },
                        icon: Icon(Icons.arrow_upward),
                      ),
                    ),
                  ),
                ), */
              ],
            ),
            if (isLoadingMore.value)
              BaseIndicator(), // Show indicator while loading
            ListView.builder(
              itemCount: messages.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              reverse:
                  true, // The list is reversed, so the latest messages are at the bottom
              itemBuilder: (_, index) {
                return Hero(
                  tag:
                      'conversation-hero-tag-${messages[index].id}', // Unique tag for each item
                  child: ConversationFormWidget(
                    index: index + 1,
                    message: messages[index],
                    currentUserId: currentUserId,
                  ),
                );
              },
            ),
          ],
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
