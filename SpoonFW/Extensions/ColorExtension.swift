//
//  ColorExtension.swift
//  TiNo
//
//  Created by Jan Löffel on 28.08.21.
//

import SwiftUI

public extension Color {
    
    /// Lightens up the `Color` object by given percentage
    /// - Parameter percentage: The brightness value will be increased by this percentage value
    func lighter(by percentage: CGFloat = 25.0) -> Color {
        if percentage <= 0.0 { return self }
        
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0

        let uiColor = UIColor(self)
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
                
        return Color(UIColor(hue: h,
                             saturation: max(s - (s / 100.0 * percentage), 0.0),
                             brightness: min(b + (b / 100.0 * percentage), 1.0),
                             alpha: a))
    }
    
    /// Darkens the `Color` object by given percentage
    /// - Parameter percentage: The brightness value will be decreased by this percentage value
    func darker(by percentage: CGFloat = 25.0) -> Color {
        if percentage <= 0.0 { return self }
        
        var h: CGFloat = 0.0
        var s: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        
        let uiColor = UIColor(self)
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        return Color(UIColor(hue: h,
                             saturation: min(s + (s / 100.0 * percentage), 1.0),
                             brightness: max(b - (b / 100.0 * percentage), 0.0),
                             alpha: a))
    }
}
