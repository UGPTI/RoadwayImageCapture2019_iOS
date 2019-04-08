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
        if  quality >= 90{
            qualityString = "High"
        } else if quality >= 60 {
            qualityString = "Medium"
        } else {
            qualityString = "Low"
        }
        resolutionTextfield.text = qualityString;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let text = agencyNameTextfield.text {
            UserDefaults.standard.set(text, forKey: "agency")
        }else{
            UserDefaults.standard.set("", forKey: "agency")
        }
    }
    
    func setMilesLeft(){
        let fileURL = URL(fileURLWithPath: NSHomeDirectory() as String)
        do {
            let values = try fileURL.resourceValues(forKeys: [.volumeAvailableCapacityForOpportunisticUsageKey])
            if let capacity = values.volumeAvailableCapacityForOpportunisticUsage {
                let numPictures = Double(capacity)/1000000.0
                let feetBetweenPhotos = 100.0
                let picturesInMile = 5280 / feetBetweenPhotos
                let totalMilesLeft = Int(numPictures/picturesInMile)
                mileBeforeSpaceLabel.text = totalMilesLeft.description
            } else {
                mileBeforeSpaceLabel.text = "Capacity is unavailable"
            }
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
        resolutionTextfield.inputView = resolutionPickerView
        
        
        let distancePickerView = UIPickerView()
        distancePickerView.delegate = self
        distancePickerView.tag = 2
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
        }
        else if pickerView.tag == 2 {
            return distance.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return resolution[row]
        }
        else if pickerView.tag == 2 {
            return "\(distance[row]) ft"
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
//            selectedResolution = resolution[row]
            //Save resolution
            UserDefaults.standard.set(resolution[row], forKey: "quality")
            
            return resolutionTextfield.text = resolution[row]
        }
        else if pickerView.tag == 2 {
//            selectedDisatannce = distance[row]
//            UserDefaults.standard.set("aarons agency", forKey: "agency")
            UserDefaults.standard.set(distance[row], forKey: "distance")
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
