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

    static func storeImageCapture(id : Int, latitude : Float, logitude : Float, quality : Int, agency : String, image : Data){
        //get app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //get context
        let context = appDelegate.persistentContainer.viewContext
        
        //create entity
        let entity = NSEntityDescription.entity(forEntityName: "ImageCapture", in: context)
        let newImageCapture = NSManagedObject(entity: entity!, insertInto: context)
        //populate entity
        newImageCapture.setValue(id, forKey: "id")
        newImageCapture.setValue(latitude, forKey: "latitude")
        newImageCapture.setValue(logitude, forKey: "logitude")
        newImageCapture.setValue(quality, forKey: "quality")
        newImageCapture.setValue(agency, forKey: "agency")
        newImageCapture.setValue(image, forKey: "image")
        //save entity
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    static func getAllImages() -> [ImageCapture]{
        //get app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //get context
        let context = appDelegate.persistentContainer.viewContext
        
        //create request
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageCapture")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        //execute request
        do {
            let result = try context.fetch(request)
            
            return result as! [ImageCapture]
            
//            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "id") as! String)
//            }
        } catch {
            
            print("Failed")
        }
        return []
    }
}
