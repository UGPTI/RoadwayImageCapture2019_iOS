//
//  CustomDataSource2.swift
//  Road Capture
//
//  Created by Aaron Sletten on 3/31/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit

class CustomDataSource: NSObject, UICollectionViewDataSource {
    
    //collection view stuff - used in the extention
    var selectedImageCaptures : Dictionary<IndexPath, ImageCapture> = [:]
    //layout stuff
    let itemsPerRow : CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 50.0,left: 20.0,bottom: 50.0,right: 20.0)
    
    
    var fetchController : FetchController!
    
    init(collectionView : UICollectionView) {
        super.init()
        
        fetchController = FetchController(collectionView: collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sections = fetchController._fetchedResultsController!.sections!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchController.fetchedResultController.sections!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        
        // Set up the cell
        let object = self.fetchController.fetchedResultController.object(at: indexPath)
        
        //Populate the cell from the object
        cell.imageView.image = StoreImagesHelper.loadImage(imageNameWithExtention: "\(object.id)_thumbnail.jpg")
        
        return cell
    }
}
