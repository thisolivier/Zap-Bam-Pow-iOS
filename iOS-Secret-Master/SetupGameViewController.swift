//
//  SetupGameViewController.swift
//  iOS-Secret-Master
//
//  Created by Olivier Butler on 27/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit
import SocketIO

class SetupGameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var delegate:GameViewController?
    var players:[String]?
    let socket = SocketIOClient(socketURL: URL(string: "http://192.168.1.231:8000")!, config: [.log(false), .forcePolling(true)])
    var gameDestination: PlayViewController?
    var endGameDestination: GameOverController?
    var adminName: String?
    var dummyTime = 70000
    
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var currentPlayersTableView: UITableView!
    @IBOutlet weak var startGameButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPlayersTableView.delegate = self
        currentPlayersTableView.dataSource = self
        if players == nil{
            players = ["Please wait for next game"]
        }
        eventHandlers()
        getAdmin("http://192.168.1.231:8000/admin")
        socket.connect()
    }
    
    func getAdmin(_ inputURL: String) {
        let url = URL(string: inputURL)
        let session = URLSession.shared
        if let request = url {
            let task = session.dataTask(with: request, completionHandler:  {
                data, response, error in
                do {
                    if let jsonResults = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print("Setup Controller: Got response from admin query")
                        self.adminName = jsonResults["data"] as? String
                        if self.delegate?.myName == self.adminName {
                            DispatchQueue.main.async {
                                self.setupForAdmin()
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            })
            task.resume()
        }
    }
    
    func setupForAdmin(){
        print("Current user is an admin")
        startGameButtonOutlet.titleLabel?.text = "START GAME"
    }
    
    func eventHandlers() {
        socket.on("beginGame") {result, ack in
            print("Coming from the game creator \(result)")
            self.performSegue(withIdentifier: "startGameSegue", sender: nil)
        }
        socket.on("gameOver") {result, ark in
            print("Coming from the game prepare for curr user: \(result)")
            
            self.gameDestination!.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "toGameOverSegue", sender: result)
            })
        }
    }
    
    
    @IBAction func startGameButtonPressed(_ sender: Any) {
        if delegate?.myName == adminName! {
            socket.emit("startGame", self.dummyTime)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startGameSegue" {
            gameDestination = segue.destination as? PlayViewController
            gameDestination!.allPlayers = players
            gameDestination!.currentPlayerName = delegate?.myName
        }
        if segue.identifier == "toGameOverSegue" {
            endGameDestination = segue.destination as? GameOverController
            endGameDestination?.game = sender!
        }
    }
    func gameData(destination: GameOverController?, game: Any)  {
        destination?.game = game
    }
    
    /********************/
    /* Setting up table */
    /********************/
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (players?.count)!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = currentPlayersTableView.dequeueReusableCell(withIdentifier: "playerCell")
        newCell?.textLabel?.text = players?[indexPath.row]
        return newCell!
    }
}
