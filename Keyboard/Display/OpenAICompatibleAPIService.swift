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
        case apiError(Error)
    }

    // MARK: - Singleton

    public static let shared = OpenAICompatibleAPIService()

    // MARK: - Properties

    private var currentTask: Task<CompletionResult, Error>?
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
        let instructions = "あなたは日本語入力の変換候補を提案するアシスタントです。"
        let userPrompt: String
        if let context {
            userPrompt = "文脈: \(context)\n入力: \(input)\n最も適切な変換候補を3つ、改行区切りで出力してください。"
        } else {
            userPrompt = "入力: \(input)\n最も適切な変換候補を3つ、改行区切りで出力してください。"
        }

        do {
            // Chat Completions API を使用
            let query = ChatQuery(
                messages: [
                    .system(.init(content: .textContent(instructions))),
                    .user(.init(content: .string(userPrompt))),
                ],
                model: .gpt4_o_mini,
                maxCompletionTokens: 100
            )

            let result = try await client.chats(query: query)
            let text = result.choices.first?.message.content ?? ""

            let candidates = text.components(separatedBy: CharacterSet.newlines)
                .map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
                .filter { !$0.isEmpty }

            return CompletionResult(candidates: candidates)
        } catch {
            throw ServiceError.apiError(error)
        }
    }
}
