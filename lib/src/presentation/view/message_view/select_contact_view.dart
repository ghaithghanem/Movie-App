import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/components/card/select_contact/ContactCard.dart';
import '../../../core/components/card/select_contact/select_button_card.dart';
import '../../../data/models/message_model/select_item_model.dart';
import '../../_widgets/message/select_item/selectItem_appbar_widget.dart';
import '../../_widgets/message/select_item/select_item_widget.dart';



@RoutePage()
class SelectContactView extends HookWidget {
  const SelectContactView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: SelectitemAppbarWidget(),
      body: SelectItemWidget(),
    );
  }

}