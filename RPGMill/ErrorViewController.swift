//
//  ErrorViewController.swift
//  RPGMill
//
//  Created by William Young on 1/20/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class ErrorViewController: NSViewController {

    @IBOutlet weak var errorLabel: NSTextField!
    
    var error: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let error = error {
            errorLabel.stringValue = error
        }
    }
    
}
