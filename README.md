# 大学時間割表示アプリ（Flutter）

このアプリは、大学の授業時間割をスマートフォン上で簡単に確認できるFlutter製アプリケーションです。
APIを用いてログイン時にユーザごとにトークンを取得し、トークン情報を基にユーザに対応した授業情報を取得します。

---

## 📱 主な機能

- ログイン機能
- 時間割の曜日別表示
- 授業情報の確認（講義名、時間、教室など）

---

## 🛠️ 技術スタック

- **Flutter** 3.x
- **Dart** 言語
- Android/iOS 対応

---

## 📁 ディレクトリ構成

lib/
├── model/ # 授業情報・ユーザ情報等のモデル定義
│ ├── lecture.dart
│ └── user.dart
├── screen/ # 各画面（ログイン画面、時間割一覧画面、詳細画面など）のUI
│ ├── timetable_screen.dart
│ ├── login_screen.dart
│ └── lectureinfo_screen.dart
└── main.dart # アプリエントリポイント
