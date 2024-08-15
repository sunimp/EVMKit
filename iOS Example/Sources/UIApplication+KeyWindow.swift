//
//  UIApplication+KeyWindow.swift
//  iOS Example
//
//  Created by Sun on 2024/8/15.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var activeWindow: UIWindow? {
        if #available(iOS 13, *) {
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                if let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                    return window
                }
            }
            return nil
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
