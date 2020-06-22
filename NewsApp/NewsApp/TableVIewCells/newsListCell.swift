//
//  newsListCell.swift
//  NewsApp
//
//  Created by Aneesa on 20/06/20.
//  Copyright © 2020 Aneesa. All rights reserved.
//

import UIKit

class newsListCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescrptn: UILabel!
    @IBOutlet weak var imgNews: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
