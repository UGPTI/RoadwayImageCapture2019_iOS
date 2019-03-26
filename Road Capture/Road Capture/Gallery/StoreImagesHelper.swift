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

    static func storeImageCapture(id : Int, latitude : Float, longitude : Float, quality : Int, agency : String, image : UIImage, thumbnail : UIImage){
        //create entity
        let entity = NSEntityDescription.entity(forEntityName: "ImageCapture", in: context)
        let newImageCapture = NSManagedObject(entity: entity!, insertInto: context)
        
        //save image
        saveImage(imageNameWithExtention: "\(id).jpg", image: image)
        saveImage(imageNameWithExtention: "\(id)_thumbnail.jpg", image: thumbnail)
        
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
    }
    
    static func saveImage(imageNameWithExtention : String, image : UIImage){
        //get path
        let imageURL = getImagePath(imageNameWithExtention: imageNameWithExtention)
        
        //save image
        try? image.jpegData(compressionQuality: 0.2)?.write(to: imageURL)
    }
    
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
    
    private static func getImagePath(imageNameWithExtention : String) -> URL {
        //create image path
        let imagePath: String = "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])/\(imageNameWithExtention)"
        //return path
        return URL(fileURLWithPath: imagePath)
    }
}
