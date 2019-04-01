//
//  GalleryCollectionViewDelegate.swift
//  Road Capture
//
//  Created by Aaron Sletten on 3/31/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit

extension CustomDataSource2 : UICollectionViewDelegateFlowLayout {
    //Collection view
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //get image capture object
        let object = self.fetchController.fetchedResultController.object(at: indexPath)
        
        selectedImageCaptures[indexPath] = object
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //get image capture object
        let object = self.fetchController.fetchedResultController.object(at: indexPath)
        
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
        
        //save context
        do {
            try context.save()
        }
        catch {
            print("couldnt save after delete")
        }
        
        //empty selectedImageCaptures
        clearSelected()
    }
    
    
    //Layout stuff
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

//class GalleryCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout {
//
//    //Collection view
//    var selectedImageCaptures : Dictionary<IndexPath, ImageCapture> = [:]
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //get image capture object
//        guard let object = self.fetchedResultsController?.object(at: indexPath) as? ImageCapture else {
//            fatalError("Couldn't get managed object")
//        }
//
//        selectedImageCaptures[indexPath] = object
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        //get image capture object
//        guard let object = self.fetchedResultsController?.object(at: indexPath) as? ImageCapture else {
//            fatalError("Couldn't get managed object")
//        }
//
//        selectedImageCaptures.removeValue(forKey: indexPath)
//    }
//
//    func clearSelected(){
//        selectedImageCaptures.removeAll()
//    }
//
//    func deleteSelected(){
//        //get app delegate
//        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
//        //get context
//        let context = appDelegate.persistentContainer.viewContext
//
//        for key in selectedImageCaptures.keys {
//            //get ImageCapture object
//            let imageCapture = selectedImageCaptures[key]!
//
//            //delete images from file system
//            StoreImagesHelper.deleteImage(imageNameWithExtention: "\(imageCapture.id).jpg")
//            StoreImagesHelper.deleteImage(imageNameWithExtention: "\(imageCapture.id)_thumbnail.jpg")
//
//            //delete iamgeCapture from core data
//            context.delete(imageCapture)
//        }
//
//        //empty selectedImageCaptures
//        clearSelected()
//    }
//
//
//    //Layout stuff
//    let itemsPerRow : CGFloat = 3
//    private let sectionInsets = UIEdgeInsets(top: 50.0,left: 20.0,bottom: 50.0,right: 20.0)
//
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
//        let availableWidth = collectionView.superview!.frame.width - paddingSpace
//        let widthPerItem = availableWidth / itemsPerRow
//
//        return CGSize(width: widthPerItem, height: widthPerItem)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInsets
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInsets.left
//    }
//}
