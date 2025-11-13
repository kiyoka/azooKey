# azooKey プロジェクト構成ドキュメント

## 概要

azooKeyは**iOS/iPadOS向けの日本語キーボードアプリケーション**です。高度な日本語入力機能を提供するオープンソースプロジェクトで、MITライセンスの下で公開されています。

### 主な特徴
- 高度なかな漢字変換システム
- ニューラルベースの変換システム「Zenzai」
- ライブ変換（入力しながらリアルタイム変換）
- カスタマイズ可能なキーボードレイアウト
- フリック入力対応
- カスタムテーマと豊富なパーソナライゼーション機能

[App Store](https://apps.apple.com/jp/app/azookey)で公開されています。

## ディレクトリ構成

```
/Users/kiyoka/Documents/GitHub/azooKey/
├── AzooKeyCore/              # 共有Swiftパッケージモジュール
│   ├── Sources/
│   │   ├── SwiftUIUtils/     # SwiftUIユーティリティ
│   │   ├── KeyboardThemes/   # テーマシステム
│   │   ├── KeyboardViews/    # キーボードUI実装
│   │   ├── AzooKeyUtils/     # azooKey固有のユーティリティ
│   │   └── KeyboardExtensionUtils/ # キーボード拡張ヘルパー
│   └── Tests/                # ユニットテスト
├── MainApp/                  # メインiOSアプリケーション
│   ├── Setting/              # 設定画面
│   ├── Theme/                # テーマ管理
│   ├── Customize/            # カスタマイズ機能
│   ├── Tips/                 # 使い方ヒント
│   ├── General/              # 共有UIコンポーネント
│   └── Utils/                # ヘルパーユーティリティ
├── Keyboard/                 # キーボード拡張
│   ├── Display/              # コアキーボードロジック
│   │   ├── KeyboardViewController.swift
│   │   ├── KeyboardActionManager.swift
│   │   ├── InputManager.swift
│   │   ├── LiveConversionManager.swift
│   │   └── PredictionManager.swift
│   └── Dictionary/           # 辞書リソース
├── azooKeyTests/             # テストスイート
├── DictionaryDebugger/       # 辞書のデバッグツール
├── Resources/                # 共有リソース
│   ├── Designs.xcassets/     # デザインアセット
│   ├── Localizable.xcstrings # ローカライゼーション文字列
│   └── AzooKeyIcon-Regular.otf # カスタムアイコンフォント
├── azooKey_dictionary_storage/     # 辞書データ（サブモジュール）
├── azooKey_emoji_dictionary_storage/ # 絵文字辞書（サブモジュール）
├── zenz-v3.1-small-gguf/     # ニューラルモデル（サブモジュール）
├── zenz-v3.1-xsmall-gguf/    # 小型ニューラルモデル（サブモジュール）
└── docs/                     # ドキュメント
```

## 技術スタック

### コア技術
- **言語:** Swift 6.1+ (Swift 5.9互換性あり)
- **UIフレームワーク:** SwiftUI（キーボードとアプリUI全体）
- **プラットフォーム:** iOS 17+, macOS 14+
- **ビルドシステム:** Xcode (Xcode 26サポート)

### 主要な依存関係
- **AzooKeyKanaKanjiConverter** - コア変換エンジン（別パッケージ）
  - かな漢字変換を処理
  - Zenzaiニューラル変換システムを実装
  - 辞書用LOUDSデータ構造を使用
- **CustardKit** - カスタムキーボードフレームワーク
  - カスタムタブとキーボードレイアウトを管理
- **llama.cpp** - ニューラルモデル推論（Zenzai用）
  - GGUFモデルを実行するバイナリフレームワーク
- **FoundationModels** - AppleのMLフレームワーク統合

### その他の技術
- C++相互運用性（Package.swiftで有効化）
- Contactsフレームワーク統合
- UIKit（キーボード拡張ホスティング用）
- Combineフレームワーク（リアクティブ状態管理用）

## 主要なソースコードディレクトリ

### AzooKeyCore/Sources/ (34,351行以上のSwiftコード)
- **SwiftUIUtils**: 一般的なSwiftUIユーティリティと拡張
- **KeyboardThemes**: テーマデータモデルとカラー管理
- **KeyboardViews**: 完全なキーボードUI実装
  - カスタムキーボードレイアウト（フリック、QWERTY）
  - 結果バーと候補表示
  - タブ管理システム
  - 絵文字タブ実装
  - キーボード内テキスト入力コンポーネント
- **AzooKeyUtils**: アプリケーション固有のユーティリティ
  - 設定管理
  - テーマ管理
  - Custard（カスタムキーボード）管理
  - ユーザー辞書処理
- **KeyboardExtensionUtils**: テキストドキュメントプロキシ抽象化

### MainApp/
- エントリポイント: `MainApp.swift` (@main)
- メインビュー: `ContentView.swift` (タブベースナビゲーション)
- **Setting/**: すべての設定画面（Zenzai、フォント、レイアウト、学習など）
- **Theme/**: テーマの作成、編集、共有
- **Customize/**: カスタムキーボード（Custard）編集インターフェース
- **Tips/**: ユーザーオンボーディングとヒント
- **General/**: 再利用可能なUIコンポーネント

### Keyboard/Display/
- `KeyboardViewController.swift`: キーボード拡張のメインエントリポイント (Keyboard/Display/KeyboardViewController.swift:1)
  - `viewDidLoad`が実質的なエントリポイント
  - `KeyboardActionManager`のインスタンスを生成しユーザ操作を管理
  - SwiftUIで実装されたキーボードUIの読み込みを行う
- `KeyboardActionManager.swift`: すべてのユーザーアクションを処理 (Keyboard/Display/KeyboardActionManager.swift:1)
  - `InputManager`を用いて変換状態を管理
- `InputManager.swift`: 変換状態と組み立てを管理 (Keyboard/Display/InputManager.swift:1)
  - かな漢字変換器`KanaKanjiConverter`のAPIを呼び出し
  - `LiveConversionManager`を通してライブ変換処理を実行
  - `DisplayedTextManager`を通して表示テキストを管理
- `LiveConversionManager.swift`: リアルタイム変換ロジック (Keyboard/Display/LiveConversionManager.swift:1)
- `PredictionManager.swift`: ゼロクエリ予測 (Keyboard/Display/PredictionManager.swift:1)

## 重要な設定ファイル

### Swift Package Manager
- `AzooKeyCore/Package.swift`
  - 5つのライブラリプロダクトを定義
  - Swift 6.1ツールバージョン
  - Xcode 26+条件付きバイナリターゲット処理
  - 特定のリビジョンに固定された依存関係

### Xcodeプロジェクト
- `azooKey.xcodeproj/`
  - 3つのスキーム: MainApp、Keyboard、azooKeyTests

### Info.plistファイル
- **MainApp/Info.plist**:
  - カスタムURLスキーム: `azooKey://`
  - ドキュメントタイプ: `.custard`, `.json`
  - 連絡先使用説明
- **Keyboard/Info.plist**:
  - 拡張属性（日本語キーボード、フルアクセスをリクエスト）
  - プライマリ言語: ja-JP

### Entitlements
- **MainApp/azooKey.entitlements**:
  - App Groups: `group.com.azooKey.keyboard`
  - Custard共有用の関連ドメイン
- **Keyboard/Keyboard.entitlements**:
  - App Groups: `group.com.azooKey.keyboard`

### Git設定
- `.gitmodules`: 4つのサブモジュール（辞書2つ、ニューラルモデル2つ）
- `.swiftlint.yml`: カスタムルールを含むSwiftLint設定

### ローカライゼーション
- `Resources/Localizable.xcstrings`: メインローカライゼーションファイル
- `Resources/InfoPlist.xcstrings`: Info.plistローカライゼーション

## テスト構成

### テスト構造
- **テストターゲット:** azooKeyTestsスキーム
- **場所:** `azooKeyTests/`
- **AzooKeyCoreテスト:**
  - `AzooKeyUtilsTests/`
  - `KeyboardExtensionUtilsTests/`

### テスト実行
1. "azooKeyTests"スキームに切り替え
2. Command+Uで実行

### カバレッジ
- かな漢字変換に主な焦点
- コンバータテストと辞書ストアテスト
- 他の領域への拡張を計画中

## ビルドとデプロイメント設定

### GitHub Actionsワークフロー
- `.github/workflows/swift.yml`: メインCIパイプライン
  - main/developブランチへのpushで実行
  - Swift 5.9セットアップ
  - SwiftUIUtilsとKeyboardThemesモジュールをビルド
  - `.build`ディレクトリのキャッシング
- `.github/workflows/build-on-push.yml`: ビルド自動化
- `.github/workflows/upload-build.yml`: ビルド成果物のアップロード
- `.github/workflows/codeql.yml`: セキュリティ分析

### ビルド要件
- 最新のXcodeを含むmacOS
- Apple Developer Account（無料版でも可）
- 再帰的クローンが必要（サブモジュール用）

### コード品質
- カスタムルールを含むSwiftLint統合
- 必須の末尾カンマ
- ソート済みインポート
- 様々なコードスタイルの強制

### リリースプロセス
- Xcodeプロジェクト設定によるバージョン管理
- App Store配信
- TestFlightベータテスト利用可能
- フィードバック用Discordコミュニティ

## アーキテクチャパターンと設計選択

### アーキテクチャパターン

#### 1. MVVMとSwiftUI
UI全体がSwiftUIと監視可能オブジェクトを使用：
- `VariableStates`: 中央監視可能状態コンテナ
- `UserActionManager`: プロトコルベースのアクション処理
- ビューとロジック間の明確な分離

#### 2. マネージャーパターン
専門化されたマネージャーの多用：
- `KeyboardActionManager`: ユーザーアクション調整
- `InputManager`: 組み立てと変換状態
- `LiveConversionManager`: リアルタイム変換ロジック
- `PredictionManager`: ゼロクエリ予測
- `DisplayedTextManager`: 表示状態管理
- `ThemeManager`: テーマ処理
- `CustardManager`: カスタムキーボード管理

#### 3. 拡張ベースのアーキテクチャ
- `ApplicationSpecificKeyboardViewExtension`プロトコルでアプリ固有の動作を定義
- `AzooKeyKeyboardViewExtension`を具体実装として提供
- 異なるコンテキスト間でキーボードビューを再利用可能

#### 4. モジュラー設計
- Swiftパッケージ（`AzooKeyCore`）のコア機能
- メインアプリとキーボード拡張間で共有
- 関心事の明確な分離（テーマ、ビュー、ユーティリティ）

### 主要な設計選択

#### パフォーマンス最適化
- インスタンスカウント追跡（15回以上のインスタンス後に自動再起動）
- 手動メモリ管理の考慮
- 共有状態のシングルトンパターン

#### iOSバージョン処理
- iOS 26+と旧バージョンの条件付きコンパイル
- OSバージョンごとに異なるレイアウト計算戦略
- 画面の向きとサイズの慎重な処理

#### データストレージ
- アプリと拡張間のデータ共有用App Groups
- 移行サポート付きユーザー辞書
- クリップボード履歴（フルアクセス有効時）
- 学習データの永続化

#### 国際化
- 日本語キーボードレイアウト（フリック、QWERTY）をサポート
- 英語キーボードサポート
- `.xcstrings`ファイルによるローカライゼーション

#### ニューラル統合
- Zenzaiニューラル変換用GGUFモデルフォーマット
- gitサブモジュールとして2つのモデルサイズ（small、xsmall）
- llama.cppを使用したデバイス上推論

#### カスタマイズシステム（「Custard」）
- JSON/ファイルベースのカスタムキーボード定義
- 共有可能なカスタムレイアウト
- インポート/エクスポート機能
- 共有用ディープリンクサポート

#### プライバシー重視の設計
- オプションのフルアクセス（多くの機能は不要）
- 権限が必要な機能の明確なドキュメント
- オプションの連絡先統合
- App Store要件のためのPrivacyInfo.xcprivacyファイル

#### 開発者体験
- `docs/`内の包括的なドキュメント
- コントリビューションガイドライン
- 将来機能のビジョンドキュメント
- アクティブなDiscordコミュニティ
- コードの一貫性のためのSwiftLint

### 注目すべき技術的詳細
- カスタムアイコンフォント（AzooKeyIcon-Regular.otf）
- より良いUXのための画面エッジジェスチャー遅延
- 動的キーボード高さ調整
- リサイズモードサポート
- 片手モード実装
- 文節ベース編集によるライブ変換
- 組み立て後予測
- 絵文字・顔文字用置換候補システム

## 開発開始方法

### 必須要件
1. 最新のXcodeがインストールされたmacOS
2. Apple Developer Account
3. Git（サブモジュール用）

### セットアップ手順
```bash
# リポジトリを再帰的にクローン
git clone --recursive https://github.com/ensan-hcl/azooKey.git

# サブモジュールの更新（必要な場合）
git submodule update --init --recursive

# Xcodeでプロジェクトを開く
open azooKey.xcodeproj
```

### ビルド
1. MainAppまたはKeyboardスキームを選択
2. Command+Bでビルド
3. Command+Rで実行

### テスト実行
1. azooKeyTestsスキームを選択
2. Command+Uでテスト実行

## コントリビューション

このプロジェクトはオープンソースでコントリビューションを歓迎しています。詳細は`docs/`ディレクトリのドキュメントを参照してください。

## ライセンス

MIT License

## 用語集

azooKeyプロジェクトで使用される主要な用語の対応表：

| 英語                        | 日本語           | 備考                                                         |
| --------------------------- | ---------------- | ------------------------------------------------------------ |
| Action                      | ユーザの操作     |                                                              |
| Candidate                   | 変換候補         |                                                              |
| ChangeKeyboardKey           | 地球儀キー       | キーボードを変更するための地球儀キー。Appleの言葉ではInputModeSwitchKey。 |
| Composing                   | 編集中           | 変換対象のテキストになっている、との意味。                   |
| Cursor                      | カーソル         | 入力フィールド上に表示されるカーソル。コメントなどでは`|`の記号で表すことも多い。 |
| Cursor Bar                  | カーソルバー     | 空白キーの長押しなどで表示されるカーソル移動用のバーUI。     |
| Custard                     | カスタード       | **Cust**om Keybo**ard**の略。カスタムタブに関わる機能で用いている。 |
| Dicdata                     | 辞書データ       |                                                              |
| Displayed                   | 表示されている   | 内部状態ではなく、ユーザに見えている状態である、との意味。   |
| InputStyle                  | 入力方法         | ローマ字入力、ダイレクト入力など、入力方式を意味する。       |
| Learning                    | 学習             | 専ら学習機能を意味する。                                     |
| Live Conversion             | ライブ変換       |                                                              |
| LOUDS                       | LOUDS            | データ構造の名。                                             |
| Post Composition Prediction | 確定後の予測変換 | 候補を全て確定した後に表示される予測変換。                   |
| Result Bar                  | リザルトバー     | 変換候補を表示しているバーUI。                               |
| Tab Bar                     | タブバー         | azooKeyのアイコンのボタンを押すと表示されるバーUI。タブの移動などに用いる。 |

---

*このドキュメントは、azooKeyプロジェクトの構成を理解するための包括的なガイドです。詳細な実装については、各ディレクトリ内のソースコードとドキュメントを参照してください。*
