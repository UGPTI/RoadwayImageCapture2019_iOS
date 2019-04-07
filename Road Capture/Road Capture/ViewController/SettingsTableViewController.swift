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
    
    let resolution = ["High",
                      "Medium",
                      "Low"
                    ]

    
    let distance = ["100ft",
                    "200ft",
                    "300ft",
                    "400ft",
                    "500ft",
                    "600ft",
                    "700ft",
                    "800ft",
                    "900ft",
                    "1000ft"
                    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let resolutionPickerView = UIPickerView()
        resolutionPickerView.delegate = self
        resolutionPickerView.tag = 1
        resolutionTextfield.inputView = resolutionPickerView
        
        
        let distancePickerView = UIPickerView()
        distancePickerView.delegate = self
        distancePickerView.tag = 2
        distanceTextfield.inputView = distancePickerView
        


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            return distance[row]
        }
        
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            return resolutionTextfield.text = resolution[row]
        }
        else if pickerView.tag == 2 {
            return distanceTextfield.text =  distance[row]
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
