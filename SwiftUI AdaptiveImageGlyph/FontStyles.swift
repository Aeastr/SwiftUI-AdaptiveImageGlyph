//
//  FontStyles.swift
//  SwiftUI AdaptiveImageGlyph
//
//  Created by Aether on 03/01/2025.
//

import SwiftUI

enum FontStyles: CaseIterable {
    case custom3
    case custom2
    case custom
    case title
    case title2
    case title3
    case headline
    case subheadline
    case body
    case callout
    case caption
    case caption2
    case footnote

    var font: Font {
        switch self {
        case .custom3: return .system(size: 78)
        case .custom2: return .system(size: 65)
        case .custom: return .system(size: 50)
        case .title: return .title
        case .title2: return .title2
        case .title3: return .title3
        case .headline: return .headline
        case .subheadline: return .subheadline
        case .body: return .body
        case .callout: return .callout
        case .caption: return .caption
        case .caption2: return .caption2
        case .footnote: return .footnote
        }
    }
}
