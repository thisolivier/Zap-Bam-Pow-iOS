//
//  SetupGameViewController.swift
//  iOS-Secret-Master
//
//  Created by Olivier Butler on 27/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class SetupGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var delegate:GameViewController?
    var players:[String]?
    
    @IBOutlet weak var isAdminLabel: UILabel!
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var currentPlayersTableView: UITableView!
    
    override func viewDidLoad() {
        currentPlayersTableView.delegate = self
        currentPlayersTableView.dataSource = self
        if players == nil{
            players = ["Olivier", "Lantz", "Wura"]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (players?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = currentPlayersTableView.dequeueReusableCell(withIdentifier: "playerCell")
        newCell?.textLabel?.text = players?[indexPath.row]
        return newCell!
    }
}
