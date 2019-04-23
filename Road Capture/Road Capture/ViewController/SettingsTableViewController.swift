//
//  SettingsTableViewController.swift
//  Road Capture
//
//  Created by student on 2/18/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var resolutionTextfield: UITextField!
    @IBOutlet weak var distanceTextfield: UITextField!
    @IBOutlet weak var mileBeforeSpaceLabel: UILabel!
    @IBOutlet weak var agencyNameTextfield: UITextField!
    
//    var selectedResolution = ""
//    var selectedDisatannce = ""
////    guard let selectedAgencyName = String(agencyNameTextfield.text!) else {
////
////    }
    
    let resolution = ["High",
                      "Medium",
                      "Low"
                    ]
    let resolutionNumbers = [90, 60, 30]

    let distance = [100,
                    200,
                    300,
                    400,
                    500,
                    600,
                    700,
                    800,
                    900,
                    1000
                    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextFields()
        configureTapGesture()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setMilesLeft()
        
        //get agency
        agencyNameTextfield.text = UserDefaults.standard.string(forKey: "agency") ?? ""
        //get distance
        distanceTextfield.text = "\(UserDefaults.standard.integer(forKey: "distance")) ft"
        //get quality
        var qualityString = "High"
        let quality = UserDefaults.standard.integer(forKey: "quality")
        if  quality >= 90 {
            qualityString = "High"
        } else if quality >= 60 {
            qualityString = "Medium"
        } else {
            qualityString = "Low"
        }
        resolutionTextfield.text = qualityString
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let text = agencyNameTextfield.text {
            UserDefaults.standard.set(text, forKey: "agency")
        } else {
            UserDefaults.standard.set("", forKey: "agency")
        }
    }
    
    func setMilesLeft() {
        let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey])
            if let capacity = values.volumeAvailableCapacityForOpportunisticUsage {
                let compressionQuality = UserDefaults.standard.integer(forKey: "quality")
                var sizeOfPhoto = 1500000.0 //set default to 1.5MB
                
                //set to constants : should probably be changed in the future
                //I took a picuture of colored noise to try to get the largest sized photos and then
                //used the sizes of those images as the sizeOfPhoto constants
                if  compressionQuality >= 90 {
                    sizeOfPhoto = 5000000.0
                } else if compressionQuality >= 60 {
                    sizeOfPhoto = 3500000.0
                } else {
                    sizeOfPhoto = 1500000.0
                }
                
                let numPictures = Double(capacity)/sizeOfPhoto
                //get distance
                let feetBetweenPhotos = Double(UserDefaults.standard.integer(forKey: "distance"))
                let picturesInMile = 5280.0 / feetBetweenPhotos
                let totalMilesLeft = Int(numPictures/picturesInMile)
                mileBeforeSpaceLabel.text = totalMilesLeft.description
            } else {
                mileBeforeSpaceLabel.text = "Capacity is unavailable"
            }
            
            UserDefaults.standard.integer(forKey: "quality")
            
            UserDefaults.standard.integer(forKey: "distance")
            
        } catch {
            mileBeforeSpaceLabel.text = "Error retrieving capacity"
        }
    }
    
    private func configureTextFields() {
        resolutionTextfield.delegate = self
        distanceTextfield.delegate = self
        agencyNameTextfield.delegate = self
        
        let resolutionPickerView = UIPickerView()
        resolutionPickerView.delegate = self
        resolutionPickerView.tag = 1
        //get selected resolution
        let quality = UserDefaults.standard.integer(forKey: "quality")
        if  quality >= 90 {
            resolutionPickerView.selectedRow(inComponent: 0)
        } else if quality >= 60 {
            resolutionPickerView.selectedRow(inComponent: 1)
        } else {
            resolutionPickerView.selectedRow(inComponent: 2)
        }
        resolutionTextfield.inputView = resolutionPickerView
        
        let distancePickerView = UIPickerView()
        distancePickerView.delegate = self
        distancePickerView.tag = 2
        //set selected distance
        let distance = UserDefaults.standard.integer(forKey: "distance")
        let index = self.distance.index(of: distance)
        distancePickerView.selectedRow(inComponent: index ?? 0)
        distanceTextfield.inputView = distancePickerView
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsTableViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
        
    }
    
    //PickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            return resolution.count
        } else if pickerView.tag == 2 {
            return distance.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return resolution[row]
        } else if pickerView.tag == 2 {
            return "\(distance[row]) ft"
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            //Save resolution
            UserDefaults.standard.set(resolutionNumbers[row], forKey: "quality")
            setMilesLeft()
            return resolutionTextfield.text = resolution[row]
        } else if pickerView.tag == 2 {
            UserDefaults.standard.set(distance[row], forKey: "distance")
            setMilesLeft()
            return distanceTextfield.text =  "\(distance[row]) ft"
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SettingsTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
