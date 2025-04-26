import 'package:flutter/material.dart';
import 'package:scombapp_api/models/lecture.dart';
import 'package:url_launcher/url_launcher.dart';

class LectureinfoScreen extends StatelessWidget {
  const LectureinfoScreen({super.key, required this.lecture}) ;

  final Lecture lecture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('授業内容')), // 画面上部のタイトルバー
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text( // 授業名
              lecture.name,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text( // 授業英語名
              lecture.nameEnglish,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            Divider(
              color: Colors.grey.shade400,
              thickness: 1,
              height: 12,
            ),
            Text( // 教授名
              lecture.teachers,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Text( // 教授英語名
              lecture.teachersEnglish,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: labeledBox( // 教室
                context: context,
                label: '教室',
                child: Text(
                  "${lecture.campus} | ${lecture.room}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: labeledBox( // 単位数
                context: context,
                label: "単位数",
                child: Text(
                  "${lecture.numberOfCredit}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: labeledBox( // メモ
                context: context,
                label: "メモ",
                child: TextField(
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(hintText: '自由にメモを書いてください'),
                ),
              ),
            ),
            SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: labeledBox( // リンク
                context: context,
                label: "リンク集",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // シラバスリンクアイコン
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.book, color: Colors.green),
                          iconSize: 60,
                          onPressed: () {
                            launchUrl(Uri.parse(lecture.syllabusUrl));
                          },
                        ),
                        const Text(
                          'シラバス',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget labeledBox({ // ラベル付きのコンテナの定義
  required BuildContext context,
  required String label,
  required Widget child,
}) {
  return Stack(
    children: [
      // 枠付きの箱
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(top: 12), // ラベル分のスペース
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
      // ラベル部分（左上にちょこんと乗せる）
      Positioned(
        left: 12,
        top: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ],
  );
}
