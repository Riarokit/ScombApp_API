class User {
  // コンストラクタ
  User({
    required this.id,
    required this.password,
  });

  // プロパティ
  final String id;
  final String password;

  // JSONからUserを生成するファクトリコンストラクタ
  factory User.fromJson(dynamic json) {
    return User(
      id: json['id'] as String,
      password: json['profile_image_url'] as String,
    );
  }
}