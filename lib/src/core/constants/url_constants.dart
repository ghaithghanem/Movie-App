class UrlConstants {
  //* Movie
  static const popularMovies = '/movies/listmovie';
  static const topRatedMovies = '/movie/top_rated';
  static const movieCredits = '/movie/{movie_id}/credits';

  //* Actor
  static const actorDetail = '/person/{person_id}';
  static const actorSocialMedia = '/person/{person_id}/external_ids';

//* Auth
  static const getUser = '/users/me';
  static const login = '/users/signin';
  static const signup = '/users/signup';
  static const refresh_token = '/users/refresh-token';


  static const getFirebaseToken = '/storetoken/save-token';
//* Messages
  static const getMessages = '/api/messages/user/{user_id1}';
  static const getConversation = '/api/messages/conversation/{user_id1}/{user_id2}';
  static const sendMesaage = '/api/messages/send';
}
