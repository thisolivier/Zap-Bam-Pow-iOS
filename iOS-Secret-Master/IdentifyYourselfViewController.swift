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
        let captureDevice = videoDevices.devices[0]
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
        } catch {
            print("We were unable to make an AVCaptureDevice using the front camera")
            print(error)
        }
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let newName = "Fake Name"
        delegate?.setNewName(newName)
    }
}
