import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:equatable/equatable.dart';
import '../../../core/database/hive.dart';
 // Adjust the import path

part 'user_state.dart';

class UserIdCubit extends Cubit<UserIdState> {
  final HiveService _hiveService;

  UserIdCubit(this._hiveService) : super(UserIdInitial()) {
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    try {
      final userId = await _hiveService.getUserId();
      emit(UserIdLoaded(userId: userId));
    } catch (e) {
      emit(UserIdError(message: 'Error fetching user ID: $e'));
    }
  }
}
