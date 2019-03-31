//
//  ImageCollectionViewCell.swift
//  Collection View
//
//  Created by Aaron Sletten on 2/19/19.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
//    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var tickImageView: UIImageView!
    
    var selected1 = false

    
    override var isSelected: Bool {
        didSet{
            
//            !self.isSelected && oldValue
            
            if !self.isSelected && !oldValue {
                selected1 = true
            }
            else if self.isSelected && oldValue {
                selected1 = false
            }
            
            if selected1 {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.tickImageView.isHidden = false
            }else{
                self.transform = CGAffineTransform.identity
                self.tickImageView.isHidden = true
            }
        }
    }
    
}
