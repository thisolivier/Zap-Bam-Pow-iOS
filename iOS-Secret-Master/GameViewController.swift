//
//  GameViewController.swift
//  iOS-Secret-Master
//
//  Created by Olivier Butler on 27/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

class GameViewController: UIViewController{
    /******************/
    /* Initialisation */
    /******************/
    var myName:String = "NaName"
    @IBOutlet weak var identifyButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSockets()
    }
    
    /******************/
    /* Button Outlets */
    /******************/
    @IBAction func identifyButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toIdentifySegue", sender: myName)
    }
    @IBAction func joinButtonPressed(_ sender: Any) {
        if myName != "NaName" {
            performSegue(withIdentifier: "toGameSetupSegue", sender: "join")
        }
    }
    @IBAction func createButtonPressed(_ sender: Any) {
        if myName != "NaName" {
            performSegue(withIdentifier: "toGameSetupSegue", sender: "create")
        }
    }
    
    
    /**********/
    /* Segues */
    /**********/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toIdentifySegue" {
            let destination = segue.destination as! IdentifyYourselfViewController
            destination.delegate = self
        }
        
        if segue.identifier == "toGameSetupSegue" {
            let destination = segue.destination as! SetupGameViewController
            destination.delegate = self
            if (sender as! String) == "join" {
                getReadyToJoin(destination: destination)
            } else if (sender as! String) == "create" {
                getReadyToJoin(destination: destination)
            }
        }
    }
    
    /***********/
    /* Sockets */
    /***********/
    
    func setupSockets(){
        
    }
    
    func getReadyToJoin(destination: SetupGameViewController){
        
    }
    
    func getReadyToCreate(destination: SetupGameViewController){
        
    }
    
    
    
    /*****************************************/
    /* Functions required by 'identify self' */
    /*****************************************/
    
    func setNewName(_ newName:String){
        if newName != "Enter Name" {
            self.myName = newName
            let alertController = UIAlertController(title: "Name Saved", message: newName, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true){
                print("presented")
            }
        }
    }
    
}
