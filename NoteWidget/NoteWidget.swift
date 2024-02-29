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
/// Query that will fetch only three active note at a time
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
                    .tint(note.tag?.color.gradient)
                    .buttonBorderShape(.circle)
                    
                    //                        VStack {
                    //                            // Image
                    //                            if let imageData = note.image,
                    //                               let uiImage = UIImage(data: imageData) {
                    //                                Image(uiImage: uiImage)
                    //                                    .resizable()
                    //                                    .aspectRatio(contentMode: .fill)
                    //                                    .frame(width: 33, height: 33)
                    //                                    .contentShape(Rectangle())
                    //                                    .clipped()
                    //                            }
                    //                        }
                    //                        .cornerRadius(5)
                    //                        .shadow(color: .black.opacity(0.2), radius: 5, x: 2, y: 3)
                    
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(note.title)
                            .font(.system(size: 15).bold())
                        //                            .font(.caption.bold())
                            .lineLimit(1)
                        
                        Text(note.subTitle)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(3)
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
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(.primary)
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 7, y: 10)
                    .transition(.push(from: .bottom))
            }
        }
    }
    
    static var noteDescriptor: FetchDescriptor<Note> {
        let predicate = #Predicate<Note> { !$0.isCompleted }
        let sort = [SortDescriptor(\Note.date, order: .reverse)]
        
        var descriptor = FetchDescriptor(predicate: predicate, sortBy: sort)
        descriptor.fetchLimit = 2
        return descriptor
    }
    
}

struct NoteWidget: Widget {
    let kind: String = "Note List"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NoteWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            /// Setting up SwiftData Container
                    .modelContainer(for: Note.self)
        }
        .supportedFamilies([.systemMedium])
        .configurationDisplayName("Notes")
        .description("This is a Note List.")
    }
}

#Preview(as: .systemMedium) {
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
            todo.isfavorite = false
            todo.date = .now
            /// Saving Context
            try context.save()
        }
        return .result()
    }
}
