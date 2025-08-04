# 給与管理アプリ

複数の仕事から得られる給与を一元管理し、月次／年次で視覚的に把握できるモバイルアプリです。

## 機能

### 主要機能
- **カテゴリー管理**: 給与の種類を自由入力で登録・編集・削除。色（24色）とアイコン（10種類）を選択
- **月次給与可視化**: 当月を中心に前後月へスワイプで移動。カテゴリー別の円グラフ＋明細一覧
- **給与登録／編集**: 対象月・カテゴリー・金額を入力して保存
- **年次比較**: 年を指定し、1〜12月の縦棒（スタックドバー）でカテゴリー別割合を表示
- **マイページ**: 当月の月次円グラフを初期表示
- **ボトムナビ**: マイページ／年別給与／カテゴリー管理の3タブ

### 技術仕様
- **フレームワーク**: Flutter
- **状態管理**: hooks_riverpod
- **ローカルDB**: Hive (NoSQL)
- **チャート**: fl_chart
- **アーキテクチャ**: Clean Architecture (presentation / domain / data layers)

## セットアップ

### 前提条件
- Flutter SDK 3.5.3以上
- Dart SDK 3.5.3以上

### インストール
```bash
# 依存関係のインストール
flutter pub get

# コード生成の実行
flutter packages pub run build_runner build

# アプリの実行
flutter run
```

## 使用方法

### 1. カテゴリー作成
1. ボトムナビの「カテゴリー」タブをタップ
2. 右上の「+」ボタンをタップ
3. カテゴリー名、色、アイコンを選択して作成

### 2. 給与登録
1. ホーム画面で右上の「+」ボタンをタップ
2. カテゴリーと金額を入力
3. 「保存」ボタンをタップ

### 3. データ確認
- **ホーム画面**: 月次円グラフと明細一覧
- **年別給与画面**: 年次棒グラフで月別比較
- **カテゴリー管理**: カテゴリーの一覧・編集・削除

## データ構造

### Category
```dart
{
  id: int,           // Hive auto-increment key
  name: String,      // カテゴリー名
  color: int,        // ARGB32色コード
  icon: String,      // アイコン名
  createdAt: DateTime // 作成日時
}
```

### SalaryEntry
```dart
{
  id: int,           // Hive auto-increment key
  categoryId: int,   // Category.id FK
  amount: double,    // 金額
  year: int,         // 年
  month: int,        // 月
  createdAt: DateTime // 作成日時
}
```

## 開発

### プロジェクト構造
```
lib/
├── core/
│   └── constants.dart          # 定数定義
├── data/
│   ├── adapters/               # Hiveアダプター
│   └── repositories/           # データアクセス層
├── domain/
│   └── models/                 # データモデル
└── presentation/
    ├── pages/                  # 画面
    ├── providers/              # 状態管理
    └── widgets/                # 再利用可能なウィジェット
```

### コード生成
モデルを変更した場合は、以下のコマンドでコード生成を実行してください：
```bash
flutter packages pub run build_runner build
```

## ライセンス

MIT License
