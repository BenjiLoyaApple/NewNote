//
//  NoteWidget.swift
//  NoteWidget
//
//  Created by Benji Loya on 10.02.2024.
//

import WidgetKit
import SwiftUI
import SwiftData
import AppIntents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        let entry = SimpleEntry(date: .now)
        entries.append(entry)

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct NoteWidgetEntryView : View {
    var entry: Provider.Entry
/// Query that will fetch only three active todo at a time
    @Query(noteDescriptor, animation: .snappy) private var activeList: [Note]
    var body: some View {
        VStack {
            ForEach(activeList) { note in
                HStack(spacing: 10) {
                    ///  Intent Action Button
                    Button(intent: ToggleButton(id: note.noteID)) {
                        Image(systemName: "circle")
                    }
                    .font(.callout)
                    .tint(note.tag.color.gradient)
                    .buttonBorderShape(.circle)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(note.title)
                            .font(.callout.bold())
                            .lineLimit(1)
                        
                        Text(note.subTitle)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                        
                    }
                    
                    
                    Spacer(minLength: 0)
                }
                .transition(.push(from: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if activeList.isEmpty {
                Text("No Entires")
                    .font(.title3.bold())
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var noteDescriptor: FetchDescriptor<Note> {
        let predicate = #Predicate<Note> { !$0.isCompleted }
        let sort = [SortDescriptor(\Note.date, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 3
        return descriptor
    }
    
}

struct NoteWidget: Widget {
    let kind: String = "Todo List"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NoteWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            /// Setting up SwiftData Container
                    .modelContainer(for: Note.self)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Tasks")
        .description("This is a Todo List.")
    }
}

#Preview(as: .systemSmall) {
    NoteWidget()
} timeline: {
    SimpleEntry(date: .now)
}

// Button Intent Which Will Update the todo status
struct ToggleButton: AppIntent {
    static var title: LocalizedStringResource = .init(stringLiteral: "Toggle's Note State")
    
    @Parameter(title: "Note ID")
    var id: String
    
    init() {
        
    }
    
    init(id: String) {
        self.id = id
    }
    
    func perform() async throws -> some IntentResult {
        /// Updating Todo Status
        let context = try ModelContext(.init(for: Note.self))
        /// Retreiving Recpective Todo
        let descriptor = FetchDescriptor(predicate: #Predicate<Note> { $0.noteID == id })
        if let todo = try context.fetch(descriptor).first {
            todo.isCompleted = true
            todo.date = .now
            /// Saving Context
            try context.save()
        }
        return .result()
    }
}
