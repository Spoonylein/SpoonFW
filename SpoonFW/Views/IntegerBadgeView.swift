//
//  IntegerBadgeView.swift
//  TiNo
//
//  Created by Jan Löffel on 16.09.21.
//

import SwiftUI

public struct IntegerBadgeView: View {
    @Binding var value: Int
    var backgroundColor: Color = Color(UIColor.systemRed)
    var foregroundColor: Color = Color.white
    var borderColor: Color? = nil
    
    public var body: some View {
        let size: CGFloat = 16
        
        if let _borderColor = borderColor {
            Text("\(value)").font(.caption).bold()
                .frame(minWidth: size, minHeight: size)
                .padding(2)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(_borderColor, lineWidth: 1.5))
        } else {
            Text("\(value)").font(.caption).bold()
                .frame(minWidth: size, minHeight: size)
                .padding(2)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .clipShape(Capsule())
        }
    }
    
    public init(value: Binding<Int>, backgroundColor: Color = Color(UIColor.systemRed), foregroundColor: Color = Color.white, borderColor: Color? = nil) {
        self._value = value
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.borderColor = borderColor
    }
}

struct IntegerBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        IntegerBadgeView(value: .constant(42))
    }
}
