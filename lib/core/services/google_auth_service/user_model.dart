class GoogleUserModel {
  final String userId;
  final String name;
  final String email;
  final String photo;

  /// 🔑 Tokens (clearly separated)
  final String googleIdToken;
  final String firebaseIdToken;
  final String fcmToken;

  GoogleUserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.photo,
    required this.googleIdToken,
    required this.firebaseIdToken,
    required this.fcmToken,
  });
}



// class GoogleUserModel {
//   final String userId;
//   final String name;
//   final String email;
//   final String photo;
//   // final String accessToken;
//   final String idToken; // ✅ added

//   GoogleUserModel({
//     required this.userId,
//     required this.name,
//     required this.email,
//     required this.photo,
//     // required this.accessToken,
//     required this.idToken,
//   });
// }

