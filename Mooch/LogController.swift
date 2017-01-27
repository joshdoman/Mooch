//
//  ViewController.swift
//  Camera
//
//  Created by Josh Doman on 1/6/17.
//  Copyright © 2017 Josh Doman. All rights reserved.
//

import UIKit
import AVFoundation

protocol DescriptionViewDelegate: class {
    func handleKeyboardShow(notification: NSNotification)
    func handleKeyboardHide()
    func expandDescriptionView(height: CGFloat)
    func handleDone()
}

protocol PhotoControllerDelegate: class {
    func hidePhotoController()
    func addObjectToBag(object: Object)
}

class LogController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    let previewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(pinchGestureRecognizer)
        return view
    }()
    
    lazy var takePhoto: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    func createBagButton() -> UIButton {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Bag")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 5
        button.layer.shouldRasterize = true
        button.addTarget(self, action: #selector(handleOpenBag), for: .touchUpInside)
        button.tintColor = .white
        return button
    }
    
    var bagButton: UIButton?
    
    let editPhotoController: EditPhotoController = EditPhotoController()
    
    var captureSession = AVCaptureSession();
    var sessionOutput = AVCapturePhotoOutput();
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG]);
    var previewLayer = AVCaptureVideoPreviewLayer();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    var objects: [Object] = [Object]()
    
    override func viewWillAppear(_ animated: Bool) {
        captureSession.startRunning()
        
        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInDualCamera, AVCaptureDeviceType.builtInTelephotoCamera,AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified)
        
        for device in (deviceDiscoverySession?.devices)! {
            if(device.position == AVCaptureDevicePosition.back){
                do{
                    let input = try AVCaptureDeviceInput(device: device)
                    if(captureSession.canAddInput(input)){
                        captureSession.addInput(input);
                        
                        if(captureSession.canAddOutput(sessionOutput)){
                            captureSession.addOutput(sessionOutput);
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
                            previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.portrait;
                            previewView.layer.addSublayer(previewLayer);
                        }
                    }
                }
                catch{
                    print("exception!");
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = previewView.bounds
    }
    
    func handleTakePhoto() {
        let settingsForMonitoring = AVCapturePhotoSettings()
        settingsForMonitoring.flashMode = .off
        settingsForMonitoring.isAutoStillImageStabilizationEnabled = true
        settingsForMonitoring.isHighResolutionPhotoEnabled = false
        
        sessionOutput.capturePhoto(with: settingsForMonitoring, delegate: self)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer:
        CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        if let photoSampleBuffer = photoSampleBuffer {
            let photoData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            let image = UIImage(data: photoData!)
            if let image = image {
                showPhotoControllerForImage(image: image)
            }
        }
    }
    
    private func showPhotoControllerForImage(image: UIImage) {
        editPhotoController.currentImage = image
        editPhotoController.view.isHidden = false
        editPhotoController.isSetup = false
        editPhotoController.didMove(toParentViewController: self)
    }
    
    func pinch(pinch: UIPinchGestureRecognizer) {
        print(pinch.scale)
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    func handleOpenBag() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal //makes cells swipe horizontally
        layout.minimumLineSpacing = 0 //decreases gap between cells
        let oc = PresentObjectsController(collectionViewLayout: layout)
        oc.objects = objects
        present(oc, animated: false, completion: nil)
    }
    
}

extension LogController: PhotoControllerDelegate {
    internal func addObjectToBag(object: Object) {
        objects.append(object)
    }

    internal func hidePhotoController() {
        editPhotoController.view.isHidden = true
    }
}

