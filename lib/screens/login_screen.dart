import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scombapp_api/models/user.dart';
import 'package:scombapp_api/screens/timetable_screen.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // ユーザーが入力するIDとパスワードを管理するコントローラー
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // ログイン中かどうかを表すフラグ
  bool _isLoading = false;

  // エラーメッセージ（ログイン失敗時に表示）
  String? _errorMessage;

  // ログイン処理を実行する非同期関数
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String username = _userController.text;
    final String password = _passwordController.text;

    // API通信部分
    final response = await http.post(
      Uri.parse('https://smob.sic.shibaura-it.ac.jp/smob/api/login'),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({'user': username, 'pass': password}),
    );

    // ロード終了
    setState(() {
      _isLoading = false;
    });

    // APIのレスポンス判定
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == 'OK') {
        // 成功した場合 → 必要なデータを取得

        final user = User.fromJson(data); // ← data は jsonDecode() の結果

        // TODO: tokenやユーザー情報を保存したい場合はここで保存する（例: shared_preferences）

        // 時間割画面に遷移
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TimetableScreen(
              user: user
            ),
          ),
        );
      } else {
        setState(() {
          _errorMessage = 'ログインに失敗しました（IDまたはパスワードが正しくない可能性があります）';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'サーバーエラー：ステータスコード ${response.statusCode}';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ログイン')), // 画面上部のタイトルバー
      body: Padding(
        padding: EdgeInsets.all(16.0), // 余白
        child: Column(
          children: [
            // ID入力欄
            TextField(
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              controller: _userController,
              decoration: InputDecoration(labelText: 'ユーザー'),
            ),

            // パスワード入力欄（非表示にする）
            TextField(
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'パスワード'),
              obscureText: true, // パスワードを「●」で隠す
            ),

            SizedBox(height: 20), // スペース

            // エラーメッセージがある場合に表示（赤色）
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),

            // ログインボタン（ローディング中は押せない＆ローディング表示）
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading
                  ? CircularProgressIndicator() // ローディング中の表示
                  : Text('ログイン'),
            ),
          ],
        ),
      ),
    );
  }
}
