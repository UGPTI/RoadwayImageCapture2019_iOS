//
//  NetworkingTests.swift
//  Road Capture
//
//  Created by Aaron Sletten on 2/10/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class NetworkingTests{

    private static func postTest(imageData : Data){
        //Create date
        let id = getDateString()
        
        //Create imageData string
        let image = imageData.base64EncodedString(options: .lineLength64Characters)
        
        //Create parameter list
        let parameters : [String: Any] = [
            "username" : "RIC",
            "password" : "@RICsdP4T",
            "id" : id,
            "latitude" : 46.8876,
            "longitude" : -96.8054,
            "quality" : 1,
            "agency" : "Capstone_Test",
            "image" : image,
            "filename" : "\(id).jpg"
        ]
        
        
        Alamofire.request("https://dotsc.ugpti.ndsu.nodak.edu/RIC/upload1.php", method: .post, parameters: parameters, encoding: URLEncoding.default).responseString { response in
            
//            print("Request: \(String(describing: response.request))\n")     // original url request
//            print("Response: \(String(describing: response.response))\n")     // http url response
//            print("Result: \(response.result)\n")                           // response serialization result
            
            print(response.result.value as? String)
//            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
//            }
//
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
        }
    }
    
    static func uploadImage(imageCapture : ImageCapture, deleteAfter : Bool) {
        //get image file name
        let imageNameWithExtention = "\(imageCapture.id).jpg"
        //load image
        let image = StoreImagesHelper.loadImage(imageNameWithExtention: imageNameWithExtention)
        //convert to data
        let imageData = image.jpegData(compressionQuality: CGFloat(imageCapture.quality) / 100.0)
        //create base 64 string
        guard let imageBase64String = imageData?.base64EncodedString(options: .lineLength64Characters) else {
            return
        }
        
        //Create parameter list
        let parameters : [String: Any] = [
            "username" : "RIC",
            "password" : "@RICsdP4T",
            "id" : imageCapture.id,
            "latitude" : 46.8876,
            "longitude" : -96.8054,
            "quality" : imageCapture.quality,
            "agency" : imageCapture.agency ?? "",
            "image" : imageBase64String,
            "filename" : imageNameWithExtention
        ]
        
        Alamofire.request("https://dotsc.ugpti.ndsu.nodak.edu/RIC/upload1.php", method: .post, parameters: parameters, encoding: URLEncoding.default).responseString { response in
            //check if true in response
            if let responseValue = response.result.value {
                if responseValue.contains("TRUE") {
                     print("\(imageCapture.id) : lat:\(imageCapture.latitude) long:\(imageCapture.longitude) was uploaded")
                    
                    if deleteAfter {
                        //get app delegate
                        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                        //get context
                        let context = appDelegate.persistentContainer.viewContext
                        
                        
                        
                        //delete images from file system
                        StoreImagesHelper.deleteImage(imageNameWithExtention: "\(imageCapture.id).jpg")
                        StoreImagesHelper.deleteImage(imageNameWithExtention: "\(imageCapture.id)_thumbnail.jpg")
                        context.delete(imageCapture)
                        //save context
                        do {
                            try context.save()
                        }
                        catch {
                            print("couldnt save after delete")
                        }
                    }
                }
            }
        }
    }

    static func getDateString() -> String {
        let date = Date().timeIntervalSince1970 //This is a Double
        return "\(Int(date*1000))"
    }
}
