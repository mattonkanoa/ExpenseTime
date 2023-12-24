//
//  CustomNavigationController.swift
//  Budget Time
//
//  Created by Kanoa Matton on 7/3/20.
//  Copyright © 2020 Kanoa Matton. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
        // Do any additional setup after loading the view.
    }
    

}
