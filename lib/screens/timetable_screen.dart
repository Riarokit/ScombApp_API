import 'package:flutter/material.dart';
import 'package:scombapp_api/models/user.dart';
import 'package:scombapp_api/models/lecture.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:scombapp_api/screens/lectureinfo_screen.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key, required this.user});

  final User user;

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  List<Lecture> lectures = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLectures(); // 最初に一回だけ取得
  }

  Future<void> _loadLectures() async {
    // API通信部分
    final response = await http.get(
      Uri.parse('https://smob.sic.shibaura-it.ac.jp/smob/api/timetable/202501'),
      headers: {'Authorization': 'Bearer ${widget.user.token}'},
    );

    List<Lecture> gotLectures = []; // 取得した授業情報一覧を格納するリスト変数

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      gotLectures = body.map((dynamic json) => Lecture.fromJson(json)).toList(); // ← data は jsonDecode() の結果

    } else {
      setState(() {
        _errorMessage = 'サーバーエラー：ステータスコード ${response.statusCode}';
      });
    }

    setState(() {
      lectures = gotLectures;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 表の列（曜日）と行（時限）を定義
    const days = ['月', '火', '水', '木', '金', '土'];
    const periods = [1, 2, 3, 4, 5, 6];

    return Scaffold(
      // 上部にアプリバーを表示（画面タイトル）
      appBar: AppBar(
        title: const Text('時間割'),
      ),

      body: Column(
        children: [
          Table(
            border: TableBorder.all(color: Colors.grey[300]!), // 表の枠線
            columnWidths: {
              0: const FlexColumnWidth(0.4), // 時限の枠幅だけ狭くする
              for (int i = 1; i < days.length + 1; i++) i: const FlexColumnWidth(), // その他の幅は画面サイズで割る
            },
            children: [
              // ヘッダー行（曜日を上に並べる）
              TableRow(
                children: [
                  const SizedBox(), // 左上の空白セル
                  ...days.map((day) =>
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[200], // 背景色を薄いグレーに
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black), // 曜日の文字色
                        ),
                      )),
                ],
              ),

              // 各時限ごとの行を作成（1限〜6限）
              ...periods.map((period) {
                return TableRow(
                  children: [
                    // 一番左の列（何限か表示）
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(8),
                      color: Colors.grey[200], // 背景色を薄いグレーに
                      child: Text(
                        '$period',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),

                    // 各曜日ごとにその時限の授業を表示（6列）
                    ...List.generate(6, (dayIndex) {
                      // 対応する授業を探す（なければnull）
                      final Lecture? lecture = lectures.firstWhereOrNull(
                            (lec) =>
                        lec.period == period &&
                            lec.dayOfWeek == dayIndex + 1,
                      );

                      return Container(
                        height: 100,
                        padding: const EdgeInsets.all(3),
                        child: lecture != null
                            ? ElevatedButton(
                          // 授業がある場合はボタンを表示
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8),
                            backgroundColor: Colors.white54,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 1,
                          ),
                          onPressed: () {
                            // ボタンを押すと詳細ページへ
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) => LectureinfoScreen(lecture: lecture)),
                              ),
                            );
                          },
                          child: Text(
                            // 授業名
                            lecture.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 10.5,
                            ),
                          ),
                        )
                            : const SizedBox.shrink(), // 授業がなければ空欄
                      );
                    }),
                  ],
                );
              }).toList(),
            ],
          ),
          if(_errorMessage != null) // エラーが発生したら文字起こし
            Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
    );
  }
}
