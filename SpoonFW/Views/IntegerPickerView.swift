//
//  IntegerPickerView.swift
//  TiNo
//
//  Created by Jan Löffel on 25.08.21.
//

import SwiftUI

/// A `Picker` to choose integer values from.
/// - Parameter value: An integer binding to the selected value.
/// - Parameter min: The minimum value to choose from. 0 by default.
/// - Parameter max: The maximum value to choose from. 100 by default.
/// - Parameter step: The step between each value. 1 by default.
/// - Parameter unitString: The unit to show trailing to the value. Empty by default.
public struct IntegerPickerView: View {
    
    /// The integer value to bind to.
    @Binding var value: Int
    @State private var min: Int
    @State private var max: Int
    @State private var step: Int
    @State private var unitString: String
    
    public var body: some View {
        let numbers: [Int] = Array(stride(from: min, through: max, by: step))

        let charCount: Int = Int("\(numbers.max()!)".count)
        let formatString: String = "%0\(charCount)d"

        HStack(spacing: 0) {
                Picker(selection: $value, label: EmptyView())  {
                    ForEach(numbers, id: \.self) {number in
                        Text(String(format: formatString, number))
                            .tag(number)
                            .font(.system(.body, design: .monospaced))
                    }
                }
            
            if !unitString.trim().isEmpty {
                Text(unitString)
                    .font(.callout)
                    .fontWeight(.light)
                    .padding(.leading, -5)
            }
        }
        .animation(.default, value: value)
        .pickerStyle(.wheel)
    }
    
    public init(value: Binding<Int>, min: Int = 0, max: Int = 100, step: Int = 1, unitString: String = "") {
        self._value = value
        self.min = min
        self.max = max
        self.step = step
        self.unitString = unitString
    }
}

struct IntegerPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IntegerPickerView(value: .constant(42), unitString: String(localized: "DaysUnit"))
            .previewLayout(.sizeThatFits)
    }
}


