//
//  YahooNewsItem.swift
//  newsPlus
//
//  Created by Giancarlo Daniele on 9/4/14.
//  Copyright (c) 2014 Giancarlo Daniele. All rights reserved.
//

import UIKit

class YahooNewsItem: NSObject {
    var title : String?
    var publisher : String?
    var thumbnailImage : UIImage?
    var fullImage : UIImage?
    var imageLink : String?

    var uudid : String!
    
    init(fromDictionary json : JSONValue) {
        if let titleString = json["title"].string {
            self.title = titleString
        }
        if let publisherString = json["publisher"].string {
            self.publisher = publisherString
        }
        if let imageLinkString = json["_original_image"].string {
            self.imageLink = imageLinkString
        }
        if let uudidString = json["uudid"].string {
            self.uudid = uudidString
        }
    }
}