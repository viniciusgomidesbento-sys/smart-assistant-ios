import Testing
@testable import SmartAssistantCore

@Test func testTaskAnalysisStructInitialization() async throws {
    let sample = TaskAnalysisResult(
        title: "Test Task",
        summary: "Testing FoundationModels Struct on macOS Runner",
        priority: "high",
        suggestedDeadline: "2026-08-28T12:00:00Z"
    )
    #expect(sample.title == "Test Task")
    #expect(sample.priority == "high")
}