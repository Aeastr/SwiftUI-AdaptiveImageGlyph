//
//  RichTextEditor.swift
//  SwiftUI AdaptiveImageGlyph
//
//  Created by Aether on 03/01/2025.
//


#if canImport(UIKit)
import SwiftUI
import UIKit

struct RichTextEditor: UIViewRepresentable {
    @Binding var attributedText: NSAttributedString
    var onEditingChanged: ((Bool) -> Void)? = nil
    var onCommit: (() -> Void)? = nil

    class Coordinator: NSObject, UITextViewDelegate {
        var parent: RichTextEditor

        init(_ parent: RichTextEditor) {
            self.parent = parent
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            print("textViewDidBeginEditing")
            parent.onEditingChanged?(true)
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            print("textViewDidEndEditing")
            parent.onEditingChanged?(false)
            parent.onCommit?()
        }

        func textViewDidChange(_ textView: UITextView) {
            print("textViewDidChange")
            // Update the attributedText binding only if the text changes
            if textView.attributedText != parent.attributedText {
                parent.attributedText = textView.attributedText
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> EmojiTextView {
        let textView = EmojiTextView()
        textView.delegate = context.coordinator
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.supportsAdaptiveImageGlyph = true

        // Set initial attributed text
        textView.attributedText = attributedText

//        // Set text size
//        textView.typingAttributes = [
//            .font: CGFloat(48),
//        ]
        
        // Adjust text container inset for padding
        textView.textContainerInset = UIEdgeInsets(top: 15, left: 12, bottom: 15, right: 12)

        return textView
    }

    func updateUIView(_ uiView: EmojiTextView, context: Context) {
        print("updateUIView")

        // only set text if it differs
        if uiView.attributedText != attributedText {
            uiView.attributedText = attributedText
        }
    }
}

class EmojiTextView: UITextView {
    // Return a non-nil identifier to help the system show the emoji keyboard
    override var textInputContextIdentifier: String? { "" }

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        // If no emoji keyboard is available, fallback to the default behavior
        return super.textInputMode
    }
}
#endif
