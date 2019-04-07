//
//  StoreImagesHelper.swift
//  Road Capture
//
//  Created by Aaron Sletten on 3/21/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreData

class StoreImagesHelper: NSObject {
    
    //get app delegate
    static var appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    //get context
    static var context = appDelegate.persistentContainer.viewContext

    //Stores an Image Capture entity with Core Data : saves a thumbnail and fulls size image to app documents
    static func storeImageCapture(id : Int, latitude : Float, longitude : Float, quality : Int, agency : String, image : UIImage, thumbnail : UIImage){
        //create entity
        let entity = NSEntityDescription.entity(forEntityName: "ImageCapture", in: context)
        let newImageCapture = NSManagedObject(entity: entity!, insertInto: context)
        
        //populate entity
        newImageCapture.setValue(id, forKey: "id")
        newImageCapture.setValue(latitude, forKey: "latitude")
        newImageCapture.setValue(longitude, forKey: "longitude")
        newImageCapture.setValue(quality, forKey: "quality")
        newImageCapture.setValue(agency, forKey: "agency")
        
        //save entity
        do {
            try context.save()
        } catch {
            print("Failed saving entity")
        }
        
        //save image
        saveImage(imageNameWithExtention: "\(id).jpg", image: image, quality:  0.3)
        saveImage(imageNameWithExtention: "\(id)_thumbnail.jpg", image: thumbnail, quality: Float(quality)/100.0)
    }
    
    //Saves image to app documents
    static func saveImage(imageNameWithExtention : String, image : UIImage, quality : Float){
        //get path
        let imageURL = getImagePath(imageNameWithExtention: imageNameWithExtention)
        
        
        //sanitate quality
        var qual = quality
        if qual > 1 {
            qual = 1.0
        }else if qual < 0 {
            qual = 0.0
        }
        
        //save image
        try? image.jpegData(compressionQuality: CGFloat(qual))?.write(to: imageURL)
    }
    
    //Loads image from app documents
    static func loadImage(imageNameWithExtention : String) -> UIImage {
        //get path
        let imageURL = getImagePath(imageNameWithExtention: imageNameWithExtention)
        
        // check if the image is stored already
        if FileManager.default.fileExists(atPath: imageURL.relativePath),
            let imageData: Data = try? Data(contentsOf: imageURL),
            let image: UIImage = UIImage(data: imageData, scale: UIScreen.main.scale) {
            return image
        }else {
            print("File doesn't exist")
        }
        return UIImage()
    }
    
    //Deletes image from app documents
    static func deleteImage(imageNameWithExtention : String) {
        //get path
        let imageURL = getImagePath(imageNameWithExtention: imageNameWithExtention)
        
        // Create a FileManager instance
        let fileManager = FileManager.default

        do {
            try fileManager.removeItem(atPath: imageURL.relativePath)
        }
        catch let error as NSError {
            print("Image couldn't be deleted : \(error)")
        }
    }
    
    //Gets image path from app documents using the name and extention
    private static func getImagePath(imageNameWithExtention : String) -> URL {
        //create image path
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageNameWithExtention)"
        //return path
        return URL(fileURLWithPath: imagePath)
    }
}
