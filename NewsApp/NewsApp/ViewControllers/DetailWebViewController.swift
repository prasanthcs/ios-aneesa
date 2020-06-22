//
//  DetailWebViewController.swift
//  NewsApp
//
//  Created by Aneesa on 20/06/20.
//  Copyright © 2020 Aneesa. All rights reserved.
//

import UIKit
import WebKit

class DetailWebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate{
    
    @IBOutlet weak var webView: WKWebView!
    let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var weburl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        activityView.center = self.view.center
        activityView.color = UIColor.red
        self.view.addSubview(activityView)
        activityView.startAnimating()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        guard let url = URL(string: weburl) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        // add activity
        self.webView.addSubview(self.activityView)
        self.activityView.startAnimating()
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityView.stopAnimating()
    }
}
