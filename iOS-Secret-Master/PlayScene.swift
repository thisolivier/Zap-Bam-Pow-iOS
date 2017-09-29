//
//  PlayScene.swift
//  iOS-Secret-Master
//
//  Created by Betalantz on 9/28/17.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import ARKit


class PlayScene: SKScene {
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    var sight: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {                                
        // Places targetting sight.png in center of screen, could be alternated with a second .png in a ternary
        sight = SKSpriteNode(imageNamed: "sight")
        addChild(sight)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // An alternative touch trigger event to use beside the TapGestureRecognizer on the ViewController
    }
    
}
