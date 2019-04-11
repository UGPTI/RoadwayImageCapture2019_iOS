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

class NetworkingHelper{
    //upload image to server
    static func uploadImage(imageCapture : ImageCapture, deleteAfter : Bool) {
        //get image file name
        let imageNameWithExtention = "\(imageCapture.id).jpg"
        //load image
        let image = StoreImagesHelper.loadImage(imageNameWithExtention: imageNameWithExtention)
        //convert to data - this compresses the image twice 😬
        let imageData = image.jpegData(compressionQuality: CGFloat(imageCapture.quality) / 100.0)
        //create base 64 string
        guard let imageBase64String = imageData?.base64EncodedString(options: .lineLength64Characters) else {
            return
        }
        
        //46.8876, -96.8054,
        //Create parameter list
        let parameters : [String: Any] = [
            "username" : "RIC",
            "password" : "@RICsdP4T",
            "id" : imageCapture.id,
            "latitude" : imageCapture.latitude,
            "longitude" : imageCapture.longitude,
            "quality" : imageCapture.quality,
            "agency" : imageCapture.agency ?? "",
            "image" : imageBase64String,
            "filename" : imageNameWithExtention
        ]
        
        Alamofire.request("https://dotsc.ugpti.ndsu.nodak.edu/RIC/upload1.php", method: .post, parameters: parameters, encoding: URLEncoding.default)
            .downloadProgress { progress in // main queue by default
                print("Upload Progress: \(progress.fractionCompleted)")
            }
            .responseString { response in
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
    
    //upload image to server
    static func uploadImageUseingUpload(imageCapture : ImageCapture, deleteAfter : Bool, progressBar : UIProgressView?, completion : @escaping () -> ()) {
        DispatchQueue.main.async {        
            //set progress bar to visible and set to 0
            progressBar?.progress = 0
            progressBar?.isHidden = false
        }
        //get image file name
        let imageNameWithExtention = "\(imageCapture.id).jpg"
        //load image
        let image = StoreImagesHelper.loadImage(imageNameWithExtention: imageNameWithExtention)
        //convert to data - this compresses the image twice 😬
        let imageData = image.jpegData(compressionQuality: CGFloat(imageCapture.quality) / 100.0)
        //create base 64 string
        guard let imageBase64String = imageData?.base64EncodedString(options: .lineLength64Characters) else {
            return
        }
        
        //46.8876, -96.8054,
        //Create parameter list
        let parameters : [String: String] = [
            "username" : "RIC",
            "password" : "@RICsdP4T",
            "id" : "\(imageCapture.id)",
            "latitude" : "\(imageCapture.latitude)",
            "longitude" : "\(imageCapture.longitude)",
            "quality" : "\(imageCapture.quality)",
            "agency" : imageCapture.agency ?? "",
            "image" : imageBase64String,
            "filename" : imageNameWithExtention
        ]
        
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for key in parameters.keys {
                    multipartFormData.append(parameters[key]!.data(using: .utf8)!, withName: key)
                }
        },
            to: "https://dotsc.ugpti.ndsu.nodak.edu/RIC/upload1.php",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        print(response.value)
                        
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
                        
                        //reset progress bar in case cell gets reused
                        DispatchQueue.main.async {
                            progressBar?.progress = 0
                            progressBar?.isHidden = true
                        }
                        
                        completion()
                    }
                    upload.uploadProgress { progress in
                        DispatchQueue.main.async {
                            progressBar?.setProgress(Float(progress.fractionCompleted), animated: true)
                            print(progress.fractionCompleted)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                    completion()
                }
        })
    }
    
    static func getDateString() -> String {
        let date = Date().timeIntervalSince1970 //This is a Double
        return "\(Int(date*1000))"
    }
}
