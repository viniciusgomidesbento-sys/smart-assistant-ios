//
//  SmartWidget.swift
//  SmartAssistantDemo
//
//  WidgetKit, Live Activity (Dynamic Island & Lock Screen) e Control Center Button
//

import WidgetKit
import SwiftUI
import ActivityKit

// 1. Atributos da Live Activity (Dynamic Island & Lock Screen)
public struct AIProcessingAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var currentStep: String
        public var progress: Double
        public var itemsProcessed: Int
    }

    public var sessionTitle: String
}

// 2. Visualização na Dynamic Island e Lock Screen
public struct AIProcessingLiveActivity: Widget {
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
            // Dynamic Island Expanded & Compact
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
