//
//  NetworkingTests.swift
//  Road Capture
//
//  Created by Aaron Sletten on 2/10/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingTests{

    static func postTest(){
        //Get image
        let imageFile = UIImage(named: "Test.jpg")
        
        //Create image data
        guard let imageData = imageFile!.jpegData(compressionQuality: 1) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        //Create date
        let id = getDateString()
        
        //Create imageData string
        let image = imageData.base64EncodedString()
        
        //Create parameter list
        let parameters : [String: Any] = [
            "username" : "RIC",
            "password" : "@RICsdP4T",
            "id" : id,
            "latitude" : 46.8872,
            "longitude" : -96.8054,
            "quality" : 1,
            "agency" : "Capstone_Test",
            "image" : image,
            "filename" : "\(id).jpg"
        ]
        
        Alamofire.request("https://dotsc.ugpti.ndsu.nodak.edu/RIC/upload1.php", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
            print("Request: \(String(describing: response.request))\n")     // original url request
            print("Response: \(String(describing: response.response))\n")     // http url response
            print("Result: \(response.result)\n")                           // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
    }

    static func uploadTest(){
        //Create image
        let image = UIImage.init(named: "Test.JPG")
        //let imgData = UIImageJPEGRepresentation(image!, 0.2)!
        let imgData = image!.jpegData(compressionQuality: 100)!
        //print(imgData.base64EncodedString())
        
        //Get datetime
//        let date = Date().timeIntervalSince1970 //This is a Double
//        var dateString = "\(Int(date*1000))"
        let dateString = getDateString()
        //1430337023781 - reference
        //1553047842925 - actual
        
        //Create Parameters
        let parameters : [String: String] = [
            "username" : "RIC",
            "password" : "@RICsdP4T",
            "id" : dateString,
            "latitude" : "46.8872",
            "longitude" : "-96.8054",
            "quality" : "100",
            "agency" : "Capstone_Test",
        ]
        
        //Upload
        Alamofire.upload(multipartFormData: { multipartFormData in
            //Add parameters
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
            //Add image
            multipartFormData.append(imgData.base64EncodedData(options: Data.Base64EncodingOptions.endLineWithCarriageReturn), withName: "bitmap", fileName: "\(dateString).jpg", mimeType: "image/jpg")
            
        }, to: "https://dotsc.ugpti.ndsu.nodak.edu/RIC/upload1.php") { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response)
                    print(response.result.value)
                    print()
                    print(result)
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    static func getDateString() -> String {
        let date = Date().timeIntervalSince1970 //This is a Double
        return "\(Int(date*1000))"
    }
}
