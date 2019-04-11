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
    var selectedImageCaptures : Dictionary<IndexPath, ImageCapture> = [:]
    //layout stuff
    let itemsPerRow : CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 50.0,left: 20.0,bottom: 50.0,right: 20.0)
    
    var myCollectionView : UICollectionView!
    
    //Used for updating the collection view automatically
    var fetchController : FetchController!
    
    init(collectionView : UICollectionView) {
        super.init()
        fetchController = FetchController(collectionView: collectionView)
        
        myCollectionView = collectionView
    }
    
    //upload all images in gallery
    func uploadAll(){
        //get app delegate
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //get context
        let context = appDelegate.persistentContainer.viewContext
        //create request to get all image captures
        let fetchRequest = NSFetchRequest<ImageCapture>(entityName: "ImageCapture")
        
        DispatchQueue.global().async {
            do {
                //get all image captures
                let imageCaptures = try context.fetch(fetchRequest)

                self.uploadAllRecursive(imageCaptures: imageCaptures, deleteAfter: true, index: 0, completion: {})
                
//                self.uploadAllRecursive(imageCapture: imageCaptures[index], deleteAfter: true, index: index, completion: {})
//                var index = 0
//                var complete = false
//                repeat {
//                    //get cell
//                    var progressBar : UIProgressView!
//                    DispatchQueue.main.sync {
//                        progressBar = (self.myCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ImageCollectionViewCell).progressBar
//                    }
//
//                    complete = false
//                    NetworkingHelper.uploadImageUseingUpload(imageCapture: imageCaptures[index], deleteAfter: true, progressBar: progressBar, completion: {
//                        complete = true
//                        index += 1
//                    })
//                } while index < imageCaptures.count && complete
                
                
                
                
//                //upload each image captures
//                for (index, imageCapture) in imageCaptures.enumerated() {
//                    //get cell
//                    var progressBar : UIProgressView!
//                    DispatchQueue.main.sync {
//                        progressBar = (self.myCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ImageCollectionViewCell).progressBar
//                    }
//
//                    var complete = false
//
//                    repeat {
//                        complete = false
//                        NetworkingHelper.uploadImageUseingUpload(imageCapture: imageCapture, deleteAfter: true, progressBar: progressBar, completion: {complete = true})
//                    } while complete
//                }
            } catch {
                print("Failed to upload image captures")
            }
        }
    }
    
    private func uploadAllRecursive(imageCaptures: [ImageCapture], deleteAfter: Bool, index : Int, completion: @escaping () -> ()){
    
        //get cell
        var progressBar : UIProgressView!
        DispatchQueue.main.sync {
            progressBar = (self.myCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! ImageCollectionViewCell).progressBar
        }

        NetworkingHelper.uploadImageUseingUpload(imageCapture: imageCaptures[index], deleteAfter: true, progressBar: progressBar, completion: {
            if index+1 < imageCaptures.count {
                self.uploadAllRecursive(imageCaptures: imageCaptures, deleteAfter: deleteAfter, index: index+1, completion: {completion()})
            }
        })
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
