//
//  MainVC.swift
//  Image Finder
//
//  Created by Austin Zheng on 8/2/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import Foundation
import UIKit

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var images:[Data] = []
    var urls:[String] = ["https://www.petmd.com/sites/default/files/Senior-Cat-Care-2070625.jpg","https://upload.wikimedia.org/wikipedia/commons/6/66/An_up-close_picture_of_a_curious_male_domestic_shorthair_tabby_cat.jpg","https://www.catster.com/wp-content/uploads/2018/05/A-gray-cat-crying-looking-upset.jpg","https://www.humanesociety.org/sites/default/files/styles/768x326/public/2018/08/kitten-440379.jpg?h=f6a7b1af&itok=vU0J0uZR","https://img.washingtonpost.com/wp-apps/imrs.php?src=https://img.washingtonpost.com/rf/image_960w/2010-2019/WashingtonPost/2016/05/05/Interactivity/Images/iStock_000001440835_Large1462483441.jpg&w=1484","https://media.mnn.com/assets/images/2018/07/cat_eating_fancy_ice_cream.jpg.1080x0_q100_crop-scale.jpg","https://www.sciencenews.org/sites/default/files/2019/07/main/articles/072319_ee_cat-allergy_feat.jpg","https://cdn.britannica.com/67/197567-131-1645A26E.jpg","https://images-production.freetls.fastly.net/uploads/posts/off_site_promo_image/166842/why-do-cats-meow.jpg?auto=compress&crop=top&fit=crop&q=55&w=1200&h=900","https://cdn.theatlantic.com/assets/media/img/mt/2017/06/shutterstock_319985324/lead_720_405.jpg?mod=1533691890","https://media.vanityfair.com/photos/5cdecf8e1d6b8739f44c2ef6/master/pass/Grumpy-Cat-Obit.jpg","https://i2.wp.com/metro.co.uk/wp-content/uploads/2019/07/standing-cats-comp.png?quality=90&strip=all&zoom=1&resize=964%2C541&ssl=1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getAllTheData(urls: urls)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let currentImage = UIImage(data: images[indexPath.row])
        let imageCrop = currentImage!.getCropRatio()
        return tableView.frame.width / imageCrop
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TvCell") as! TvCell
        let cellTask = images[indexPath.row]
        cell.setCellImage(imageData: cellTask)
        return cell
    }
    
    func getAllTheData(urls:[String]) {
        for url in urls {
            runSession(url: url)
        }
    }
    
    func runSession(url: String) {
        guard let currentUrl = URL(string: url ) else{
            return
        }
        let request = URLRequest(url: currentUrl)
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else{
                return
            }
            self.images.append(data)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        session.resume()
    }
    
}

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}
