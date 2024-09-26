import 'package:equatable/equatable.dart';

import '../../../data/models/export_models.dart';
import '../export_entities.dart';


class ConversationPaginationEntity extends Equatable{
  final int? page;
  final int? totalPages;
  final int? totalResults;
  final List<MessageEntity>? conversation;

  ConversationPaginationEntity({this.page, this.totalPages, this.totalResults, this.conversation});

  @override
  List<Object?> get props => [page,totalPages,totalResults,conversation];
}