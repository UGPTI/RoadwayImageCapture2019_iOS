//
//  NetworkingTests.swift
//  Road Capture
//
//  Created by Aaron Sletten on 2/10/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkingTests{
    
    static func postTest(){
        //Get image
        let image = UIImage(named: "Test.JPG")
        
        //Create image data
        guard let imageData = image!.jpegData(compressionQuality: 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        //Create date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        //Create parameter list
        let parameters : [String: Any] = [
            "username" : "RIC",
            "password" : "@RICsdP4T",
            "id" : dateString,
            "latitude" : 46.8872,
            "longitude" : -96.8054,
            "quality" : 1,
            "agency" : "Capstone Test",
            "image" : imageData.base64EncodedString(),
            "filename" : "Aarons_First_Test_1.jpg"
        ]
        
        Alamofire.request("https://dotsc.ugpti.ndsu.nodak.edu/RIC/upload1.php", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in
//            print("Request: \(String(describing: response.request))\n")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)\n")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        
        print(imageData.base64EncodedString())
    }
}
