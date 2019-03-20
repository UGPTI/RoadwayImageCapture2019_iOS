//
//  ViewController.swift
//  Networking
//
//  Created by Aaron Sletten on 3/19/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func sendImageButton(_ sender: Any) {
        //NetworkingTests.uploadTest()
    }
    
    @IBAction func postImageButton(_ sender: Any) {
        NetworkingTests.postTest()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

