//
//  QuickActionsIntent.swift
//  SmartAssistantCore
//

import Foundation
#if canImport(AppIntents)
import AppIntents

// 1. App Intent que pode ser invocado pelo Botão de Ação ou Siri
public struct ProcessVoiceNoteIntent: AppIntent {
    public static let title: LocalizedStringResource = "Processar Nota com IA"
    public static let description = IntentDescription("Analisa um texto ou nota de voz com a IA On-Device e cria uma tarefa organizada.")

    @Parameter(title: "Texto da Nota", description: "O conteúdo que você deseja que a IA processe")
    public var inputContent: String

    public init() {}

    public init(content: String) {
        self.inputContent = content
    }

    @MainActor
    public func perform() async throws -> some IntentResult & ProvidesDialog {
        do {
            let result = try await AIEngine.shared.analyzeText(inputContent)
            let feedback = "Tarefa criada: '\(result.title)' com prioridade \(result.priority)."
            return .result(dialog: IntentDialog(stringLiteral: feedback))
        } catch {
            return .result(dialog: "Não foi possível processar a nota: \(error.localizedDescription)")
        }
    }
}

// 2. Provedor de Atalhos Globais no Sistema
public struct SmartAssistantShortcuts: AppShortcutsProvider {
    @MainActor
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
#endif