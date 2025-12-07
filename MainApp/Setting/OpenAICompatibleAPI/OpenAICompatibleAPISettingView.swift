//
//  OpenAICompatibleAPISettingView.swift
//  MainApp
//
//  Created by kiyoka on 2025/12/07.
//  Copyright © 2025 kiyoka. All rights reserved.
//

import AzooKeyUtils
import KeyboardViews
import SwiftUI

struct OpenAICompatibleAPISettingView: View {
    @State private var showRequireFullAccessAlert = false
    @State private var enableSetting: SettingUpdater<EnableOpenAICompatibleAPI>
    @State private var apiKey: String = ""

    @MainActor init() {
        self._enableSetting = .init(initialValue: .init())
    }

    var body: some View {
        Form {
            Section {
                Toggle(isOn: $enableSetting.value) {
                    HStack {
                        Text(EnableOpenAICompatibleAPI.title)
                        HelpAlertButton(
                            title: EnableOpenAICompatibleAPI.title,
                            explanation: EnableOpenAICompatibleAPI.explanation
                        )
                        Image(systemName: "f.circle.fill")
                            .foregroundStyle(.purple)
                    }
                }
                .toggleStyle(.switch)
                .disabled(disabled)
                .onTapGesture {
                    if disabled {
                        showRequireFullAccessAlert = true
                    }
                }
            } footer: {
                Text("OpenAI互換APIを利用して、タイプミスの修正候補を表示します。この機能にはフルアクセスが必要です。")
            }

            if enableSetting.value {
                Section {
                    SecureField("APIキー", text: $apiKey)
                        .textContentType(.password)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .onChange(of: apiKey) { _, newValue in
                            OpenAICompatibleAPIKey.value = newValue
                        }
                } header: {
                    Text("APIキー")
                } footer: {
                    Text("OpenAI APIキーを入力してください。このキーは端末内に安全に保存されます。")
                }

                Section {
                    Text("APIキーの取得方法")
                        .font(.headline)
                    Text("1. OpenAIのウェブサイトにアクセス")
                    Text("2. アカウントを作成またはログイン")
                    Text("3. API Keysページで新しいキーを作成")
                    FallbackLink("OpenAI Platform", destination: URL(string: "https://platform.openai.com/api-keys")!)
                }
            }
        }
        .navigationTitle("OpenAI互換API")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            enableSetting.reload()
            apiKey = OpenAICompatibleAPIKey.value
        }
        .alert(EnableOpenAICompatibleAPI.explanation, isPresented: $showRequireFullAccessAlert) {
            Button("キャンセル", role: .cancel) {
                showRequireFullAccessAlert = false
            }
            if let url = URL(string: UIApplication.openSettingsURLString) {
                Button("「設定」アプリを開く") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    showRequireFullAccessAlert = false
                }
            }
        } message: {
            Text("この機能にはフルアクセスが必要です。この機能を使いたい場合は、「設定」>「キーボード」でフルアクセスを有効にしてください。")
        }
    }

    @MainActor private var disabled: Bool {
        !SemiStaticStates.shared.hasFullAccess
    }
}
