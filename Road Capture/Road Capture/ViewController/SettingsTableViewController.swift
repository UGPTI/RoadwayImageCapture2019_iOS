//
//  SettingsTableViewController.swift
//  Road Capture
//
//  Created by student on 2/18/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var resolutionTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    
    let resolution = ["High",
                      "Medium",
                      "Low"
    ]
    var selectedResolution: String?
    var selectedDistance: Int?
    
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
    
    func createResolutionPicker() {
        let resolutionPicker = UIPickerView()
        resolutionPicker.delegate = self
        
        resolutionTextField.inputView = resolutionPicker
    }
    
    func createDistancePicker() {
        let distancePicker = UIPickerView()
        distancePicker.delegate = self
        
        distanceTextField.inputView = distancePicker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createResolutionPicker()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }


}
extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return resolution.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return resolution[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedResolution = resolution[row]
        resolutionTextField.text = selectedResolution
    }
}
