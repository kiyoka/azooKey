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

### シミュレーターでのキーボード使用

キーボード拡張を使用するには、アプリのインストール後に追加の設定が必要です：

#### 1. MainAppをシミュレーターにインストール
1. Xcodeで**MainApp**スキームを選択
2. ターゲットデバイスでiOSシミュレーター（例: iPhone 15）を選択
3. **Command+R**で実行
4. アプリがシミュレーターにインストールされます

#### 2. シミュレーターでキーボードを有効化
1. シミュレーターの**設定**アプリを開く
2. **一般** → **キーボード** → **キーボード**に移動
3. **新しいキーボードを追加...**をタップ
4. **サードパーティキーボード**セクションから**azooKey**を選択
5. （オプション）**azooKey**をタップして**フルアクセスを許可**をオンにする

#### 3. キーボードの切り替え
1. メモアプリなどでテキストフィールドをタップ
2. キーボード左下の**地球儀キー🌐**を長押し
3. **azooKey**を選択
4. azooKeyキーボードが表示されます

#### トラブルシューティング

**ソフトウェアキーボード自体が表示されない場合:**
- **原因**: Macのハードウェアキーボードが接続されているため、ソフトウェアキーボードが表示されない
- **解決方法**:
  - シミュレーターのメニューバーで **I/O** → **Keyboard** → **Connect Hardware Keyboard**のチェックを外す
  - または、シミュレーターがアクティブな状態で**Command+K**を押す
  - これでテキストフィールドをタップすると画面下部にソフトウェアキーボードが表示されます

**キーボードがリストに表示されない場合:**
- シミュレーターのホーム画面で**azooKey**アプリアイコンが表示されているか確認
- 表示されていない場合は、Xcodeで**MainApp**スキームを選択して再度**Command+R**
- それでも解決しない場合：
  - **Product** → **Clean Build Folder**（Shift+Command+K）
  - シミュレーターをリセット: **Device** → **Erase All Content and Settings...**
  - サブモジュールを更新: `git submodule update --init --recursive`
  - 再度ビルド・実行

**キーボードが切り替わらない場合:**
- 地球儀キー🌐を**長押し**する（タップではなく）
- または地球儀キーを**複数回タップ**してキーボードを順に切り替える

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

## 実機への転送

azooKeyをiPhone実機で動かすには、App Groupsを使用しているため、有料のApple Developer Accountとプロビジョニングプロファイルが必要です。

### 前提条件

