//
//  ViewExtension.swift
//  TiNo
//
//  Created by Jan Löffel on 28.08.21.
//

import SwiftUI

extension View {
    
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    /// ```
    /// Text("Label")
    ///     .isHidden(true)
    /// ```
    ///
    /// Example for complete removal:
    /// ```
    /// Text("Label")
    ///     .isHidden(true, remove: true)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder public func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
    
    /// Add a glow effect to the view.
    /// - Parameters:
    ///   - color: The color for the view, `.primary` if ommitted.
    ///   - radius: The radius of the glow.
    /// - Returns: The `View` itself with the glow added.
    public func glow(color: Color = .primary, radius: Double) -> some View {
        self
            .shadow(color: color, radius: radius, x: 0, y: 0)
            .shadow(color: color, radius: radius, x: -radius * 3.0, y: 0)
            .shadow(color: color, radius: radius, x: radius * 3.0, y: 0)
    }
}
