import 'package:flutter/material.dart';

import '../../../domain/entities/export_entities.dart';

class MessageFilter extends StatefulWidget {
  const MessageFilter({
    super.key,
    required this.messages,
    required this.onFilterChanged,
  });

  final List<MessageEntity>? messages;
  final Function(List<MessageEntity> filteredMessages) onFilterChanged;

  @override
  State<MessageFilter> createState() => _MessageFilterState();
}

class _MessageFilterState extends State<MessageFilter> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_filterMessages);
  }

  @override
  void dispose() {
    _controller.removeListener(_filterMessages);
    _controller.dispose();
    super.dispose();
  }

  void _filterMessages() {
    final query = _controller.text.toLowerCase();
    final filteredMessages = widget.messages?.where((message) {
      final sender = message.sender;
      return (sender?.firstName?.toLowerCase().contains(query) ?? false) ||
          (sender?.lastName?.toLowerCase().contains(query) ?? false);
    }).toList();

    widget.onFilterChanged(filteredMessages ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      child: Card(
        margin: EdgeInsets.only(right: 2, bottom: 15, top: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          controller: _controller,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search...',
            border: InputBorder.none,
            // Remove the border here
            focusedBorder: InputBorder.none,
            // Also remove the border when the TextField is focused
            enabledBorder: InputBorder.none,
            // Remove the border when the TextField is enabled
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
