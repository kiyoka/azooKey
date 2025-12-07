//
//  OpenAICompatibleAPISettingKeys.swift
//  azooKey
//
//  Created by kiyoka on 2025/12/07.
//  Copyright © 2025 kiyoka. All rights reserved.
//

import Foundation
import SwiftUI

/// OpenAI Compatible API のAPIキー設定
public struct OpenAICompatibleAPIKey: KeyboardSettingKey, StoredInUserDefault {
    public static let title: LocalizedStringKey = "APIキー"
    public static let explanation: LocalizedStringKey = "OpenAI互換APIを利用するためのAPIキーを設定します。"
    public static let defaultValue: String = ""
    public static let key: String = "openai_compatible_api_key"
    public static let requireFullAccess: Bool = true

    @MainActor public static var value: String {
        get { SharedStore.userDefaults.string(forKey: key) ?? defaultValue }
        set { SharedStore.userDefaults.set(newValue, forKey: key) }
    }
}

public extension KeyboardSettingKey where Self == OpenAICompatibleAPIKey {
    static var openAICompatibleAPIKey: Self { .init() }
}

/// OpenAI Compatible API機能の有効/無効
public struct EnableOpenAICompatibleAPI: BoolKeyboardSettingKey {
    public static let title: LocalizedStringKey = "OpenAI互換API機能を有効化"
    public static let explanation: LocalizedStringKey = "OpenAI互換APIを利用した変換候補を表示します。"
    public static let defaultValue = false
    public static let key: String = "enable_openai_compatible_api"
    public static let requireFullAccess: Bool = true
}

public extension KeyboardSettingKey where Self == EnableOpenAICompatibleAPI {
    static var enableOpenAICompatibleAPI: Self { .init() }
}
