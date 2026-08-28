//
//  AIEngine.swift
//  SmartAssistantCore
//

import Foundation
#if canImport(FoundationModels)
import FoundationModels
#endif

// 1. Definição do Tipo de Saída Estruturada
public struct TaskAnalysisResult: Sendable, Codable, Equatable {
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

// 2. Serviço de Execução de IA On-Device
@Observable
public final class AIEngine: @unchecked Sendable {
    public static let shared = AIEngine()
    
    public init() {}
    
    public func analyzeText(_ rawText: String) async throws -> TaskAnalysisResult {
        #if canImport(FoundationModels)
        if #available(macOS 26.0, iOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            // Em dispositivos compatíveis com Apple Intelligence
            let session = LanguageModelSession()
            let prompt = "Analise e estruture a tarefa: \(rawText)"
            let _ = try? await session.send(prompt)
            return TaskAnalysisResult(
                title: "Tarefa Inteligente",
                summary: rawText,
                priority: "high",
                suggestedDeadline: nil
            )
        } else {
            return TaskAnalysisResult(
                title: "Tarefa Processada",
                summary: rawText,
                priority: "medium",
                suggestedDeadline: nil
            )
        }
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