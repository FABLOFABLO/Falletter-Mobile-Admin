enum AdminSignUpErrorType { emailAlreadyExists, network, unknown }

enum Gender { male, female }

class AdminSignUpException implements Exception {
  final AdminSignUpErrorType type;
  final String message;

  AdminSignUpException(this.type, this.message);

  @override
  String toString() => 'AdminSignUpException($type): $message';
}

String genderToApi(Gender gender) {
  switch (gender) {
    case Gender.male:
      return "MALE";
    case Gender.female:
      return "FEMALE";
  }
}

class AdminSignUpRequest {
  final String email;
  final String password;
  final String name;
  final String gender;

  const AdminSignUpRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "name": name,
    "gender": gender,
  };
}

enum AdminSignInErrorType {
  invalidCredential,
  notApproved,
  userNotFound,
  network,
  unknown,
}

class AdminSignInException implements Exception {
  final AdminSignInErrorType type;
  final String message;

  AdminSignInException(this.type, this.message);

  @override
  String toString() => 'AdminSignInException($type): $message';
}

class AdminSignInRequest {
  final String email;
  final String password;

  const AdminSignInRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}

class AdminTokenResponse {
  final String accessToken;
  final String refreshToken;

  const AdminTokenResponse({
    required this.accessToken,
    required this.refreshToken,
  });

  factory AdminTokenResponse.fromJson(Map<String, dynamic> json) {
    return AdminTokenResponse(
      accessToken: (json["access_token"] ?? "") as String,
      refreshToken: (json["refresh_token"] ?? "") as String,
    );
  }
}
