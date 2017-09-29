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
    let socket = SocketIOClient(socketURL: URL(string: "http://192.168.1.86:8000")!, config: [.log(false), .forcePolling(true)])
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
        getAdmin("http://192.168.1.86:8000/admin")
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
                        print(jsonResults)
                    }
                } catch {
                    print(error)
                }
            })
            task.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (players?.count)!
    }
    
    func eventHandlers() {
        socket.on("beginGame") {result, ack in
            print("Coming from the game creator")
            self.performSegue(withIdentifier: "toFakeGameSegue", sender: nil)
        }
        socket.on("gameOver") {result, ark in
            print("Coming from the fake game prepare for curr user")
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
