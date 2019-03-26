//
//  SettingsViewController.swift
//  Road Capture
//
//  Created by Kelvin Boatey on 2/18/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreData

class GalleryViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    //Layout Stuff
    let itemsPerRow : CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0,left: 20.0,bottom: 50.0,right: 20.0)
    let reuseIdentifier = "imageCell"
    
    //Image view stuff
    var imageCaptures : [Data] = []
    var dataSource : CustomDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = CustomDataSource(collectionView: collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }
    
    //Layout
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
    

