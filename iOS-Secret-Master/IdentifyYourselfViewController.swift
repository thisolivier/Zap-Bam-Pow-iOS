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

class IdentifyYourselfViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    /******************/
    /* Initialization */
    /******************/
    var delegate:GameViewController?
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var myselfReal:AVCaptureMetadataOutputObjectsDelegate?
    
    @IBOutlet weak var cameraDisplayView: UIView!
    @IBOutlet weak var nameLabelOutput: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDisplayView.layer.masksToBounds = true
        myselfReal = self
        if prepareForVideoCapture() {
            setupQRCodeDetectionBox()
        } else {
            print("We were unable to start the capture session")
        }
        
        if let realDelegate = delegate {
            if realDelegate.myName != "NaName" {
                // nameField.text = realDelegate.myName
            }
        }
    }
    
    /*********************/
    /* Setting up Camera */
    /*********************/
    
    func prepareForVideoCapture() -> Bool{
        print(" ")
        print("Starting Camera Setup")
        let videoDevices = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera, AVCaptureDevice.DeviceType.builtInDualCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.back)
        let captureDevice = videoDevices.devices[0]
        
        do {
            // We start a capture session
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            
            // We setup storage for session output
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(myselfReal!, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            
            // Now we attach the video being captured to a view
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = cameraDisplayView.layer.bounds
            cameraDisplayView.layer.addSublayer(videoPreviewLayer!)
            captureSession?.commitConfiguration()
            captureSession?.startRunning()
            
            return true
        } catch {
            print("We were unable to make an AVCaptureDevice using the front camera")
            print(error)
        }
        return false
    }
    
    func setupQRCodeDetectionBox(){
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            // Note that this view will not be visible until we detect a code
            print("Adding qr box template")
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            cameraDisplayView.addSubview(qrCodeFrameView)
            cameraDisplayView.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    /*********************/
    /* Capturing QR Code */
    /*********************/
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        print("We haz output")
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            nameLabelOutput.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            print(metadataObj)
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                nameLabelOutput.text = metadataObj.stringValue
            }
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let newName = "Fake Name"
        delegate?.setNewName(newName)
    }
}
