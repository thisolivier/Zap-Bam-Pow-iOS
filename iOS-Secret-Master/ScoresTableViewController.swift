//
//  ScoresTableViewController.swift
//  iOS-Secret-Master
//
//  Created by Olivier Butler on 29/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class ScoresTableViewController: UITableViewController{
    let currentGame = GameResults()
    override func viewDidLoad() {
        super.viewDidLoad()
        print(currentGame)
    }
}
