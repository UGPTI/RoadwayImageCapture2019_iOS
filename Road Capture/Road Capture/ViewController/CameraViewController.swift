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
import Foundation

class CameraViewController: UIViewController {
    
    //photo capture helper
    var photoCaptureHelper : PhotoCaptureHelper!
    //location tracking helper
    var locationTracker : LocationTracking!
    var isTakingPicutres = false
    
    let startButtonImage = UIImage(named: "startButton")
    let cameraButtonImage = UIImage(named: "cameraButton")
    
    @IBOutlet var startButton: UIButton!
    @IBOutlet var endButton: UIButton!
    
    @IBAction func startButton(_ sender: Any) {
        //check if taking pictures
        if !isTakingPicutres {
            endButton.isHidden = false
            endButton.isEnabled = true
            startButton.setImage(cameraButtonImage, for: .normal)
            
            self.tabBarController?.tabBar.isHidden = true
            
            isTakingPicutres = true
            
            //start tracking location
            locationTracker.start()
        }
        
        //take photo
        takePhoto()
    }
    
    @IBAction func endButton(_ sender: Any) {
        if isTakingPicutres {
            //disable button
            endButton.isHidden = true
            endButton.isEnabled = false
            startButton.setImage(startButtonImage, for: .normal)
            
            self.tabBarController?.tabBar.isHidden = false
            
            isTakingPicutres = false
            
            //stop tracking location
            locationTracker!.stop()
            
            //switch to gallery view
            self.tabBarController?.selectedIndex = 1
        }
    }
    
    @IBOutlet var cameraView: CameraView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.sendSubviewToBack(cameraView)
        
        //Dont let the screen go to sleep
        UIApplication.shared.isIdleTimerDisabled = true
        
        if UserDefaults.standard.string(forKey: "distance") == nil {
            UserDefaults.standard.set(100, forKey: "distance")
        }
        if UserDefaults.standard.string(forKey: "quality") == nil {
            UserDefaults.standard.set(90, forKey: "quality")
        }
        if UserDefaults.standard.string(forKey: "agency") == nil {
            UserDefaults.standard.set("default agency", forKey: "agency")
        }
        
        //make round buttons - prob delete
        startButton.clipsToBounds = true
        endButton.clipsToBounds = true
        
        //disable button
        endButton.isHidden = true
        endButton.isEnabled = false
        
        //init helpers
        photoCaptureHelper = PhotoCaptureHelper.init(cameraView: cameraView)
        locationTracker = LocationTracking.init(triggerFunction: takePhoto)
    }

    override func viewDidAppear(_ animated: Bool) {
        //request camera access
        requestCameraAccess()
        //request location access
        requestLocationAccess()
    }
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied {

            // Create Alert
            let alert = UIAlertController(title: "Location Access", message: "Location access is absolutely necessary to use this app", preferredStyle: .alert)

            // Add "OK" Button to alert, pressing it will bring you to the settings app
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            // Show the alert with animation
            self.present(alert, animated: true)
        }
    }
    
    func requestCameraAccess() {
        //Camera
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                //access granted
            } else {
                // Create Alert
                let alert = UIAlertController(title: "Camera", message: "Camera access is absolutely necessary to use this app", preferredStyle: .alert)
                
                // Add "OK" Button to alert, pressing it will bring you to the settings app
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                // Show the alert with animation
                self.present(alert, animated: true)
            }
        }
    }
    
    func takePhoto() {
        automaticButtonPress(button: startButton)
        startButton.isEnabled = false
        startButton.imageView?.alpha = 0.5
        
        endButton.isEnabled = false
        endButton.imageView?.alpha = 0.5
        
        photoCaptureHelper?.takePhoto(triggerFunction : {
            
            //get image
            guard let image = self.photoCaptureHelper?.currentImage else {
                print("could not get image")
                return
            }
            
            let location = self.locationTracker.lastLocation!
            //get latitude and longitude
            let lat = Float(location.coordinate.latitude)
            let long = Float(location.coordinate.longitude)
            
            //set user defaults
            //            UserDefaults.standard.set("aarons agency", forKey: "agency")
            //            UserDefaults.standard.set(60, forKey: "quality")
            
            //get quality agency
            let agency = UserDefaults.standard.string(forKey: "agency") ?? ""
            var quality = UserDefaults.standard.integer(forKey: "quality")
            if quality == 0 {
                quality = 30 //set to low
            }

            //thumbnail width and hieght
            let height = image.size.height
            let width = image.size.width
            let ratio = width/height
            var thumbnail : UIImage!
            
            if ratio > 1 {
                //landscape
                thumbnail = self.imageWithImage(sourceImage: image, scaledToWidth: 300)
            } else {
                //portrait
                let scaleFactor = 300.0 / height
                let newWidth = Int(width * scaleFactor)
                
                thumbnail = self.imageWithImage(sourceImage: image, scaledToWidth: newWidth )
            }
            
            //Save photo using core data - protect against FAILURES!!!! dont use !
            StoreImagesHelper.storeImageCapture(id: self.getDateInt(), latitude: lat, longitude: long, quality: quality, agency: agency, image: image, thumbnail: thumbnail)
        
            //enable buttons
            self.startButton.isEnabled = true
            self.startButton.imageView?.alpha = 1
            self.endButton.isEnabled = true
            self.endButton.imageView?.alpha = 1
        })
    }
    
    func getDateInt() -> Int {
        let date = Date().timeIntervalSince1970 //This is a Double
        return Int(date*1000)
    }
    
    func imageWithImage (sourceImage : UIImage, scaledToWidth: Int) -> UIImage {
        let oldWidth : CGFloat = sourceImage.size.width
        let scaleFactor : CGFloat = CGFloat(scaledToWidth) / oldWidth
    
        let newHeight : CGFloat = sourceImage.size.height * scaleFactor
        let newWidth : CGFloat = oldWidth * scaleFactor
    
        let size = CGSize(width: newWidth, height: newHeight)
        
        UIGraphicsBeginImageContext(size)
        sourceImage.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    //button animation
    func automaticButtonPress(button : UIButton) {
        UIView.animate(withDuration: 0.15,
                       animations: {button.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)},
                       completion: { _ in UIView.animate(withDuration: 0.15) {button.transform = CGAffineTransform.identity}})
    }
}
