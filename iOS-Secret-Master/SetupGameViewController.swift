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
    var endGameDestination: GameOverController?
    var players:[String]?
    let socket = SocketIOClient(socketURL: URL(string: "http://localhost:8000")!, config: [.log(false), .forcePolling(true)])
    var gameDestination:FakeGameViewController?
    
    @IBOutlet weak var isAdminLabel: UILabel!
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var currentPlayersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPlayersTableView.delegate = self
        currentPlayersTableView.dataSource = self
        if players == nil{
            players = ["Olivier", "Lantz", "Wura"]
        }
        eventHandlers()
        socket.connect()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (players?.count)!
    }
    
    func eventHandlers() {
        socket.on("beginGame") {result, ack in
            print("Coming from the game creator \(result)")
            self.performSegue(withIdentifier: "toFakeGameSegue", sender: nil)
        }
        socket.on("playGame") {result, ack in
            print("Coming from the others \(result)")
            self.performSegue(withIdentifier: "toFakeGameSegue", sender: nil)
        }
        socket.on("gameOver") {result, ark in
            print("Coming from the fake game prepare for curr user: \(result)")
            
            self.gameDestination!.dismiss(animated: true, completion: {
                self.performSegue(withIdentifier: "toGameOverSegue", sender: result)
            })
        }

    }
    
    
    @IBAction func startGameButtonPressed(_ sender: Any) {
        socket.emit("startGame")
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFakeGameSegue" {
            gameDestination = segue.destination as? FakeGameViewController
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let newCell = currentPlayersTableView.dequeueReusableCell(withIdentifier: "playerCell")
        newCell?.textLabel?.text = players?[indexPath.row]
        return newCell!
    }
}
