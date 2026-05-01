class AuthResponseModel {
  final String accessToken;
  final String refreshToken;

  AuthResponseModel({required this.accessToken, required this.refreshToken});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return AuthResponseModel(
      accessToken: data['accessToken']?.toString() ?? '',
      refreshToken: data['refreshToken']?.toString() ?? '',
    );
  }
}
