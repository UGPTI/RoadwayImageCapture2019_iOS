//
//  NetworkingTests.swift
//  Road Capture
//
//  Created by Aaron Sletten on 2/10/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import Foundation
import Alamofire
import SwiftlyJSON

class NetworkingTests{
    
    
    func upload(image: UIImage,
                progressCompletion: @escaping (_ percent: Float) -> Void,
                completion: @escaping (_ tags: [String]?, _ colors: [UIColor]?) -> Void) {
        
        
        
        // 1
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        // 2
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData,
                                     withName: "imagefile",
                                     fileName: "image.jpg",
                                     mimeType: "image/jpeg")
        },
                         to: "http://api.imagga.com/v1/content",
                         headers: ["Authorization": "Basic xxx"],
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.uploadProgress { progress in
                                    progressCompletion(Float(progress.fractionCompleted))
                                }
                                upload.validate()
                                upload.responseJSON { response in
                                    // 1
                                    guard response.result.isSuccess,
                                        let value = response.result.value else {
                                            print("Error while uploading file: \(String(describing: response.result.error))")
                                            completion(nil, nil)
                                            return
                                    }
                                    
                                    // 2
                                    let firstFileID = JSON(value)["uploaded"][0]["id"].stringValue
                                    print("Content uploaded with ID: \(firstFileID)")
                                    
                                    //3
                                    completion(nil, nil)

                                }
                            case .failure(let encodingError):
                                print(encodingError)
                            }
        })
    }
}
