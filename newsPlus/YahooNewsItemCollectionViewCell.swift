//
//  YahooNewsItemCollectionViewCell.swift
//  newsPlus
//
//  Created by Giancarlo Daniele on 9/7/14.
//  Copyright (c) 2014 Giancarlo Daniele. All rights reserved.
//

import UIKit

class YahooNewsItemCollectionViewCell: UICollectionViewCell {
    var item : YahooNewsItem?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var readArticleButton: UIButton!
    var uuid: String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func readArticleButtonPressed(sender: AnyObject) {
        //segue to articleView
    }
}