//
//  ViewController.swift
//  SpoonFW
//
//  Created by Jan Löffel on 14.10.22.
//

import Foundation
import SwiftUI

public class ViewController: ObservableObject {
    public static let shared = ViewController()
    
    @Published public var navigationPath = NavigationPath()

    public func goToFirstView() {
        navigationPath.removeLast(navigationPath.count)
    }
}
