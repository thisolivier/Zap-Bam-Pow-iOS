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
import AVFoundation
import Vision

class IdentifyYourselfViewController: UIViewController{
    /******************/
    /* Initialization */
    /******************/
    var delegate:GameViewController?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var captureSession:AVCaptureSession?
    var videoOutput: AVCaptureVideoDataOutput?
    var qRRequest:VNDetectBarcodesRequest?
    
    @IBOutlet weak var cameraDisplayView: UIView!
    @IBOutlet weak var nameLabelOutput: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDisplayView.layer.masksToBounds = true
        (cameraDisplayView as! CameraFrameView).delegate = self
        //setupVisionRequest()
        prepareForVideoCapture()
        
        if let realDelegate = delegate {
            if realDelegate.myName != "NaName" {
                // nameField.text = realDelegate.myName
            }
        }
    }
    
    /*********************/
    /* Setting up Camera */
    /*********************/
    
    func prepareForVideoCapture(){
        print(" ")
        print("Starting Camera Setup")
        let videoDevices = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera, AVCaptureDevice.DeviceType.builtInDualCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
        let captureDevice = videoDevices.devices[0]
        let captureMetadataOutput = AVCaptureMetadataOutput()
        
        do {
            // We start a capture session
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            // Setup the output
            captureSession?.addOutput(captureMetadataOutput)
            let newQueue = DispatchQueue(label: "MyQueue")
            captureMetadataOutput.setMetadataObjectsDelegate(cameraDisplayView as? AVCaptureMetadataOutputObjectsDelegate, queue: newQueue)
            
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Now we attach the video being captured to a view
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = cameraDisplayView.layer.bounds
            cameraDisplayView.layer.addSublayer(videoPreviewLayer!)
            captureSession?.commitConfiguration()
            captureSession?.startRunning()
            print("Camera is running")
        } catch {
            print("We were unable to make an AVCaptureDevice using the front camera")
            print(error)
        }
    }
    
    /************************/
    /* The QR Functionality */
    /************************/
    
//    // Setup for a barcode detector object, which will scan for barcodes, and process the results
//    func setupVisionRequest(){
//        qRRequest = VNDetectBarcodesRequest(completionHandler: {
//            (request, error) in
//            // Loop through the found results
//            for result in request.results! {
//                // Cast the result to a barcode-observation
//                if let barcode = result as? VNBarcodeObservation {
//                    // Get the bounding box for the bar code and find the center
//                    var rect = barcode.boundingBox
//                    rect = rect.applying(CGAffineTransform(scaleX: 1, y: -1))
//                    rect = rect.applying(CGAffineTransform(translationX: 0, y: 1))
//                    let center = CGPoint(x: rect.midX, y: rect.midY)
//                    print ("Payload: \(barcode.payloadStringValue!) at \(center)")
//                }
//            }
//        })
//    }
//
//    // Gets the current image from the ARSCNView (Augmented Reality Scene View) and makes an Image Request Handler using that image.
//    // It then calls the handler's perform method, and passes it the request we made earlier.
//    @objc func detectQR(){
//        let cameraCurrent = videoPreviewLayer!
//        let visionImageHandler = VNImageRequestHandler(cvPixelBuffer: cameraCurrent!, options: [.properties : ""])
//        guard let _ = try? visionImageHandler.perform([qRRequest!]) else {
//            return print("Could not perform barcode-request!")
//        }
//    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let newName = "Fake Name"
        delegate?.setNewName(newName)
    }
}

class CameraFrameView:UIView, AVCaptureMetadataOutputObjectsDelegate {
    var delegate: IdentifyYourselfViewController?
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            DispatchQueue.main.async {
                self.frame = CGRect.zero
                self.delegate!.nameLabelOutput.text = "No QR code is detected"
            }
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            DispatchQueue.main.async {
                print("I see you...")
                if metadataObj.stringValue != nil {
                    self.delegate!.nameLabelOutput.text = metadataObj.stringValue
                }
            }
        }
    }
   
}

