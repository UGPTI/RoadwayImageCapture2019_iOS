//
//  CustomDataSource2.swift
//  Road Capture
//
//  Created by Aaron Sletten on 3/31/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreData

class CustomDataSource: NSObject, UICollectionViewDataSource {
    
    //collection view stuff - used in the extention
    var selectedImageCaptures : [IndexPath:ImageCapture] = [:]
    //layout stuff
    let itemsPerRow : CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    var myCollectionView : UICollectionView!
    
    //Used for updating the collection view automatically
    var fetchController : FetchController!
    
    init(collectionView : UICollectionView) {
        super.init()
        fetchController = FetchController(collectionView: collectionView)
        
        myCollectionView = collectionView
    }
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }

    func uploadAll() {
        //start background task
        registerBackgroundTask()
        
        var appDelegate : AppDelegate!
        DispatchQueue.main.sync {
            //get app delegate
            appDelegate = UIApplication.shared.delegate as? AppDelegate
        }
        //get context
        let context = appDelegate.persistentContainer.viewContext
        //create request to get all image captures
        let fetchRequest = NSFetchRequest<ImageCapture>(entityName: "ImageCapture")
    
        let uploadGroup = DispatchGroup()
        
        do {
            //get all image captures
            let imageCaptures = try context.fetch(fetchRequest)
    
            for imageCapture in imageCaptures {
                //get cell
                var progressBar : UIProgressView?

                uploadGroup.enter()
                DispatchQueue.main.sync {
                    progressBar = (self.myCollectionView.cellForItem(at: IndexPath(item: myCollectionView.numberOfItems(inSection: 0)-1, section: 0)) as? ImageCollectionViewCell)?.progressBar
                    progressBar?.isHidden = false
                    myCollectionView.numberOfItems(inSection: 0)
                }
                NetworkingHelper.uploadImageUseingUpload(imageCapture: imageCapture, deleteAfter: true, progressBar: progressBar, completion: {uploadGroup.leave()})
                uploadGroup.wait()
                
            }
            endBackgroundTask()
        } catch {
            print("Failed to upload image captures")
            endBackgroundTask()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sections = fetchController.localFetchedResultsController!.sections!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchController.fetchedResultController.sections!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionViewCell) ?? ImageCollectionViewCell()
        
        // Set up the cell
        let object = self.fetchController.fetchedResultController.object(at: indexPath)
        
        //Populate the cell from the object
        cell.imageView.image = StoreImagesHelper.loadImage(imageNameWithExtention: "\(object.id)_thumbnail.jpg")
        
        return cell
    }
}
