//
//  MainVC.swift
//  Image Finder
//
//  Created by Austin Zheng on 8/2/19.
//  Copyright © 2019 Austin Zheng. All rights reserved.
//

import Foundation
import UIKit

struct Image {
    var imageData: Data?
    let link: URL
    let height: Int
    let width: Int
    let thumbnailLink: URL
    let thumbnailHeight: Int
    let thumbnailWidth: Int
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func searchButton(_ sender: UIButton) {
        images = []
        imagesForTableView = []
        search(startNumber: 1)
    }
    @IBOutlet weak var tableView: UITableView!
    
    var images:[Image] = []
    var imagesForTableView: [Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesForTableView.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let currentImage = UIImage(data: imagesForTableView[indexPath.row].imageData!){
            let imageRatio = currentImage.getCropRatio()
            
            return tableView.frame.width / imageRatio
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TvCell") as! TvCell
        let cellTask = imagesForTableView[indexPath.row]
        if let image = cellTask.imageData  {
            cell.setCellImage(imageData: image)
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        let lastCell = imagesForTableView.count - 1
//
//        let expectedNumberOfImages = 10
//        let numberOfImagesCheck = imagesForTableView.count % expectedNumberOfImages == 0
//        if indexPath.row == lastCell {
//            if numberOfImagesCheck == true {
//                self.search(startNumber: imagesForTableView.count)
//            }
//        }
//    }
    
    func prepareImagesForTableView() {
        imagesForTableView = images.filter({return $0.imageData != nil})
    }
    
    func search(startNumber: Int) {
        
        var search: NSString = ""
        search = searchField.text! as NSString
        //let searchFiltered = NSString.addingPercentEncoding(search)
        let numberSearched: Int = 10
        let url = "https://www.googleapis.com/customsearch/v1?key=AIzaSyCOGUCrR0Mh2mzZ8UNP2-Wis2TEdSdLtQk&searchType=image&cx=013553353415577249476:qm1ft4ixm8q&q=\(String(describing: search))&num=\(numberSearched)&start=\(startNumber)"
        
        runSession(url: url)
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
            if error != nil {
                print("there is an error")
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                
                guard let items = jsonData["items"] as! [Any]? else{
                    print("could not turn the data into an array")
                    return
                }
                self.getImageFromItem(array: items)
                
                
                
                DispatchQueue.main.async {
                    for (index, image) in self.images.enumerated() {
                        self.getImageFromUrl(url: image.link, indexPath: index )
                    }
                }
            } catch {
                print("we couldn't get the data")
                return
            }
        }
        session.resume()
    }
    
    func getImageFromUrl(url: URL, indexPath: Int) {
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print("error: couldn't getthe image data")
            }
            
            guard let data = data else{
                return
            }
            DispatchQueue.main.async {
                self.images[indexPath].imageData = data
                self.prepareImagesForTableView()
                self.tableView.reloadData()
            }
        }
        session.resume()
    }
    
    func getImageFromItem(array:[Any]) {
        
        for rawObject in array {
            let object = rawObject as! [String:Any]
            let imageUrl = URL(string: object["link"] as! String)!
            let imageAtributes = object["image"] as! [String:Any]
            let imageHeight = imageAtributes["height"] as! Int
            let imageWidth = imageAtributes["width"] as! Int
            let thumbnailImage = URL(string: imageAtributes["thumbnailLink"] as! String)!
            let thumbnailHeight = imageAtributes["thumbnailHeight"] as! Int
            let thumbnailWidth = imageAtributes["thumbnailWidth"] as! Int
            
            images.append(Image(imageData: nil, link: imageUrl, height: imageHeight, width: imageWidth, thumbnailLink: thumbnailImage, thumbnailHeight: thumbnailHeight, thumbnailWidth: thumbnailWidth))
        }
    }
    
    
    
}

extension UIImage {
    func getCropRatio() -> CGFloat {
        let widthRatio = CGFloat(self.size.width / self.size.height)
        return widthRatio
    }
}
