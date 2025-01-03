//
//  Composer.swift
//  SwiftUI AdaptiveImageGlyph
//
//  Created by Aether on 03/01/2025.
//

import SwiftUI

struct Composer: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var richText = NSAttributedString(string: "", attributes: [
        .font: UIFont.preferredFont(forTextStyle: .title2)
    ])
    @Environment(\.dismiss) var dismiss
    var item: Item? = nil
    
    var body: some View {
        NavigationStack{
            ScrollView{
                RichTextEditor(attributedText: $richText)
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .strokeBorder(
                                Color.gray.opacity(0.03),
                                style: StrokeStyle(
                                    lineWidth: 0.6,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 13))
                    .overlay(
                        RoundedRectangle(cornerRadius: 13, style: .continuous)
                            .stroke(Color.black.opacity(0.3), lineWidth: 0.7)
                    )
                
                    .padding(.horizontal, 20)
                    .padding(.top)
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button("Save") {
                        save()
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func save() {
        let saveItem = item ?? Item(context: viewContext)
        if item == nil{
            saveItem.id = UUID()
        }
        saveItem.timestamp = Date()
        
        // Extract contents of text view as an attributed string
        let textContents = richText
        
        do {
            // Serialize as data for storage or transport
            let rtfData = try textContents.data(from: NSRange(location: 0, length: textContents.length), documentAttributes: [.documentType: NSAttributedString.DocumentType.rtfd])
            
            saveItem.richText = rtfData
        }catch {
            let nsError = error as NSError
            print("Failed to create rtfData: \(nsError), \(nsError.userInfo)")
        }
        // Assign serialized data to the Core Data attribute
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            let nsError = error as NSError
            print("Failed to save Item: \(nsError), \(nsError.userInfo)")
        }
    }
}

#Preview {
    Composer()
}
