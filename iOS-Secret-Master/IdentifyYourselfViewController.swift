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

class IdentifyYourselfViewController: UIViewController, ARSCNViewDelegate {
    /******************/
    /* Initialization */
    /******************/
    let configuration = ARWorldTrackingConfiguration()
    var delegate:GameViewController?
    var qRRequest:VNDetectBarcodesRequest?
    var qRTimer = Timer()
    
    @IBOutlet weak var cameraARView: ARSCNView!
    @IBOutlet weak var nameLabelOutput: UILabel!
    @IBOutlet weak var resetButtonOutlet: UIButton!
    @IBOutlet weak var manualResetButtonOutlet: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButtonOutlet.isHidden = true
        cameraARView.delegate = self
        setupVisionRequest()
        //scheduledTimerWithTimeInterval()
        
        // See if we have a name already
        if let delegate = delegate {
            if delegate.myName != "NaName" {
                nameLabelOutput.text = delegate.myName
            } else {
                nameLabelOutput.isHidden = true
            }
        }
    }
    
    /*****************/
    /* Save the name */
    /*****************/
    @IBAction func savePressed(_ sender: Any) {
        if let myName = nameLabelOutput.text{
            print("Saving new name of \(myName)")
            delegate?.myName = myName
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /*************************/
    /* Manual entry fallback */
    /*************************/
    @IBAction func manualEntryPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new player name",
                                      preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default)
        {
            _ in
            let textField = alert.textFields![0]
            self.nameLabelOutput.text = textField.text
            // These functions should be moved to a helper function, since are repeated in QR code detection success
            self.cameraARView.session.pause()
            self.qRTimer.invalidate()
            self.resetButtonOutlet.isHidden = false
            self.nameLabelOutput.isHidden = false
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
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
                    print ("QRCode detected: \(barcode.payloadStringValue!)")
                    self.cameraARView.session.pause()
                    self.qRTimer.invalidate()
                    self.nameLabelOutput.text = barcode.payloadStringValue!
                    self.nameLabelOutput.isHidden = false
                    self.resetButtonOutlet.isHidden = false
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
    
    // Restarts the QR scanner
    @IBAction func rescanPressed(_ sender: UIButton) {
        cameraARView.session.run(configuration)
        scheduledTimerWithTimeInterval()
        resetButtonOutlet.isHidden = true
    }
    
    /********************************/
    /* Fulfilling scene delegate    */
    /********************************/
    /* We don't use any of this yet */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraARView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraARView.session.pause()
        nameLabelOutput.isHidden = true
    }
}


