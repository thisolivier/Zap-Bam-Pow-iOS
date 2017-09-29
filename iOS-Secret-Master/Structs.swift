//
//  Structs.swift
//  iOS-Secret-Master
//
//  Created by Olivier Butler on 27/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit

struct Colours {
    var UIRed = UIColor(red:1, green: 0, blue: 0, alpha: 1)
    var UIOrange = UIColor(red: 1, green: 0.333, blue: 0, alpha: 1)
    var UIYellow = UIColor(red: 1, green: 0.898, blue: 0.247, alpha: 1)
    var UITeal = UIColor(red: 0, green: 0.969, blue: 0.792, alpha: 1)
    var UIDarkTeal = UIColor(red:0, green: 0.765, blue: 0.8, alpha: 1)
    var TeamBlue = UIColor(red:0, green: 0.478, blue: 0.8, alpha: 1)
    var TeamOrange = UIColor(red: 1, green: 0.545, blue: 0, alpha: 1)
}

struct GameTarget {
    var coordinate: CGPoint
    var name: String
}
