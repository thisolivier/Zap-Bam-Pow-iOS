//
//  ViewController.swift
//  iOS-Secret-Master
//
//  Created by Olivier Butler on 27/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    /*******************************************/
    /* Initialization of variables and outlets */
    /*******************************************/
    let colours = Colours()
    var serverAddress:String?
    @IBOutlet weak var gameButtonOutlet: UIButton!
    @IBOutlet weak var scoreButtonOutlet: UIButton!
    @IBOutlet weak var serverButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameButtonOutlet.backgroundColor = colours.UITeal
        scoreButtonOutlet.backgroundColor = colours.UIYellow
        serverButtonOutlet.backgroundColor = colours.UIOrange
    }
    @IBAction func gameButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toGameSegue", sender: nil)
    }
    @IBAction func scoreButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toScoresSegue", sender: nil)
    }
    @IBAction func serverButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Set a Server Address",
                                      message: "Currently set to \(GameServer.address)",
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default)
        { _ in
            let textField = alert.textFields![0]
            GameServer.address = textField.text!
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    /**********/
    /* Segues */
    /**********/
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        
    }
    


}
