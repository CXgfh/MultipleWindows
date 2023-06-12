//
//  ViewController.swift
//  MultipleWindows
//
//  Created by V on 02/21/2023.
//  Copyright (c) 2023 V. All rights reserved.
//

import UIKit
import MultipleWindows

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let frame = CGRect(x: 0, y: self.view.height-100, width: self.view.width, height: 100)
        MultipleWindows.shared.addWindow(frame: frame, rootViewController: UIViewController(), adsorption: false, animation: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

