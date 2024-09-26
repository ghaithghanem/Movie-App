import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'conversation_state.dart';

class ConversationCubit extends Cubit<ConversationState> {
  ConversationCubit() : super(ConversationInitial());
}
