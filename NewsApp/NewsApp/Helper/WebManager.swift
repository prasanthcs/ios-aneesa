//
//  WebManager.swift
//  NewsApp
//
//  Created by Aneesa on 20/06/20.
//  Copyright © 2020 Aneesa. All rights reserved.
//

import UIKit
import Foundation

class WebManager: NSObject {
   static func Get(url: String, completionHandler: @escaping (Dictionary<String, Any>) -> Void) {
        let task = Foundation.URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                NSLog("URL :- \(url) \n  ERROR :- \(error)")
                completionHandler(["status":"Failed", "message":"\(String(describing: error))"])
            } else {
                let httpResponse = response as! HTTPURLResponse
                if (httpResponse.statusCode == 200) {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? Dictionary<String, Any> {
                            completionHandler(json  as! Dictionary<String, Any>)
                        } else {
                                NSLog("URL :- \(url) \n  ERROR :- \(error)")
                            completionHandler(["status":"Failed", "message":"Unable to serialize responce json, seems invalid"])
                        }
                    } catch {
                            NSLog("URL :- \(url) \n  ERROR :- \(error)")
                        completionHandler(["status":"Failed", "message":"\(error)"])
                    }
                } else {
                        NSLog("URL :- \(url) \n  ERROR :- \(error)")
                    completionHandler(["status":"Failed", "message":"HttpResponse Status: \(httpResponse.statusCode)"])
                }
            }
        })
        task.resume()
    }
}
