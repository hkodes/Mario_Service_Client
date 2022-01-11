import 'dart:convert';

FirebaseResponse firebaseResponseFromJson(String str) =>
    FirebaseResponse.fromJson(json.decode(str));

String firebaseResponseToJson(FirebaseResponse data) =>
    json.encode(data.toJson());

class FirebaseResponse {
  FirebaseResponse({
    this.message,
  });

  String message;

  factory FirebaseResponse.fromJson(Map<String, dynamic> json) =>
      FirebaseResponse(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
