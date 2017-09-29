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
    var gameData:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFrom("http://\(GameServer.address):8000/all")
        socket.connect()
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
        print(originalDictionary)
        for item in originalDictionary{
            if let item = item.value as? NSDictionary {
                print ("Printing items")
                print (item)
            }
        }
    }
    
    
}
