//
//  SmartWidget.swift
//  SmartAssistantCore
//

import WidgetKit
import SwiftUI
#if canImport(ActivityKit)
import ActivityKit
#endif

#if os(iOS)
// 1. Atributos da Live Activity (iOS & Dynamic Island)
public struct AIProcessingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable, Sendable {
        public var currentStep: String
        public var progress: Double
        public var itemsProcessed: Int
        
        public init(currentStep: String, progress: Double, itemsProcessed: Int) {
            self.currentStep = currentStep
            self.progress = progress
            self.itemsProcessed = itemsProcessed
        }
    }

    public var sessionTitle: String
    
    public init(sessionTitle: String) {
        self.sessionTitle = sessionTitle
    }
}

// 2. Visualização na Dynamic Island e Lock Screen
public struct AIProcessingLiveActivity: Widget {
    public init() {}
    
    public var body: some WidgetConfiguration {
        ActivityConfiguration(for: AIProcessingAttributes.self) { context in
            // Lock Screen Banner
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.blue)
                    Text(context.attributes.sessionTitle)
                        .font(.headline)
                    Spacer()
                    Text("\(Int(context.state.progress * 100))%")
                        .font(.subheadline.bold())
                }
                Text(context.state.currentStep)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                ProgressView(value: context.state.progress)
                    .tint(.blue)
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Label(context.attributes.sessionTitle, systemImage: "sparkles")
                        .font(.caption.bold())
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("\(Int(context.state.progress * 100))%")
                        .font(.caption.bold())
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(context.state.currentStep)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                        ProgressView(value: context.state.progress)
                            .tint(.blue)
                    }
                }
            } compactLeading: {
                Image(systemName: "sparkles")
                    .foregroundStyle(.blue)
            } compactTrailing: {
                Text("\(Int(context.state.progress * 100))%")
                    .font(.caption2.bold())
            } minimal: {
                Image(systemName: "sparkles")
                    .foregroundStyle(.blue)
            }
        }
    }
}
#endif