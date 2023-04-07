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

        HStack(alignment: .center, spacing: 2) {
            let alphaGradient: Gradient = Gradient(stops:
                                                    [Gradient.Stop(color: Color.black, location: 0.0),
                                                     Gradient.Stop(color: Color.white, location: 0.33),
                                                     Gradient.Stop(color: Color.white, location: 0.67),
                                                     Gradient.Stop(color: Color.black, location: 1.0)])
            
            Picker(selection: $value, label: Text(localizedString("PickerTitleIntegerPicker"))) {
                ForEach(numbers, id: \.self) {number in
                    Text(String(format: formatString, number))
                        .font(.system(.title, design: .monospaced))
                        .fixedSize()
                }
            }
            .frame(maxWidth: .infinity)
            .clipped()
            .mask(LinearGradient(gradient: alphaGradient, startPoint: .top, endPoint: .bottom).luminanceToAlpha())
            
            if !unitString.trim().isEmpty {
                Text(unitString)
                    .font(.system(.title2, design: .monospaced))
            }
        }
        .fixedSize()
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
        IntegerPickerView(value: .constant(10), unitString: localizedString("DaysUnit"))
    }
}


