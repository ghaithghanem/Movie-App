import '../../../models/auth_model/user_model.dart';



abstract class AuthRemoteDataSource {

  Future<UserModel> login(String email, String password, bool rememberMe);
  Future<UserModel> signup(
    String firstName,
    String lastName,
    String username,
    String email,
    String password,
    DateTime dateOfBirth,
    String? profilePhotoPath,
  );
  //Future<UserModel> signOut();
  Future<UserModel> resetPassword(String email);
  Future<UserModel> getUser();
}
