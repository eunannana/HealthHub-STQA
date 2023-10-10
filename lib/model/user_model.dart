import 'dart:convert';

/// A class representing user data including name, email, ID, date of birth, and gender.
class UserModel {
  /// The user's name.
  final String uName;

  /// The user's email.
  final String uEmail;

  /// The user's unique ID.
  final String uId;

  /// The user's date of birth.
  final String uDateOfBirth;

  /// The user's gender.
  final String uGender;

  /// Constructs a [UserModel] instance with the provided data.
  UserModel({
    required this.uName,
    required this.uEmail,
    required this.uId,
    required this.uDateOfBirth,
    required this.uGender,
  });

  /// Factory method to create a [UserModel] object from a map.
  ///
  /// The [map] parameter should contain keys 'uName', 'uEmail', 'uId', 'uDateOfBirth', and 'uGender'.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uName: map['uName'] ?? '',
      uEmail: map['uEmail'] ?? '',
      uId: map['uId'] ?? '',
      uDateOfBirth: map['uDateOfBirth'] ?? '',
      uGender: map['uGender'] ?? '',
    );
  }

  /// Converts a [UserModel] object to a map.
  Map<String, dynamic> toMap() {
    return {
      'uName': uName,
      'uEmail': uEmail,
      'uId': uId,
      'uDateOfBirth': uDateOfBirth,
      'uGender': uGender,
    };
  }

  /// Converts a [UserModel] object to a JSON string.
  String toJson() => json.encode(toMap());

  /// Factory method to create a [UserModel] object from a JSON string.
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(uName: $uName, uEmail: $uEmail, uId: $uId, uDateOfBirth: $uDateOfBirth, uGender: $uGender)';
  }
}
