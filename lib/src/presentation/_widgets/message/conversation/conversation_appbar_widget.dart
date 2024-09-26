part of '../../../view/message_view/conversation_view.dart';

class ConversationAppbarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final MessageEntity? messageDetail;

  const ConversationAppbarWidget({
    super.key,
    required this.messageDetail,
  });

  @override
  _ConversationAppbarWidgetState createState() =>
      _ConversationAppbarWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ConversationAppbarWidgetState extends State<ConversationAppbarWidget> {
  late bool isSender = false;
  late String userId = '';
  late String userId2 = '';
  final hiveService = injector<HiveService>();

  Future<String> _getUserId(HiveService hiveService) async {
    final userId = await hiveService.getUserId();
    if (userId == null || userId.isEmpty) {
      throw Exception('User ID not found');
    }
    return userId;
  }

  Future<void> _initConversation() async {
    try {
      final fetchedUserId = await _getUserId(hiveService);
      userId = fetchedUserId;
      final fetchUsirId2 = widget.messageDetail?.sender?.id ?? '';

      if (fetchUsirId2 == fetchedUserId) {
        userId2 = widget.messageDetail?.receiver?.id ?? '';
        isSender = true;
      } else {
        userId2 = widget.messageDetail?.sender?.id ?? '';
        isSender = false;
      }

      setState(() {});
    } catch (e) {
      print('Error fetching conversation: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initConversation();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: isSender
                ? (widget.messageDetail?.receiver?.profilePhoto != null
                    ? NetworkImage(
                        widget.messageDetail!.receiver!.profilePhoto!)
                    : null)
                : (widget.messageDetail?.sender?.profilePhoto != null
                    ? NetworkImage(widget.messageDetail!.sender!.profilePhoto!)
                    : null),
            child: isSender
                ? (widget.messageDetail?.receiver?.profilePhoto == null
                    ? const Icon(Icons.person)
                    : null)
                : (widget.messageDetail?.sender?.profilePhoto == null
                    ? const Icon(Icons.person)
                    : null),
          ),
          const SizedBox(width: 8.0),
          Text(
            isSender
                ? '${widget.messageDetail?.receiver?.firstName ?? ''} ${widget.messageDetail?.receiver?.lastName ?? ''}'
                : '${widget.messageDetail?.sender?.firstName ?? ''} ${widget.messageDetail?.sender?.lastName ?? ''}',
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }
}
