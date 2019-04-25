//
//  PhotoCaptureHelper.swift
//  Road Capture
//
//  Created by Aaron Sletten on 2/27/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import AVFoundation
import Accelerate

class PhotoCaptureHelper: NSObject, AVCapturePhotoCaptureDelegate {

    //Set Up Camera Session
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraView: CameraView?
    var currentImage : UIImage?
    var currentDevice: UIDevice!

    var triggerFunction : () -> Void = {}
    
    //init
    init(cameraView: CameraView) {
        super.init()
        
        //set properties
        self.cameraView = cameraView
        
        //setup capture session
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer(view: cameraView)
        startRunningCaptureSession()
    }
    
    //fuctions
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        
        currentDevice = .current
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera =  device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        currentCamera = backCamera
    }
    
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer(view: UIView) {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.frame = cameraView?.bounds ?? view.frame
        photoOutput?.connection(with: .video)?.videoOrientation = managePhotoOrientation()
        
        cameraView?.layer.addSublayer(cameraPreviewLayer!)
        cameraView?.addPreviewLayer(previewLayer: cameraPreviewLayer)
        
//        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
//
//        cameraPreviewLayer?.frame = view.frame
//        view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let imageData = photo.fileDataRepresentation() {
            //create image
            currentImage = UIImage(data: imageData)
            
            //Trigger function
            triggerFunction()
        }
    }
    
    //take photo
    func takePhoto(triggerFunction : @escaping () -> Void ) {
        self.triggerFunction = triggerFunction
        //Embed thumnail image
        let settings = AVCapturePhotoSettings()
        
        //set orientation
        photoOutput?.connection(with: .video)?.videoOrientation = managePhotoOrientation()
        
        photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    func managePhotoOrientation() -> AVCaptureVideoOrientation {
        var deviceOrientation: UIDeviceOrientation
        var imageOrientation: AVCaptureVideoOrientation
        
        deviceOrientation = currentDevice.orientation
        
        if deviceOrientation == .portrait {
            imageOrientation = .portrait
            print("portrait")
        } else if deviceOrientation == .landscapeLeft {
            imageOrientation = .landscapeLeft
            print("landscape left")
        } else if deviceOrientation == .landscapeRight {
            imageOrientation = .landscapeRight
            print("landscape right")
        } else if deviceOrientation == .portraitUpsideDown {
            imageOrientation = .portraitUpsideDown
            print("upside down")
        } else {
            imageOrientation = .portrait
        }
        return imageOrientation
    }
}

extension UIImage {
    func resizeImageUsingVImage(size:CGSize) -> UIImage? {
        let cgImage = self.cgImage!
        var format = vImage_CGImageFormat(bitsPerComponent: 8, bitsPerPixel: 32, colorSpace: nil, bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue), version: 0, decode: nil, renderingIntent: CGColorRenderingIntent.defaultIntent)
        var sourceBuffer = vImage_Buffer()
        defer {
            free(sourceBuffer.data)
        }
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        // create a destination buffer
        let scale = self.scale
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = self.cgImage!.bitsPerPixel/8
        let destBytesPerRow = destWidth * bytesPerPixel
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
//            destData.deallocate(capacity: destHeight * destBytesPerRow)
            destData.deallocate()
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        // create a CGImage from vImage_Buffer
        var destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue()
        guard error == kvImageNoError else { return nil }
        // create a UIImage
        let resizedImage = destCGImage.flatMap { UIImage(cgImage: $0, scale: 0.0, orientation: self.imageOrientation) }
        destCGImage = nil
        return resizedImage
    }
}
