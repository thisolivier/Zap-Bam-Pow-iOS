//
//  FakeGameViewController.swift
//  iOS-Secret-Master
//
//  Created by Wura Alese on 9/27/17.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit
import SocketIO

class FakeGameViewController: UIViewController{
    let socket = SocketIOClient(socketURL: URL(string: "http://192.168.1.231:8000")!, config: [.log(false), .forcePolling(true)])
    
    @IBOutlet weak var target: UILabel!
    var currentPlayerName:String?
    var allPlayers:[String]?
    var count:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventHandlers()
        socket.connect()
    }
    
    // Setting up event listeners
    func eventHandlers() {
        socket.on("target") {result, ack in
            print("this person was shot: \(result)")
            self.someoneGotShotHandler(result: result[0])
        }
    }
    
    // When we trigger a shot on our device
    @IBAction func shootPressed(_ sender: UIButton) {
        var data = [String:String]()
        data["shooter"] = currentPlayerName
        data["target"] = allPlayers?[count]
        count += 1
        socket.emit("shotsFired", data)
    }
    
    // Handler for when someone gets shot
    func someoneGotShotHandler(result:Any){
        target.text = "\(result) was just shot, ouch!!"
    }
    
}
