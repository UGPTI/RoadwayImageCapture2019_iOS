//
//  PasswordViewController.swift
//  Road Capture
//
//  Created by Aaron Sletten on 4/22/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    
//    let password = "1234"
    let password = "iTvR!c6u"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField.text == password {
            UserDefaults.standard.set(true, forKey: "loggedin")
            
            //go to home screen
            let viewController : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as UIViewController
            present(viewController, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Incorrect password", message: "Try again or contact UGPTI for the correct password.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true)
        }
        
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
