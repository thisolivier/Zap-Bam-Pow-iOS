//
//  GameOverController.swift
//  iOS-Secret-Master
//
//  Created by Wura Alese on 9/28/17.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import Foundation
import UIKit
import SocketIO


class GameOverController: UIViewController{
    let socket = SocketIOClient(socketURL: URL(string: "http://\(GameServer.address):8000")!, config: [.log(false), .forcePolling(true)])
    var gameResultsHolder = GameResults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFrom("http://\(GameServer.address):8000/all")
        socket.connect()
        gameResultsHolder.playersAndHits = makePlayerHolder()
        gameResultsHolder.playersAndLosses = makePlayerHolder()
        print(gameResultsHolder)
    }
    
    func makePlayerHolder() -> [String:[String:Int]]{
        // Need to append player:[victim:0]
        var tempDict:[String:[String:Int]] = [:]
        for player in GamePlayers.players{
            var victimDict:[String:Int] = [:]
            for victim in GamePlayers.players {
                if victim != player {
                    victimDict[victim] = 0
                }
            }
            tempDict[player] = victimDict
        }
        return tempDict
    }
    
    func fetchDataFrom(_ inputURL: String) {
        let url = URL(string: inputURL)
        let session = URLSession.shared
        if let request = url {
            let task = session.dataTask(with: request, completionHandler:  {
                data, response, error in
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    if let jsonResults = jsonResponse as? NSDictionary {
                        self.processResultsFromDict(jsonResults)
                    }
                } catch {
                    print(error)
                }
            })
            task.resume()
        }
    }
    
    func processResultsFromDict(_ originalDictionary:NSDictionary){
        print("Processing results form game")
        let arrayOfPlayers = originalDictionary["data"] as? [NSDictionary]
        
        for player in arrayOfPlayers!{
            print ("-------------------------")
            print ("Working on current player")
            let myName = player["name"] as! String
            let playerHits = gameResultsHolder.playersAndHits
            print (myName)
            let targets = player["targets"] as! NSDictionary
            for victim in targets {
                let yourName = victim.key as! String
                let yourWounds = victim.value as! Int
                print("Individual victim \(yourName) was hit \(yourWounds) times")
            }
        }
    }
    
    
}
