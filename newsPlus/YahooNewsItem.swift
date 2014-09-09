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
    var thumbnailLink : String?
    var originalLink : String?
    var articleText : String?

    var uuid : String!
    
    init(fromDictionary json : JSONValue) {
        if let titleString = json["title"].string {
            self.title = titleString
        }
        if let publisherString = json["publisher"].string {
            self.publisher = publisherString
        }
        if let uuidString = json["uuid"].string {
            self.uuid = uuidString
        }
        if let textString = json["summary"].string {
            self.articleText = textString
        }
        if let imagesArray : Array<JSONValue> = json["images"].array {
            for image in imagesArray {
                if let tagsForImage : Array<JSONValue> = image["tags"].array {
                    for tag in tagsForImage {
                        if let tag = tag.string {
                            if tag == "size=original" {
                                if let imageLink : String = image["url"].string {
                                    self.originalLink = imageLink
                                }
                            }
                            if tag == "ios:size=square_large" {
                                if let imageLink : String = image["url"].string {
                                    self.thumbnailLink = imageLink
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}