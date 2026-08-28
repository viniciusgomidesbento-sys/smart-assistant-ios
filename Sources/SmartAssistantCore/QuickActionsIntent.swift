//
//  QuickActionsIntent.swift
//  SmartAssistantDemo
//
//  Integração profunda com iOS: Siri, Botão de Ação, Atalhos e Central de Controle
//

import Foundation
import AppIntents

// 1. App Intent que pode ser invocado pelo Botão de Ação ou Siri
public struct ProcessVoiceNoteIntent: AppIntent {
    public static var title: LocalizedStringResource = "Processar Nota com IA"
    public static var description = IntentDescription("Analisa um texto ou nota de voz com a IA On-Device e cria uma tarefa organizada.")

    // Parâmetro de entrada opcional ou solicitado interativamente pela Siri
    @Parameter(title: "Texto da Nota", description: "O conteúdo que você deseja que a IA processe")
    public var inputContent: String

    public init() {}

    public init(content: String) {
        self.inputContent = content
    }

    @MainActor
    public func perform() async throws -> some IntentResult & ProvidesDialog {
        // Executa a IA On-Device
        do {
            let result = try await AIEngine.shared.analyzeText(inputContent)
            
            // Retorna diálogo falado pela Siri ou exibido na interface
            let feedback = "Tarefa criada: '\(result.title)' com prioridade \(result.priority)."
            return .result(dialog: IntentDialog(stringLiteral: feedback))
        } catch {
            return .result(dialog: "Não foi possível processar a nota: \(error.localizedDescription)")
        }
    }
}

// 2. Provedor de Atalhos Globais no Sistema
public struct SmartAssistantShortcuts: AppShortcutsProvider {
    public static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ProcessVoiceNoteIntent(),
            phrases: [
                "Processar nota com \(.applicationName)",
                "Criar tarefa inteligente no \(.applicationName)",
                "Organizar minhas anotações com \(.applicationName)"
            ],
            shortTitle: "IA Inteligente",
            systemImageName: "sparkles"
        )
    }
}