- **Apple Developer Program**への登録（年間$99）
  - App Groupsの使用には有料アカウントが必須
  - [Apple Developer Program](https://developer.apple.com/programs/)から登録

### 1. App IDの作成

[Apple Developer Portal](https://developer.apple.com/account/)にログインし、**Certificates, Identifiers & Profiles**に移動：

#### メインアプリ用のApp ID
1. **Identifiers** → **+**ボタンをクリック
2. **App IDs**を選択して続行
3. 以下の情報を入力：
   - Description: `azooKey Main`
   - Bundle ID: `com.yourname.azooKey`（明示的なBundle IDを使用）
   - Capabilities: **App Groups**にチェック
4. **Continue**して登録

#### キーボード拡張用のApp ID
同様の手順で以下を作成：
- Description: `azooKey Keyboard`
- Bundle ID: `com.yourname.azooKey.Keyboard`
- Capabilities: **App Groups**にチェック

### 2. App Groupの作成

1. **Identifiers**セクションで**App Groups**を選択
2. **+**ボタンをクリック
3. 以下の情報を入力：
   - Description: `azooKey Keyboard Group`
   - Identifier: `group.com.yourname.azooKey.keyboard`
4. **Continue**して登録

### 3. App GroupをApp IDに紐付け

各App ID（メインアプリとキーボード拡張の両方）に対して：

1. 作成したApp IDを選択
2. **App Groups**セクションで**Configure**をクリック
3. 先ほど作成したApp Group（`group.com.yourname.azooKey.keyboard`）を選択
4. **Save**

### 4. プロビジョニングプロファイルの作成

#### 開発用プロファイル（メインアプリ）
1. **Profiles**セクションで**+**ボタン
2. **iOS App Development**を選択
3. App ID: `com.yourname.azooKey`を選択
4. Certificate: 開発用証明書を選択
5. Devices: テスト用iPhoneを選択
6. Profile Name: `azooKey Development`
7. **Generate**してダウンロード

#### 開発用プロファイル（キーボード拡張）
同様の手順で`com.yourname.azooKey.Keyboard`用も作成

### 5. プロジェクト設定の変更

#### Bundle Identifierの変更

Xcodeでプロジェクトを開き、各ターゲットのBundle Identifierを変更：

**メインアプリ（MainApp）ターゲット:**
1. プロジェクトナビゲーターで**azooKey**プロジェクトを選択
2. **TARGETS** → **MainApp**を選択
3. **Signing & Capabilities**タブ
4. **Bundle Identifier**を`com.yourname.azooKey`に変更
5. **Team**を自分のApple Developer Accountに設定
6. **App Groups**で以下を設定：
   - 既存の`group.com.azooKey.keyboard`を削除
   - **+**ボタンで`group.com.yourname.azooKey.keyboard`を追加

**キーボード拡張（Keyboard）ターゲット:**
1. **TARGETS** → **Keyboard**を選択
2. **Bundle Identifier**を`com.yourname.azooKey.Keyboard`に変更
3. **Team**を同じApple Developer Accountに設定
4. **App Groups**を同じ`group.com.yourname.azooKey.keyboard`に設定

#### コード内のApp Group識別子を更新

`AzooKeyCore/Sources/AzooKeyUtils/SharedStore.swift`を編集：

```swift
// 変更前
public static let appGroupKey = "group.com.azooKey.keyboard"

// 変更後
public static let appGroupKey = "group.com.yourname.azooKey.keyboard"
```

#### Entitlementsファイルの更新

**MainApp/azooKey.entitlements:**
```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.yourname.azooKey.keyboard</string>
</array>
```

**Keyboard/Keyboard.entitlements:**
```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.yourname.azooKey.keyboard</string>
</array>
```

### 6. 実機への転送

1. iPhoneをMacに接続
2. Xcodeで**MainApp**スキームを選択
3. ターゲットデバイスとして接続したiPhoneを選択
4. **Command+R**でビルド＆実行

### 7. iPhoneでキーボードを有効化

アプリインストール後、iPhone上で：

1. **設定**アプリを開く
2. **一般** → **キーボード** → **キーボード**に移動
3. **新しいキーボードを追加...**をタップ
4. サードパーティキーボードのセクションから**azooKey**を選択
5. 必要に応じて**フルアクセスを許可**を有効化

### トラブルシューティング

#### 署名エラーが出る場合
- Xcodeの**Preferences** → **Accounts**で、Apple IDが正しくログインされているか確認
- **Automatically manage signing**のチェックを一度外して、再度有効にしてみる
- **Product** → **Clean Build Folder**（Shift+Command+K）を実行

#### App Groupエラーが出る場合
- Developer Portalで全てのApp IDにApp Groupが正しく設定されているか確認
- EntitlementsファイルとXcodeの設定が一致しているか確認
- コード内の`SharedStore.appGroupKey`が正しく更新されているか確認

#### "Untrusted Developer"エラーが出る場合
iPhoneで初めて自分の証明書でビルドしたアプリを実行する場合：
1. iPhone上で**設定** → **一般** → **VPNとデバイス管理**に移動
2. 開発者アプリのセクションで自分のApple IDを選択
3. **"[Apple ID]"を信頼**をタップ

## ビルド時のトラブルシューティング

### llama.cpp バイナリフレームワークのダウンロードエラー

#### エラーメッセージ
```
failed downloading 'https://github.com/azooKey/llama.cpp/releases/download/b4846/signed-llama.xcframework.zip'
which is required by binary target 'llama':
/Users/[username]/Library/Caches/org.swift.swiftpm/artifacts/https___github_com_azooKey_llama_cpp_releases_download_b4846_signed_llama_xcframework_zip
already exists in file system
```

#### 原因
Swift Package Managerのキャッシュが破損しているか、古いバージョンのキャッシュが残っています。

#### 解決方法

**方法1: Xcodeでキャッシュをクリア（推奨）**

1. Xcodeで**File** → **Packages** → **Reset Package Caches**
2. **Product** → **Clean Build Folder**（Shift+Command+K）
3. Xcodeを再起動
4. プロジェクトを開いて**Command+B**でビルド

**方法2: ターミナルでキャッシュを削除（より確実）**

```bash
# Xcodeを終了してから実行
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf ~/Library/Developer/Xcode/DerivedData
cd /path/to/azooKey
rm -rf .build
rm -rf .swiftpm
```

その後、Xcodeでプロジェクトを開き：
1. **File** → **Packages** → **Resolve Package Versions**
2. **Command+B**でビルド

**方法3: 完全なクリーンビルド**

```bash
# プロジェクトディレクトリで実行
cd /path/to/azooKey

# 全てのキャッシュとビルド成果物を削除
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf ~/Library/Developer/Xcode/DerivedData
rm -rf .build
rm -rf .swiftpm
```

Xcodeで以下を実行：
1. プロジェクトを開く
2. **File** → **Packages** → **Reset Package Caches**
3. **File** → **Packages** → **Resolve Package Versions**
4. **Product** → **Clean Build Folder**（Shift+Command+K）
5. **Command+B**でビルド

#### ネットワークエラーの場合
上記で解決しない場合は、ネットワークの問題の可能性があります：
- Wi-Fi接続を確認
- プロキシ設定を確認
- GitHubへのアクセスを確認: https://github.com/azooKey/llama.cpp/releases/tag/b4846

## デバッグとログ出力

### キーボード拡張のデバッグ

キーボード拡張（`InputManager`など）のデバッグ情報をXcodeコンソールに出力する方法：

#### 既存の`debug()`関数を使う（推奨）

プロジェクトでは`SwiftUtils`パッケージの`debug()`関数が使用されています：

```swift
// InputManager.swiftでの使用例
debug("InputManager.setResult: value to be input", inputData)
debug("変換候補の数:", results.mainResults.count)
debug("最初の候補:", results.mainResults.first?.text ?? "なし")
```

#### `os.log`を使う（より詳細なログ）

```swift
import os.log

// クラス内に追加
private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "azooKey", category: "InputManager")

// 使用例
logger.info("変換候補数: \(results.mainResults.count)")
logger.debug("候補: \(candidate.text)")
logger.error("エラーが発生しました")
```

#### デバッグ実行の手順

1. Xcodeで**Keyboard**スキームを選択
2. **Product** → **Scheme** → **Edit Scheme...**
3. **Run** → **Executable**を"Ask on Launch"に設定
4. **Command+R**で実行
5. ダイアログで**メモ**アプリなどを選択
6. メモアプリでazooKeyキーボードを開いて入力
7. **Xcodeのコンソール**（View → Debug Area → Activate Console）にデバッグ出力が表示されます

#### 注意事項
- 通常の`print()`はキーボード拡張では動作しない場合があります
- DEBUGビルドでのみデバッグ出力が有効になります
- コンソールの検索機能を使ってキーワードでフィルタリングすると見やすくなります

macMacのキーボードからシミュレーターに文字が打てるので、azooKeyのキーボードが出てきません。

以下の操作で出てきました。
  シミュレーターのメニューバーで：
  1. I/O → Keyboard → Connect Hardware Keyboardのチェックを外す

毎回必ず、変換候補の先頭に、"テスト候補"を追加する実装を加えてください

## ライブ変換と変換候補の表示の仕組み

### 概要

azooKeyには**ライブ変換（Live Conversion）**という機能があり、入力中にリアルタイムで変換結果を入力エリアに表示します。この機能により、変換候補の先頭に追加した候補が自動的に入力エリアに反映されることがあります。

### 処理の流れ

```
ユーザー入力（例: "aiueo"）
    ↓
InputManager.setResult() が呼ばれる
    ↓
kanaKanjiConverter.requestCandidates() で変換候補を取得
    ↓
results.mainResults に候補が格納される
    ↓
【ここで候補を追加・変更すると影響が出る】
    ↓
liveConversionEnabled == true の場合:
    ↓
LiveConversionManager.updateWithNewResults() に results.mainResults が渡される
    ↓
条件に合う最初の候補が選択され、そのtextが返される
    ↓
DisplayedTextManager.updateComposingText() で入力エリアに表示
```

### 関連するソースコード

#### InputManager.swift の setResult() (約1017-1022行目)
```swift
if liveConversionEnabled {
    let liveConversionText = self.liveConversionManager.updateWithNewResults(
        inputData,
        results.mainResults,  // ← 変更された候補配列がそのまま渡される
        firstClauseResults: results.firstClauseResults,
        convertTargetCursorPosition: inputData.convertTargetCursorPosition,
        convertTarget: inputData.convertTarget
    )
    self.displayedTextManager.updateComposingText(
        composingText: self.composingText,
        newLiveConversionText: liveConversionText  // ← これが入力エリアに表示される
    )
}
```

#### LiveConversionManager.swift の updateWithNewResults() (65-85行目)
```swift
func updateWithNewResults(_ composingText: ComposingText, _ candidates: [Candidate], ...) -> String {
    var candidate: Candidate
    // 条件に合う最初の候補を選択
    if convertTargetCursorPosition > 1,
       let firstCandidate = candidates.first(where: {
           $0.data.map {$0.ruby}.joined().count == convertTarget.count
       }) {
        candidate = firstCandidate
    } else {
        // デフォルト候補を作成
        candidate = .init(text: convertTarget, ...)
    }
    ...
    return candidate.text  // ← この文字列が入力エリアに表示される
}
```

### 「テスト候補」が入力エリアに表示される理由

1. `setResult()`で「テスト候補」を`results.mainResults`の先頭に追加
2. 「テスト候補」は元の候補をコピーして`text`だけ変更しているため、`data`プロパティは元のまま
3. `updateWithNewResults()`の`candidates.first(where:)`の条件（`ruby`の長さが`convertTarget`の長さと一致）を満たす
4. 結果として「テスト候補」が選択され、その`text`（="テスト候補"）が入力エリアに表示される

### 確認方法

設定でライブ変換をオフにすると、追加した候補は入力エリアには表示されず、変換候補バー（リザルトバー）にのみ表示されます。

### 関連ファイル

- `Keyboard/Display/InputManager.swift` - 変換リクエストと結果の処理
- `Keyboard/Display/LiveConversionManager.swift` - ライブ変換ロジック
- `Keyboard/Display/DisplayedTextManager.swift` - 表示テキストの管理


> 分かりました。`ruby`の長さが`convertTarget`の長さと一致の条件を満たしているわけですね

⏺ はい、その通りです。

  具体的には:

  // テスト候補の作成時
  var testCandidate = firstCandidate  // ← 元の候補をコピー
  testCandidate.text = "テスト候補"    // ← textだけ変更
  testCandidate.isLearningTarget = false
  // data は元のまま（rubyの情報を保持）

  そのため、LiveConversionManager.updateWithNewResults()内の条件:

  candidates.first(where: {
      $0.data.map {$0.ruby}.joined().count == convertTarget.count
  })

  この条件で、dataから計算されるrubyの長さは元の候補と同じなので、「テスト候補」が条件を満たして選択されます。

  もしライブ変換に影響を与えずに候補を追加したい場合は、dataのrubyを変更して条件を満たさないようにするか、ライブ変換用の候補選択とは別の箇所で候補を追加する必要があります。

