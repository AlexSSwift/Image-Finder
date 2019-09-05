//
//  tvCell.swift
//  Image Finder
//
//  Created by Austin Zheng on 8/2/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import Foundation
import UIKit

class TvCell: UITableViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    func setCellImage(imageData: Data) {
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.image = UIImage(data: imageData)
       
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return cellImage
    }
    
    

}
