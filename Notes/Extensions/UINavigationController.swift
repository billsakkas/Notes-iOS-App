//
//  UINavigationController.swift
//  Notes
//
//  Created by Vasilis Sakkas on 22/05/2019.
//  Copyright © 2019 Vasilis Sakkas. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func setShadowColor(_ color: UIColor) {
        navigationBar.barTintColor = color
        navigationBar.shadowImage = color.image
    }
    
    func setNavTheme(shadowColor: UIColor, navItemsTintColor: UIColor, prefersLargeTitles: Bool) {
        setShadowColor(shadowColor)
        navigationBar.setBarStyle(
            BarStyle: UIBarStyle(rawValue: 1),
            isTranslucent: true,
            Tint: navItemsTintColor)
        navigationBar.prefersLargeTitles = prefersLargeTitles
    }
    
}

extension UINavigationBar {
    
    func setBarStyle(BarStyle barStyle: UIBarStyle?, isTranslucent: Bool, Tint tintColor: UIColor) {
        largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: tintColor
        ]
        titleTextAttributes = largeTitleTextAttributes
        self.tintColor = tintColor
    }
    
}
