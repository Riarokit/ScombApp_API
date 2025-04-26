class Lecture {
  final int dayOfWeek; // 月=1, 火=2, ...
  final int period; // 何限目か
  final String name; // 授業名
  final String nameEnglish; // 英語授業名
  final String teachers; // 教授名
  final String teachersEnglish; // 英語教授名
  final String campus; // 開講校舎
  final String room; // 教室
  final String syllabusUrl; // シラバスURL
  final int numberOfCredit; // 単位数

  // 通常のコンストラクタ
  Lecture({
    required this.dayOfWeek,
    required this.period,
    required this.name,
    required this.nameEnglish,
    required this.teachers,
    required this.teachersEnglish,
    required this.campus,
    required this.room,
    required this.syllabusUrl,
    required this.numberOfCredit,
  });

  // ファクトリコンストラクタ：APIのレスポンス(JSON)からClassインスタンスを作る
  factory Lecture.fromJson(dynamic json) {
    return Lecture(
      dayOfWeek: json['dayOfWeek'] as int,
      period: json['period'] as int,
      name: json['name'] as String,
      nameEnglish: json['nameEnglish'] as String,
      teachers: json['teachers'] as String,
      teachersEnglish: json['teachersEnglish'] as String,
      campus: json['campus'] as String,
      room: json['room'] as String,
      syllabusUrl: json['syllabusUrl'] as String,
      numberOfCredit: json['numberOfCredit'] as int,
    );
  }
}