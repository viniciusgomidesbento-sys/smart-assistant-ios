//
//  AIEngine.swift
//  SmartAssistantCore
//

import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

// 1. Definição do Tipo de Saída Estruturada
#if canImport(FoundationModels)
@available(macOS 26.0, iOS 18.0, visionOS 2.0, watchOS 11.0, *)
@Generable
public struct TaskAnalysisResult: Sendable, Codable {
    public var title: String
    public var summary: String
    public var priority: String
    public var suggestedDeadline: String?

    public init(title: String, summary: String, priority: String, suggestedDeadline: String? = nil) {
        self.title = title
        self.summary = summary
        self.priority = priority
        self.suggestedDeadline = suggestedDeadline
    }
}
#else
public struct TaskAnalysisResult: Sendable, Codable {
    public var title: String
    public var summary: String
    public var priority: String
    public var suggestedDeadline: String?
    
    public init(title: String, summary: String, priority: String, suggestedDeadline: String? = nil) {
        self.title = title
        self.summary = summary
        self.priority = priority
        self.suggestedDeadline = suggestedDeadline
    }
}
#endif

// 2. Serviço de Execução de IA On-Device
@available(macOS 26.0, iOS 18.0, visionOS 2.0, watchOS 11.0, *)
@Observable
public final class AIEngine: @unchecked Sendable {
    public static let shared = AIEngine()
    
    public init() {}
    
    public func analyzeText(_ rawText: String) async throws -> TaskAnalysisResult {
        #if canImport(FoundationModels)
        let session = LanguageModelSession()
        let prompt = """
        Analise o texto fornecido pelo usuário e extraia uma tarefa organizada.
        Texto do usuário:
        "\(rawText)"
        """
        return try await session.generate(TaskAnalysisResult.self, prompt: prompt)
        #else
        return TaskAnalysisResult(
            title: "Tarefa Processada",
            summary: rawText,
            priority: "medium",
            suggestedDeadline: nil
        )
        #endif
    }
}