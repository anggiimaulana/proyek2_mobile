
class LoginResponse {
  final bool error;
  final String message;
  final String token;
  final int clientId;
  final int kkId;

  LoginResponse({
    required this.error,
    required this.message,
    required this.token,
    required this.clientId,
    required this.kkId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        error: json['error'],
        message: json['message'],
        token: json['token'],
        clientId: json['client_id'],
        kkId: json['kk_id'],
      );
}
