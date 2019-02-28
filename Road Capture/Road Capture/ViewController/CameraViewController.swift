//
//  SettingsViewController.swift
//  Road Capture
//
//  Created by Kelvin Boatey on 2/18/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class CameraViewController: UIViewController {
    
    //photo capture helper
    var photoCaptureHelper : PhotoCaptureHelper?
    //location tracking helper
    var locationTracker : LocationTracking?
    var isTakingPicutres = false
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var endButton: UIButton!
    
    @IBAction func startButton(_ sender: Any) {
        //check if taking pictures
        if !isTakingPicutres{
            endButton.isHidden = false
            endButton.isEnabled = true
            isTakingPicutres = true
            
            //start tracking location
            locationTracker?.start()
        }
        
        //take photo
        takePhoto()
    }
    
    @IBAction func endButton(_ sender: Any) {
        if isTakingPicutres{
            //disable button
            endButton.isHidden = true
            endButton.isEnabled = false
            isTakingPicutres = false
            
            //stop tracking location
            locationTracker!.stop()
            
            //switch to gallery view
            let galleryViewController = self.tabBarController?.customizableViewControllers?[1] as! GalleryViewController
            //add images to gallery view
            galleryViewController.addImages(images: self.photoCaptureHelper!.imagesArray)
            //reset photo caputure helper
            photoCaptureHelper?.imagesArray = []
            //navigate to gallery view controller
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    @IBOutlet var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable button
        endButton.isHidden = true
        endButton.isEnabled = false
        
        //init helpers
        photoCaptureHelper = PhotoCaptureHelper.init(view: self.view, cameraView: cameraView)
        locationTracker = LocationTracking.init(triggerDistance: 100, triggerFunction: takePhoto)
    }
    
    func takePhoto(){
        endButton.isEnabled = false
        endButton.backgroundColor = UIColor.gray
        self.photoCaptureHelper?.takePhoto(triggerFunction: {
            self.endButton.isEnabled = true
            self.endButton.backgroundColor = UIColor.red
        })
        
        automaticButtonPress(button: startButton)
    }
    
    //button animation
    func automaticButtonPress(button : UIButton){
        UIView.animate(withDuration: 0.15,
                       animations: {button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)},
                       completion: { _ in UIView.animate(withDuration: 0.15) {button.transform = CGAffineTransform.identity}})
    }
}
