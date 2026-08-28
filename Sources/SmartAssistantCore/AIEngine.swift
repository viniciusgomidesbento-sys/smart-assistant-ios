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
@Generable
public struct TaskAnalysisResult: Sendable, Codable {
    @Property(description: "Título curto da tarefa ou compromisso")
    public var title: String

    @Property(description: "Resumo executivo do que precisa ser feito")
    public var summary: String

    @Property(description: "Nível de prioridade: low, medium, high, urgent")
    public var priority: String

    @Property(description: "Data ou prazo estimado sugerido pela IA")
    public var suggestedDeadline: String?

    @Property(description: "Tags contextuais associadas")
    public var tags: [String]
    
    public init(title: String, summary: String, priority: String, suggestedDeadline: String? = nil, tags: [String] = []) {
        self.title = title
        self.summary = summary
        self.priority = priority
        self.suggestedDeadline = suggestedDeadline
        self.tags = tags
    }
}
#else
public struct TaskAnalysisResult: Sendable, Codable {
    public var title: String
    public var summary: String
    public var priority: String
    public var suggestedDeadline: String?
    public var tags: [String]
    
    public init(title: String, summary: String, priority: String, suggestedDeadline: String? = nil, tags: [String] = []) {
        self.title = title
        self.summary = summary
        self.priority = priority
        self.suggestedDeadline = suggestedDeadline
        self.tags = tags
    }
}
#endif

// 2. Serviço de Execução de IA On-Device
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
            suggestedDeadline: nil,
            tags: ["fallback", "ai"]
        )
        #endif
    }
}