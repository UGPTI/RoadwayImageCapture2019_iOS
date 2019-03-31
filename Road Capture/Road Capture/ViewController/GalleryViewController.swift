//
//  SettingsViewController.swift
//  Road Capture
//
//  Created by Kelvin Boatey on 2/18/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreData

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set up nav bar buttons
        trashButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.trash, target: self, action: #selector(deleteSelectedAction(sender:)))
        editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(editAction(sender:)))
        uploadButton = UIBarButtonItem(title: "Upload", style: UIBarButtonItem.Style.plain, target: self, action: #selector(uploadAction(sender:)))
        cancleEditButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancleEditAction(sender:)))
        navigationBar.topItem?.leftBarButtonItem = editButton
        navigationBar.topItem?.rightBarButtonItem = uploadButton
        
        //set up collection view
        datasource = CustomDataSource(collectionView: collectionView)
        collectionView.delegate = datasource
        collectionView.dataSource = datasource
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = false
    }
    
    
    //bar button actions
    @objc func editAction(sender: UIBarButtonItem){
        print("edit")
        navigationBar.topItem?.leftBarButtonItem = trashButton
        navigationBar.topItem?.rightBarButtonItem = cancleEditButton
        
        collectionView.allowsMultipleSelection = true
    }
    
    @objc func deleteSelectedAction(sender: UIBarButtonItem){
        print("delete")
        navigationBar.topItem?.leftBarButtonItem = editButton
        navigationBar.topItem?.rightBarButtonItem = uploadButton
        
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = false
        
        //delete action
        datasource.deleteSelected()
    }
    
    @objc func uploadAction(sender: UIBarButtonItem){
        print("upload")
    }
    
    @objc func cancleEditAction(sender: UIBarButtonItem){
        print("cancle")
        navigationBar.topItem?.leftBarButtonItem = editButton
        navigationBar.topItem?.rightBarButtonItem = uploadButton
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = false
        
        //clear items from selection in data source
        datasource.clearSelected()
    }
}
