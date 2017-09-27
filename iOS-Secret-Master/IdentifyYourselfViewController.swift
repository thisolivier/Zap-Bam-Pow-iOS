//
//  IdentifyYourselfViewController.swift
//  iOS-Secret-Master
//
//  Created by Olivier Butler on 27/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class IdentifyYourselfViewController: UIViewController{
    @IBOutlet weak var nameField: UITextField!
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let newName = nameField.text
        delegate?.setNewName(newName!)
    }
    
    var delegate:GameViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let realDelegate = delegate {
            if realDelegate.myName != "NaName" {
                nameField.text = realDelegate.myName
            }
        }
    }
}
