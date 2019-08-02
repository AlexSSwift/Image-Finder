//
//  ViewController.swift
//  Image Finder
//
//  Created by Austin Zheng on 8/2/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        runSession()
    }

    func runSession() {
        guard let url = URL(string:"https://upload.wikimedia.org/wikipedia/commons/6/66/An_up-close_picture_of_a_curious_male_domestic_shorthair_tabby_cat.jpg") else {
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                return
            }
            DispatchQueue.main.async {
            self.image.image = UIImage(data: data)
            }
        }
        session.resume()
        
    }
  
}

