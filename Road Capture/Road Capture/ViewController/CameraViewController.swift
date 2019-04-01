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
    var photoCaptureHelper : PhotoCaptureHelper!
    //location tracking helper
    var locationTracker : LocationTracking!
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
            locationTracker.start()
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
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    @IBOutlet var cameraView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make round buttons
        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
        startButton.clipsToBounds = true
        endButton.layer.cornerRadius = 0.5 * endButton.bounds.size.width
        endButton.clipsToBounds = true
        
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
        
        self.photoCaptureHelper?.takePhoto(triggerFunction : {
            
            //get image
            guard let image = self.photoCaptureHelper?.currentImage else {
                print("could not get image")
                return
            }
            
            //get latitude and longitude
            let lat = Float(exactly: (self.locationTracker?.lastLocation?.coordinate.latitude) ?? 0.0) ?? 0.0
            let long = Float(exactly: (self.locationTracker?.lastLocation?.coordinate.longitude) ?? 0.0) ?? 0.0
            
            //Save photo using core data - protect against FAILURES!!!! dont use !
            StoreImagesHelper.storeImageCapture(id: self.getDateInt(), latitude: lat, longitude: long, quality: 1, agency: "test agency", image: image, thumbnail: image.resizeImageUsingVImage(size: CGSize(width: 300, height: 300))!)
        
            //enable button
            self.endButton.isEnabled = true
            self.endButton.backgroundColor = UIColor.red
        })
        
        automaticButtonPress(button: startButton)
    }
    
    //MOVE LATER!!!!!!
    func getDateInt() -> Int {
        let date = Date().timeIntervalSince1970 //This is a Double
        return Int(date*1000)
    }
    
    //button animation
    func automaticButtonPress(button : UIButton){
        UIView.animate(withDuration: 0.15,
                       animations: {button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)},
                       completion: { _ in UIView.animate(withDuration: 0.15) {button.transform = CGAffineTransform.identity}})
    }
}
