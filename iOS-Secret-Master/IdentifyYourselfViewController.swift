//
//  IdentifyYourselfViewController.swift
//  iOS-Secret-Master
//
//  Created by Olivier Butler on 27/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//
//  This page is largely based on https://www.appcoda.com/barcode-reader-swift/
//  Current error seems to be based on calling the metadata processor, it might be that I have to set this up inside the sub-view and delegate that to the IdentifyYourselfViewController

import UIKit
import Vision
import ARKit

class IdentifyYourselfViewController: UIViewController, ARSKViewDelegate {
    /******************/
    /* Initialization */
    /******************/
    var delegate:GameViewController?
    var qRRequest:VNDetectBarcodesRequest?
    var qRTimer = Timer()
    
    @IBOutlet weak var cameraARView: ARSKView!
    @IBOutlet weak var nameLabelOutput: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraARView.delegate = self
        if let realDelegate = delegate {
            if realDelegate.myName != "NaName" {
                nameLabelOutput.text = realDelegate.myName
            }
        }
    }
    
    /*****************/
    /* Save the name */
    /*****************/
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        print("Save button pressed")
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
                    print ("Payload: \(barcode.payloadStringValue!) at \(center)")
                }
            }
        })
    }
    
    // Gets the current image from the ARSCNView (Augmented Reality Scene View) and makes an Image Request Handler using that image.
    // It then calls the handler's perform method, and passes it the request we made earlier.
    @objc func detectQR(){
        let cameraCurrent = cameraARView.session.currentFrame?.capturedImage
        let visionImageHandler = VNImageRequestHandler(cvPixelBuffer: cameraCurrent!, options: [.properties : ""])
        guard let _ = try? visionImageHandler.perform([qRRequest!]) else {
            return print("Could not perform barcode-request!")
        }
    }
    
    // Starts a timer with a callback of the QR detection function. Repeats every 1 seconds.
    func scheduledTimerWithTimeInterval(){
        qRTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.detectQR), userInfo: nil, repeats: true)
    }
}


