//
//  DateExtension.swift
//  TiNo
//
//  Created by Jan Löffel on 08.09.21.
//

import Foundation

public extension Date {
    
    /// Converts the date and return it as a `String` in format "dd.MM.yyyy, HH:mm:ss".
    func toString() -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd.MM.yyyy, HH:mm:ss"
        return dateformatter.string(from: self)
    }
}
