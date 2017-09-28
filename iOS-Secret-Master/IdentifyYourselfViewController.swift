//
//  IdentifyYourselfViewController.swift
//  iOS-Secret-Master
//
//  Created by Olivier Butler on 27/09/2017.
//  Copyright © 2017 Olivier Butler. All rights reserved.
//

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForVideoCapture()
        if let realDelegate = delegate {
            if realDelegate.myName != "NaName" {
                // nameField.text = realDelegate.myName
            }
        }
    }
    
    func prepareForVideoCapture(){
        let videoDevices = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera, AVCaptureDevice.DeviceType.builtInDualCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.front)
        var captureDevice:AVCaptureDevice?
        for device in videoDevices.devices{
            let device = device as AVCaptureDevice
            if device.position == AVCaptureDevice.Position.front {
                captureDevice = device
                break
            }
        }
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let newName = "Fake Name"
        delegate?.setNewName(newName)
    }
    
    
    

}
