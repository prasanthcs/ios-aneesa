//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Aneesa on 20/06/20.
//  Copyright © 2020 Aneesa. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var imgNewsLogo: UIImageView!
    
    var index : Int!
    var newsDetails : NewsDeatils!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        newsDetails = NewsManager.sharedInstance.news[index]
        if let title = newsDetails.title{
            lblTitle.text = title
        }
        if let date = newsDetails.publishedAt{
            lblDate.text = date
        }
        if let author = newsDetails.author{
            lblAuthor.text = author
        }
        if let content = newsDetails.content{
          //  lblContent.attributedText = content.htmlAttributed(family: "system", size: 15, color: .red)
            
            lblContent.text = content
        }
        
        imgNewsLogo.downloaded(from: newsDetails.urlToImage!)
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toWeb" {
            if let vc = segue.destination as? DetailWebViewController {
                if let weburl = newsDetails.url{
                    vc.weburl = weburl
                }
            }
        }
    }
    
    @IBAction func moreClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toWeb", sender: self)
    }
}

extension String {
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "color: #\(color.hexString) !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"

            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }

            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

extension UIColor {
    var hexString: String {
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)),
                               lroundf(Float(b * 255)))

        return hexString
    }
}
