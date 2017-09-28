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
    let socket = SocketIOClient(socketURL: URL(string: "http://localhost:8000")!, config: [.log(false), .forcePolling(true)])
    var game:Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In game over controller: \(game)")
        fetchDataFrom("http://localhost:8000/all")
        socket.connect()
    }
    
    func fetchDataFrom(_ inputURL: String) {
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
    
    
    
    
}
