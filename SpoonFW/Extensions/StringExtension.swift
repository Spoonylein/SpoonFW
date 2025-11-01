    //
//  StringExtension.swift
//  TiNo
//
//  Created by Jan Löffel on 28.08.21.
//

import Foundation

public extension String {
    
    /// Trims the `String` by removing leading and trailing spaces.
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet(charactersIn: " "))
    }
    
    func left(idx: Int = 0) -> String {
            String(self[index(startIndex, offsetBy: idx)])
        }
}
