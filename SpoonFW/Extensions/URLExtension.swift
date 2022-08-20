//
//  URLExtension.swift
//  SpoonFW
//
//  Created by Jan Löffel on 10.10.21.
//

import Foundation
import SwiftUI

extension URL {
    /// Creates a image from given system image name, saves it to disk and return a URL to it.
    public static func createLocalUrl(forSystemImageNamed name: String) -> URL? {
        let guid = UUID()
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(guid.uuidString).png")
        let path = url.path
        
        guard
            let image = UIImage(systemName: name)?.withTintColor(UIColor.label).applyingSymbolConfiguration(.init(scale: .small)) ,
            let data = image.pngData()
        else { return nil }
        
        fileManager.createFile(atPath: path, contents: data, attributes: nil)
        
        return url
    }
}
