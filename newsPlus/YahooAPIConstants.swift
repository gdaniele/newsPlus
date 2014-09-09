//
//  YahooAPIConstants
//  newsPlus
//
//  Created by Giancarlo Daniele on 9/5/14.
//  Copyright (c) 2014 Giancarlo Daniele. All rights reserved.
//

import UIKit

class YahooAPIConstants: NSObject {
    let KYAHOO_NEWS_STREAM_URL : String! = "http://mhr.yql.yahoo.com/v1/newsfeed?all_content=1"
    let KYAHOO_NEWS_STREAM_INFLATION_URL : String! = "http://mhr.yql.yahoo.com/v1/newsitems?uuid="
    var cellHeaderHeight : Float = 25
    var cellFooterHeight : Float = 25
    var cellWidth = Float(UIScreen.mainScreen().bounds.size.width) - 20.0
    var cellHeight = Float(UIScreen.mainScreen().bounds.size.width) - 20.0 + 50
}