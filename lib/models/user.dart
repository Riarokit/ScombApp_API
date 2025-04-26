class User {
  final String token; // 認証トークン
  final String userType; // ユーザータイプ（例: student, teacher）
  final String gakubu; // 学部コード
  final String gakka; // 学科コード

  // 通常のコンストラクタ
  User({
    required this.token,
    required this.userType,
    required this.gakubu,
    required this.gakka,
  });

  // ファクトリコンストラクタ：APIのレスポンス(JSON)からUserインスタンスを作る
  factory User.fromJson(dynamic json) {
    return User(
      token: json['token'],
      userType: json['user_type'],
      gakubu: json['gakubu'],
      gakka: json['gakka'],
    );
  }
}