class AccessToken {
  String access_token;

  AccessToken({this.access_token});

  factory AccessToken.fromJson(Map<String, dynamic> json) {
    return AccessToken(
      access_token: json['access_token'] as String,
    );
  }
}