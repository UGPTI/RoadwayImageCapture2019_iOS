//
//  CameraView.swift
//  Road Capture
//
//  Created by Aaron Sletten on 4/24/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import AVFoundation

class CameraView: UIView {
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    
    func interfaceOrientationToVideoOrientation(orientation : UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case UIInterfaceOrientation.portrait:
            return AVCaptureVideoOrientation.portrait
        case UIInterfaceOrientation.portraitUpsideDown:
            return AVCaptureVideoOrientation.portraitUpsideDown
        case UIInterfaceOrientation.landscapeLeft:
            return AVCaptureVideoOrientation.landscapeLeft
        case UIInterfaceOrientation.landscapeRight:
            return AVCaptureVideoOrientation.landscapeRight
        default:
            return AVCaptureVideoOrientation.portraitUpsideDown
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let sublayers = self.layer.sublayers {
            for layer in sublayers {
                layer.frame = self.bounds
            }
        }
        
        self.videoPreviewLayer?.connection?.videoOrientation = interfaceOrientationToVideoOrientation(orientation:  UIApplication.shared.statusBarOrientation)
    }
    
    func addPreviewLayer(previewLayer:AVCaptureVideoPreviewLayer?) {
        previewLayer!.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer!.frame = self.bounds
        self.layer.addSublayer(previewLayer!)
        self.videoPreviewLayer = previewLayer
    }
    
    func removePreviewLayer() {
        self.videoPreviewLayer!.removeFromSuperlayer()
        self.videoPreviewLayer = nil
    }
}
