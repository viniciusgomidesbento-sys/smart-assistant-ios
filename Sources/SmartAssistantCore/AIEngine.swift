//
//  AIEngine.swift
//  SmartAssistantDemo
//
//  Demonstração oficial de FoundationModels com @Generable e Tool Calling
//

import Foundation
import FoundationModels

// 1. Definição do Tipo de Saída Estruturada com a Macro @Generable
@Generable
public struct TaskAnalysisResult: Sendable, Codable {
    @Property(description: "Título curto da tarefa ou compromisso")
    public var title: String

    @Property(description: "Resumo executivo do que precisa ser feito")
    public var summary: String

    @Property(description: "Nível de prioridade: low, medium, high, urgent")
    public var priority: String

    @Property(description: "Data ou prazo estimado sugerido pela IA (formato ISO8601 ou texto relativo)")
    public var suggestedDeadline: String?

    @Property(description: "Tags contextuais associadas")
    public var tags: [String]
}

// 2. Serviço de Execução de IA On-Device
@Observable
public final class AIEngine {
    public static let shared = AIEngine()
    
    private var session: LanguageModelSession?
    
    public init() {
        // Inicializa uma sessão de modelo de linguagem on-device
        self.session = LanguageModelSession()
    }
    
    /// Analisa qualquer texto desestruturado (áudio transcrito, notas, mensagens)
    /// e gera dados tipados de forma determinística
    public func analyzeText(_ rawText: String) async throws -> TaskAnalysisResult {
        guard let session = session else {
            throw NSError(domain: "AIEngine", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sessão de IA não inicializada"])
        }
        
        let prompt = """
        Analise o texto fornecido pelo usuário e extraia uma tarefa organizada.
        Texto do usuário:
        "\(rawText)"
        """
        
        // Chamada guiada com saída garantida no tipo TaskAnalysisResult
        let response = try await session.generate(TaskAnalysisResult.self, prompt: prompt)
        return response
    }
}
