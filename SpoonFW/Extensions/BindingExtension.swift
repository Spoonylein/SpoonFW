//
//  BindingExtension.swift
//  TiNo
//
//  Created by Jan Löffel on 28.08.21.
//

import SwiftUI

extension Binding {
    
    public static func convertOptionalValue<T>(_ optionalValue: Binding<T?>, fallback: T) -> Binding<T> {
        return Binding<T>(get: {
            optionalValue.wrappedValue ?? fallback
        }, set: {
            optionalValue.wrappedValue = $0
        })
    }
    
    public static func convertOptionalString(_ optionalString: Binding<String?>, fallback: String = "") -> Binding<String> {
        convertOptionalValue(optionalString, fallback: fallback)
    }
    
}
