//
//  PlayViewController.swift
//  iOS-Secret-Master
//
//  Created by Betalantz on 9/28/17.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import Vision
import AVFoundation

class PlayViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet weak var sceneView: ARSKView!
    @IBOutlet weak var hitIndicator: UILabel!
    @IBOutlet weak var targetingLabel: UILabel!
    
    
    // Variable for storing the barcode request
    var qRRequest:VNDetectBarcodesRequest?
    // Creates a new timer object
    var qRTimer = Timer()
    // Variable for storing the center of tracked QR codes
    var qRCenter: CGPoint?
    // Variable to report whether tracked QR code is in the target area
    var qRInTarget = false
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = PlayScene(size: sceneView.bounds.size)
        scene.scaleMode = .resizeFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        sceneView.presentScene(scene)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Arena.sks'
        // Review to see is this can be removed
        if let scene = SKScene(fileNamed: "Arena") {
            sceneView.presentScene(scene)
        }
        
        // Setup vision request and start detection loop
        setupVisionRequest()
        scheduledTimerWithTimeInterval()
    }
    
    /************************/
    /* The QR Functionality */
    /************************/
    
    // Setup for a barcode detector object, which will scan for barcodes, and process the results
    func setupVisionRequest(){
        qRRequest = VNDetectBarcodesRequest(completionHandler: {
            (request, error) in
            // Loop through the found results
            for result in request.results! {
                // Cast the result to a barcode-observation
                if let barcode = result as? VNBarcodeObservation {
                    // Get the bounding box for the bar code and find the center
                    var rect = barcode.boundingBox
                    rect = rect.applying(CGAffineTransform(scaleX: 1, y: -1))
                    rect = rect.applying(CGAffineTransform(translationX: 0, y: 1))
                    let center = CGPoint(x: rect.midX, y: rect.midY)
                    self.qRCenter = center
                    print ("Payload: \(barcode.payloadStringValue!) at \(center)")
                    // Checks whether the tracked QR code is lined up in the crosshairs
                }
            }
            self.isTargeted()
        })
    }
    
    // Gets the current image from the ARSKView (Augmented Reality Sprite Kit View) and makes an Image Request Handler using that image.
    // It then calls the handler's perform method, and passes it the request we made earlier.
    @objc func detectQR(){
        self.resetQRData()
        let currentFrame = sceneView.session.currentFrame
        if let currentFrame = currentFrame {
            let cameraCurrent = currentFrame.capturedImage
            let visionImageHandler = VNImageRequestHandler(cvPixelBuffer: cameraCurrent, options: [.properties : ""])
            guard let _ = try? visionImageHandler.perform([qRRequest!]) else {
                return print("Could not perform barcode-request!")
            }
        }
    }
    
    // Starts a timer with a callback of the QR detection function
    func scheduledTimerWithTimeInterval(){
        qRTimer = Timer.scheduledTimer(timeInterval: 0.66, target: self, selector: #selector(self.detectQR), userInfo: nil, repeats: true)
    }
    
    // Resets current data
    func resetQRData(){
        qRCenter = nil
        qRInTarget = false
    }
    
    /********************************/
    /* Targeting    */
    /********************************/
    
    // Defines a square region in center of screen and detects whether QR code is located within it
    func isTargeted() {
        if qRCenter == nil {
            qRInTarget = false
            targetingLabel.isHidden = true
        }
        if let realCenter = qRCenter{
            if realCenter.x > 0.45
                && realCenter.x < 0.55
                && realCenter.y > 0.42
                && realCenter.y < 0.57 {
                targetingLabel.isHidden = false
                qRInTarget = true
                print("Target Lock")
            } else {
                targetingLabel.isHidden = true
                qRInTarget = false
            }
        }
    }
    
    /********************************/
    /* Firing   */
    /********************************/
    
    // Detects screen tap and initiates a fresh QR detection and targetting
    @IBAction func didTapScreen(_ sender: UITapGestureRecognizer) {
        print("Screen tapped")
        self.detectQR()
        if qRInTarget {
            flashHit(alpha: 0.0, start: 0, end: 6)
            print("Hit!")
        }
    }
   
    // Flashes a 'hit' indicator near top of screen when QR code is hit
    func flashHit(alpha: CGFloat, start: Int, end: Int) {
        
        hitIndicator.text = "HIT"
        
        UIView.animate(withDuration: 0.1, animations: {
            self.hitIndicator.alpha = alpha
        }, completion: { success in
            
            if start + 1 <= end {
                self.flashHit(alpha: alpha == 1.0 ? 0.0 : 1.0, start: start + 1, end: end)
            }
        })
    }
    /********************************/
    /* Swipe down to exit   */
    /********************************/
    // define a variable to store initial touch position
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    @IBAction func didSwipeDown(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    
    /********************************/
    /* Fulfilling scene delegate    */
    /********************************/
    /* We don't use any of this yet */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
        targetingLabel.isHidden = true
        hitIndicator.alpha = 0.0
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
