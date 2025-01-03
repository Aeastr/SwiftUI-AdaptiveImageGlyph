//
//  RichTextEditor.swift
//  SwiftUI AdaptiveImageGlyph
//
//  Created by Aether on 03/01/2025.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

/// A SwiftUI wrapper for `UITextView` that supports rich text editing and emoji keyboard adaptation.
struct RichTextEditor: UIViewRepresentable {
    @Binding var attributedText: NSAttributedString
    var fontSize: CGFloat = 50
    var onEditingChanged: ((Bool) -> Void)? = nil
    var onCommit: (() -> Void)? = nil
    
    // Coordinator to manage the delegate callbacks of UITextView
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor
        
        init(_ parent: RichTextEditor) {
            self.parent = parent
        }
        
        /// Called when the text view begins editing.
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.onEditingChanged?(true)
        }
        
        /// Called when the text view ends editing.
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.onEditingChanged?(false)
            parent.onCommit?()
        }
        
        /// Called when the text view's content changes.
        func textViewDidChange(_ textView: UITextView) {
            // Update the `attributedText` binding only if there is a change
            if textView.attributedText != parent.attributedText {
                parent.attributedText = textView.attributedText
            }
        }
    }
    
    /// Creates a coordinator instance to manage the UITextView's delegate.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    /// Creates and configures the `EmojiTextView` instance.
    func makeUIView(context: Context) -> EmojiTextView {
        let textView = EmojiTextView()
        textView.delegate = context.coordinator // Set the delegate to the coordinator
        textView.isEditable = true // Allow text editing
        textView.isScrollEnabled = false // Disable scrolling for the text view
        textView.backgroundColor = .clear // Transparent background for the text view
        
        // MARK: Enable adaptive image glyphs
        textView.supportsAdaptiveImageGlyph = true
        
        // Set the initial attributed text
        textView.attributedText = attributedText
        
        // Configure initial typing attributes with font size
        textView.typingAttributes = [
            .font: UIFont.systemFont(ofSize: fontSize)
        ]
        
        // Configure padding for the text container
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 12, bottom: 15, right: 12)
        
        return textView
    }
    
    /// Updates the `EmojiTextView` with new data when the SwiftUI state changes.
    func updateUIView(_ uiView: EmojiTextView, context: Context) {
        // Update the text only if the content has changed
        if uiView.attributedText != attributedText {
            uiView.attributedText = attributedText
        }
    }
}

/// A custom `UITextView` subclass that prioritizes the emoji keyboard when active.
class EmojiTextView: UITextView {
    /// Provides a non-nil identifier to encourage the system to show the emoji keyboard.
    override var textInputContextIdentifier: String? { "" }
    
    /// Overrides the text input mode to prioritize the emoji keyboard when available.
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        // Fallback to the default input mode if no emoji keyboard is active
        return super.textInputMode
    }
}
#endif
