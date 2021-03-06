//
//  SettingsViewController.swift
//  Road Capture
//
//  Created by Kelvin Boatey on 2/18/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreData
import Reachability

class GalleryViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //navigation bar stuff
    var editButton: UIBarButtonItem!
    var trashButton: UIBarButtonItem!
    var uploadButton: UIBarButtonItem!
    var cancleEditButton : UIBarButtonItem!

    //Collection view stuff
    var datasource : CustomDataSource!
    var test : CustomDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up nav bar buttons
        trashButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(deleteSelectedAction(sender:)))
        editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(editAction(sender:)))
        uploadButton = UIBarButtonItem(title: "Upload", style: UIBarButtonItem.Style.plain, target: self, action: #selector(uploadAction(sender:)))
        cancleEditButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancleEditAction(sender:)))
        navigationBar.topItem?.leftBarButtonItem = editButton
        navigationBar.topItem?.rightBarButtonItem = uploadButton
        
        //set up datasource
        datasource = CustomDataSource(collectionView: collectionView)
        
        //set up collection view
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = false
        collectionView.dataSource = datasource
        collectionView.delegate = datasource
    }
    
    //bar button actions
    @objc func editAction(sender: UIBarButtonItem) {
        print("edit")
        navigationBar.topItem?.leftBarButtonItem = trashButton
        navigationBar.topItem?.rightBarButtonItem = cancleEditButton
        
        collectionView.allowsMultipleSelection = true
    }
    
    @objc func deleteSelectedAction(sender: UIBarButtonItem) {
        print("delete")
        navigationBar.topItem?.leftBarButtonItem = editButton
        navigationBar.topItem?.rightBarButtonItem = uploadButton
        
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = false
        
        //delete action
        datasource.deleteSelected()
    }
    
    @objc func uploadAction(sender: UIBarButtonItem) {
        print("upload button clicked")
        
        //check that network is reachable via WiFi
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
            //upload all
            
            DispatchQueue.global(qos: .background).async {
                self.datasource.uploadAll()
            }
        } else {
            let alert = UIAlertController(title: "Not connected to WiFi", message: "This application requires that you be connected to Wifi to upload.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                switch action.style {
                case .default:
                    print("default")
                case .cancel:
                    print("cancel")
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func cancleEditAction(sender: UIBarButtonItem) {
        print("cancle")
        navigationBar.topItem?.leftBarButtonItem = editButton
        navigationBar.topItem?.rightBarButtonItem = uploadButton
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = false
        
        //clear items from selection in data source
        datasource.clearSelected()
    }
}
