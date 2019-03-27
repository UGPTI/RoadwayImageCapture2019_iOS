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

    override var isSelected: Bool {
        didSet{
            if self.isSelected
            {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.contentView.backgroundColor = UIColor.red
                self.tickImageView.isHidden = false
            }
            else
            {
                self.transform = CGAffineTransform.identity
                self.contentView.backgroundColor = UIColor.gray
                self.tickImageView.isHidden = true
            }
        }
    }
}
