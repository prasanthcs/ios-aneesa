//
//  NewsManager.swift
//  NewsApp
//
//  Created by Aneesa on 20/06/20.
//  Copyright © 2020 Aneesa. All rights reserved.
//

import UIKit

class NewsManager: NSObject {
    
    var mainUrl: String = "http://newsapi.org/v2/top-headlines"
    var news : [NewsDeatils] = []
    var scrollText : String = ""
    
    static let sharedInstance: NewsManager = {
        let instance = NewsManager()
        return instance
    }()
    
    func GetCategoryNews( categories :String, completionHandler: @escaping (Bool,String) -> Void) {
        WebManager.Get( url: mainUrl + "?country=In&category=\(categories)&apiKey=5a34796cd37042e1890dfbe7973dba52", completionHandler:  { data -> Void in
           do {
            if data["status"]! as! String == "ok" {
                //let jsonData = try Data(contentsOf: url)
                let newsArray = data["articles"]
                let dataResponse: Data = try JSONSerialization.data(withJSONObject: newsArray as Any, options: .prettyPrinted)
                self.news = try! JSONDecoder().decode([NewsDeatils].self, from: dataResponse)
                completionHandler(true,"errorString")
            } else {
               
                completionHandler(false, "errorString")
            }
           } catch {
           }
       })
   }

    func GetAllNews(completionHandler: @escaping (Bool,String) -> Void) {
         WebManager.Get( url: mainUrl + "?country=In&apiKey=5a34796cd37042e1890dfbe7973dba52", completionHandler:  { data -> Void in
            do {
                
             if data["status"]! as! String == "ok" {
                 //let jsonData = try Data(contentsOf: url)
                 var newsArray = data["articles"]
                 let dataResponse: Data = try JSONSerialization.data(withJSONObject: newsArray, options: .prettyPrinted)
                 self.news = try! JSONDecoder().decode([NewsDeatils].self, from: dataResponse)
                 completionHandler(true,"errorString")
             } else {
                
                 completionHandler(false, "errorString")
             }
            } catch {
            }
        })
    }
    
    func GetHeadLines(completionHandler: @escaping (Bool,String) -> Void) {
        WebManager.Get( url: mainUrl + "?country=In&apiKey=5a34796cd37042e1890dfbe7973dba52", completionHandler:  { data -> Void in
            do {
             if data["status"]! as! String == "ok" {
                 //let jsonData = try Data(contentsOf: url)
                let newsArray = data["articles"] as! [NSDictionary]
                 //let dataResponse: Data = try JSONSerialization.data(withJSONObject: newsArray, options: .prettyPrinted)
                for each in newsArray{
                    self.scrollText.append(each["title"] as! String)
                    self.scrollText.append("   --  ")
                }
                 completionHandler(true,"errorString")
             } else {
                
                 completionHandler(false, "errorString")
             }
            } catch {
            }
        })
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
