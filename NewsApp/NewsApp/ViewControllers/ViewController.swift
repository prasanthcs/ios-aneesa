//
//  ViewController.swift
//  NewsApp
//
//  Created by Aneesa on 6/18/20.
//  Copyright © 2020 Aneesa. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var lblPageTitle: UILabel!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var tblsidemenu: UITableView!
    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var lblheadlinescroll: UILabel!
    
    var clickedIndex : Int = 0
    var catgry : String = ""
    
    var menuArray = ["All","Business","Entertainment","General","Health","Science","Sports","Technology"]
    
    let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        lblPageTitle.text = "NEWS"
        
        activityView.center = self.view.center
        activityView.color = UIColor.red
        self.view.addSubview(activityView)
        
        sideMenuView.frame.origin.x = -500
        lblheadlinescroll.translatesAutoresizingMaskIntoConstraints = false
        
        tblList.register(UINib.init(nibName: "newsListCell", bundle: Bundle.main), forCellReuseIdentifier: "newsListCell")
        
        getAllNews()
        getTopHeadlines()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTopHeadlines()
    }
    
    func getAllNews()
    {
        activityView.startAnimating()
        NewsManager.sharedInstance.GetAllNews { (status, response) in
            if status{
                DispatchQueue.main.async{
                    self.tblList.reloadData()
                    self.activityView.stopAnimating()
                }
            }
        }
    }
    
    func getTopHeadlines()
    {
        NewsManager.sharedInstance.GetHeadLines { (status, response) in
            if status{
                DispatchQueue.main.async{
                    self.lblheadlinescroll.text = NewsManager.sharedInstance.scrollText
                    self.startAnimation()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetails" {
            if let vc = segue.destination as? NewsDetailViewController {
                vc.index = clickedIndex
            }
        }
    }
    
    func startAnimation()
    {
        //Animating the label automatically change as per your requirement
        DispatchQueue.main.async(execute: {
            
            UIView.animate(withDuration: 150.0, delay: 1, options: ([.curveLinear, .repeat]), animations: {
                () -> Void in
                self.lblheadlinescroll.center = CGPoint(x: 0 - self.lblheadlinescroll.bounds.size.width / 2, y: self.lblheadlinescroll.center.y)
            }, completion:  nil)
        })
    }
    
    @IBAction func menuClicked(_ sender: Any) {
        
        sideMenuView.frame.origin.x = 0
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        view.layer.add(transition, forKey: nil)
        view.addSubview(sideMenuView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == tblsidemenu{
            return menuArray.count
        }
        else{
            return NewsManager.sharedInstance.news.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblsidemenu{
            var cell : UITableViewCell!
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell");
            cell.textLabel?.text = self.menuArray[indexPath.row]
            cell.selectionStyle = .none
            cell.backgroundColor = .none
            cell.textLabel?.textColor = .white
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsListCell", for: indexPath) as! newsListCell
            cell.selectionStyle = .none
            
            if let title = NewsManager.sharedInstance.news[indexPath.row].title{
                cell.lblTitle.text = title
            }
            
            if let desc = NewsManager.sharedInstance.news[indexPath.row].description{
                cell.lblDescrptn.text = desc
            } else{
                cell.lblDescrptn.text = ""
            }
            
            if let image = NewsManager.sharedInstance.news[indexPath.row].urlToImage{
                cell.imgNews.downloaded(from: image)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblsidemenu{
            return 50
        }
        else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblsidemenu{
            
            if indexPath.row == 0 {
                getAllNews()
                lblPageTitle.text = "NEWS"
            }
            else{
                catgry = menuArray[indexPath.row]
                lblPageTitle.text = catgry
                activityView.startAnimating()
                NewsManager.sharedInstance.GetCategoryNews(categories: catgry) { (status, response) in
                    if status{
                        DispatchQueue.main.async{
                            self.tblList.reloadData()
                            self.activityView.stopAnimating()
                        }
                    }
                }
            }
            sideMenuView.frame.origin.x = -500              
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            view.layer.add(transition, forKey: nil)
            view.addSubview(sideMenuView)           
        }
        else
        {
            clickedIndex = indexPath.row
            self.performSegue(withIdentifier: "ShowDetails", sender: self)
        }
    }
}

