//
//  ContentView.swift
//  SwiftUI AdaptiveImageGlyph
//
//  Created by Aether on 03/01/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State var showComposer: Bool = false
    
    @ViewBuilder
    func rowContent(item: Item) -> some View {
        HStack {
            Text(loadText(for: item) ?? "😔")
                .font(.title)
            Spacer()
            Text(item.timestamp!, style: .relative)
                .foregroundStyle(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 5)
    }
    
    @ViewBuilder
    func rowDestination(item: Item) -> some View {
        ScrollView{
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 75, maximum: 500))], spacing: 20) {
                ForEach(FontStyles.allCases, id: \.self) { style in
                    if let text = loadText(for: item, style: style.font) {
                        Text(text)
                            .font(style.font)
                    } else {
                        Text("😔").font(style.font)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(items, id: \.id) { item in
                    NavigationLink {
                        rowDestination(item: item)
                    } label: {
                        rowContent(item: item)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { showComposer.toggle() }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationTitle("SwiftUI AdaptiveImageGlyph")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showComposer) {
                Composer()
                    .presentationDetents([.medium])
                    .presentationCornerRadius(30)
            }
        }
    }
    
    private func loadText(for item: Item, style: Font = .title) -> AttributedString? {
        if let rtfData = item.richText, rtfData.isEmpty == false {
            do {
                let textFromData = try NSAttributedString(
                    data: rtfData,
                    options: [.documentType: NSAttributedString.DocumentType.rtfd],
                    documentAttributes: nil
                )
                var attributedString = AttributedString(textFromData)
                
                if attributedString.characters.isEmpty {
                    return nil
                } else {
                    attributedString.font = style
                    return attributedString
                }
            } catch {
                let nsError = error as NSError
                print("Failed to load rich text: \(nsError), \(nsError.userInfo)")
            }
        } else {
            print("No rich text available to load.")
        }
        return nil
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
