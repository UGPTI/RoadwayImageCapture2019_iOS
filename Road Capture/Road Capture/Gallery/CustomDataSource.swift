//
//  CustomDataSource.swift
//  Road Capture
//
//  Created by Aaron Sletten on 3/23/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreData

class CustomDataSource: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate, UICollectionViewDelegateFlowLayout {
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>!
    var collectionView : UICollectionView!
    
    init(collectionView : UICollectionView){
        super.init()
        self.collectionView = collectionView
        initializeFetchedResultsController()
    }

    //Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sections = fetchedResultsController.sections!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell

        // Set up the cell
        guard let object = self.fetchedResultsController?.object(at: indexPath) as? ImageCapture else {
            fatalError("Attempt to configure cell without a managed object")
        }
        //Populate the cell from the object
        cell.imageView.image = StoreImagesHelper.loadImage(imageNameWithExtention: "\(object.id)_thumbnail.jpg")

        return cell
    }

    func initializeFetchedResultsController() {
        let request = NSFetchRequest<ImageCapture>(entityName: "ImageCapture")
        let dateSort = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [dateSort]

        //get app delegate
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //get context
        let context = appDelegate.persistentContainer.viewContext

        fetchedResultsController = (NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
//    //NSFetchedResultsControllerDelegate
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        //collectionView.performBatchUpdates()
//
//    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            collectionView.insertSections(IndexSet(integer: sectionIndex))
        case .delete:
            collectionView.deleteSections(IndexSet(integer: sectionIndex))
        case .move:
            break
        case .update:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
        case .update:
            collectionView.reloadItems(at: [indexPath!])
        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        }
    }
    
    //Collection view
    var selectedImageCaptures : Dictionary<IndexPath, ImageCapture> = [:]
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //get image capture object
        guard let object = self.fetchedResultsController?.object(at: indexPath) as? ImageCapture else {
            fatalError("Couldn't get managed object")
        }
        
        selectedImageCaptures[indexPath] = object
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //get image capture object
        guard let object = self.fetchedResultsController?.object(at: indexPath) as? ImageCapture else {
            fatalError("Couldn't get managed object")
        }
        
        selectedImageCaptures.removeValue(forKey: indexPath)
    }
    
    func clearSelected(){
        selectedImageCaptures.removeAll()
    }
    
    func deleteSelected(){
        //get app delegate
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //get context
        let context = appDelegate.persistentContainer.viewContext
        
        for key in selectedImageCaptures.keys {
            //get ImageCapture object
            let imageCapture = selectedImageCaptures[key]!
            
            //delete images from file system
            StoreImagesHelper.deleteImage(imageNameWithExtention: "\(imageCapture.id).jpg")
            StoreImagesHelper.deleteImage(imageNameWithExtention: "\(imageCapture.id)_thumbnail.jpg")
            
            //delete iamgeCapture from core data
            context.delete(imageCapture)
        }
        
        //empty selectedImageCaptures
        clearSelected()
    }
    
    //Layout Stuff
    let itemsPerRow : CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 50.0,left: 20.0,bottom: 50.0,right: 20.0)
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.superview!.frame.width - paddingSpace
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
