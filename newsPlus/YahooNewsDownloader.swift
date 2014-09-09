//
//  YahooNewsDownloader
//  newsPlus
//
//  Created by Giancarlo Daniele on 9/7/14.
//  Copyright (c) 2014 Giancarlo Daniele. All rights reserved.
//

import UIKit

class YahooNewsDownloader: NSObject, NSURLSessionDownloadDelegate {
    var newsItem : YahooNewsItem?
    var imageSession : NSURLSession?
    var imageDownload : NSURLSessionDownloadTask?
    var completion: (() -> ())?
    
    func startDownload() {
        if let imageSession : NSURLSession = self.imageSession {
            self.imageDownload = imageSession.downloadTaskWithURL(NSURL(string: newsItem!.thumbnailLink!))
            self.imageDownload?.resume()
        } else {
            self.imageSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate : self, delegateQueue: nil)
            startDownload()
        }
    }
    
    func cancelDownload(success : () -> ()) {
        self.imageDownload?.cancel()
        self.imageSession = nil
    }
    
    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        var image = UIImage(data: NSData(contentsOfURL: location))
        
        if (Float(image.size.width) != YahooAPIConstants().cellWidth || Float(image.size.height) != YahooAPIConstants().cellWidth)
        {
            var newsItemDimension = CGFloat(YahooAPIConstants().cellWidth)
            var itemSize = CGSizeMake(newsItemDimension, newsItemDimension)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
            var imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height)
            image.drawInRect(imageRect)
            self.newsItem?.thumbnailImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
        } else {
            self.newsItem?.thumbnailImage = image;
        }
        // Release the connection now that it's finished
        self.imageSession = nil;
        self.imageDownload = nil;

        // call our delegate and tell it that our icon is ready for display
        if (self.completion != nil) {
            self.completion!()
        }
    }
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        self.imageSession = nil
    }
}