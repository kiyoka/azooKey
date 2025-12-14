//
//  OpenAICompatibleAPIService.swift
//  azooKey
//
//  Created by kiyoka on 2025/12/07.
//  Copyright © 2025 kiyoka. All rights reserved.
//

import AzooKeyUtils
import Foundation
import OpenAI

/// OpenAI互換APIへのアクセスを管理するActor
public actor OpenAICompatibleAPIService {

    // MARK: - Types

    public struct CompletionResult: Sendable {
        public let candidates: [String]
    }

    public enum ServiceError: Error, Sendable {
        case notConfigured
        case apiError(any Error)
    }

    // MARK: - Singleton

    public static let shared = OpenAICompatibleAPIService()

    // MARK: - Properties

    private var currentTask: Task<CompletionResult, any Error>?
    private var lastRequestTime: Date?
    private let minRequestInterval: TimeInterval = 0.3

    // MARK: - Configuration

    @MainActor
    private func getClient() -> OpenAI? {
        @KeyboardSetting(.openAICompatibleAPIKey) var apiKey
        @KeyboardSetting(.enableOpenAICompatibleAPI) var enabled
        guard enabled, !apiKey.isEmpty else { return nil }
        return OpenAI(apiToken: apiKey)
    }

    // MARK: - Public Methods

    public func getCompletionCandidates(for input: String, context: String? = nil) async throws -> CompletionResult {
        guard let client = await getClient() else {
            throw ServiceError.notConfigured
        }

        // レート制限チェック
        if let lastTime = lastRequestTime {
            let elapsed = Date().timeIntervalSince(lastTime)
            if elapsed < minRequestInterval {
                try await Task.sleep(nanoseconds: UInt64((minRequestInterval - elapsed) * 1_000_000_000))
            }
        }

        currentTask?.cancel()

        let task = Task {
            try await performRequest(client: client, input: input, context: context)
        }
        currentTask = task
        lastRequestTime = Date()

        return try await task.value
    }

    public func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }

    // MARK: - Private

    private func performRequest(client: OpenAI, input: String, context: String?) async throws -> CompletionResult {
        // SIMPLE_PROMPT_V2
        let instructions = ""
        let userPrompt: String
        if let context {
            userPrompt = """
            文脈: \(context)

            以下はタイプミスを含む可能性があるローマ字入力です。正しい日本語（漢字仮名交じり）に変換してください。
            変換結果のみを出力し、説明は不要です。

            \(input)
            """
        } else {
            userPrompt = """
            以下はタイプミスを含む可能性があるローマ字入力です。正しい日本語（漢字仮名交じり）に変換してください。
            変換結果のみを出力し、説明は不要です。

            \(input)
            """
        }

        do {
            // Responses API を使用（GPT-5.2 + reasoning設定）
            // GPT-5.2がサポートするeffortは: none, low, medium, high
            // ライブラリにnoneがないため、lowを使用
            let query = CreateModelResponseQuery(
                input: .textInput(userPrompt),
                model: "gpt-5.2",
                instructions: instructions,
                maxOutputTokens: 100,
                reasoning: Components.Schemas.Reasoning(
                    effort: .low,
                    summary: .concise
                )
            )

            let result = try await client.responses.createResponse(query: query)

            // レスポンスからテキストを抽出
            var text = ""
            for outputItem in result.output {
                if case .outputMessage(let outputMessage) = outputItem {
                    for content in outputMessage.content {
                        if case .OutputTextContent(let textContent) = content {
                            text = textContent.text
                            break
                        }
                    }
                }
            }

            let candidates = text.components(separatedBy: CharacterSet.newlines)
                .map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
                .filter { !$0.isEmpty }

            return CompletionResult(candidates: candidates)
        } catch {
            throw ServiceError.apiError(error)
        }
    }
}
