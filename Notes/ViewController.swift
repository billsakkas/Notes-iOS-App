//
//  ViewController.swift
//  Notes
//
//  Created by Vasilis Sakkas on 23/05/2019.
//  Copyright © 2019 Vasilis Sakkas. All rights reserved.
//

import UIKit

class ViewController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setupNavUI()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavUI() {
        setNavTheme(
            shadowColor: UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1),
            navItemsTintColor: .white,
            prefersLargeTitles: true
        )
    }
    
}
