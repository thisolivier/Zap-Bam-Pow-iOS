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
    @IBOutlet weak var gameButtonOutlet: UIButton!
    @IBOutlet weak var scoreButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameButtonOutlet.backgroundColor = colours.UITeal
        scoreButtonOutlet.backgroundColor = colours.UIYellow
    }
    @IBAction func gameButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toGameSegue", sender: nil)
    }
    @IBAction func scoreButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toScoresSegue", sender: nil)
    }
    @IBAction func playButtonPressed(_ sender: UIButton) {
        print ("Attempting to play")
        performSegue(withIdentifier: "toPlaySegue", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
