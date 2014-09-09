//
//  NewsCollectionViewController.swift
//  newsPlus
//
//  Created by Giancarlo Daniele on 9/3/14.
//  Copyright (c) 2014 Giancarlo Daniele. All rights reserved.
//

import UIKit
import CoreLocation

let reuseIdentifier = "newsCell"

class NewsCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UINavigationBarDelegate {
    var collectionView: UICollectionView?
    let kImageViewTag : Int = 11 //the imageView for the collectionViewCell is tagged with 11 in IB
    let kHeaderViewTag : Int = 33 //the header for the collectionViewCell is tagged with 33 in IB
    let kFooterViewTag : Int = 22 //the footer for the collectionViewCell is tagged with 22 in IB
    let kNavbarTag : Int = 87
    var api : YahooApi = YahooApi.sharedInstance //shared instance of our api helper
    dynamic var accessToken : String! //dynamic KVO variable that sets access_token from UIWebView presented in this controller
    let activityIndicator : UIActivityIndicatorView! = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray) //for loading UIWebView
    var stateStatusView : UIView! // UIView overlay that communicates state messages to user
    var navBar : UINavigationBar!
    var imageDownloadsInProgress = Dictionary<NSIndexPath, PhotoDownloader>() // Mutable data structure of images currently being downloaded. We are lazy loading!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: CGFloat(YahooAPIConstants().cellWidth), height: CGFloat(YahooAPIConstants().cellHeight))
        //add the image view for photo display
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "YahooNewsItemCollectionViewCell", bundle: NSBundle.mainBundle()), forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
        
        // add KVO
        addobservers()
        
        //set up uinavigation bar
        navBar = UINavigationBar()
        navBar.frame = CGRectMake(0, 20, self.view.frame.size.width, 44)
        navBar.delegate = self
        
        //navbar titles and location swapping
        var item = UINavigationItem(title: "Loading News from Yahoo!..")
        navBar.pushNavigationItem(item, animated: true)
        navBar.tag = kNavbarTag
        self.view.addSubview(navBar)
    }
    
    override func viewDidDisappear(animated: Bool) {
        removeObservers()
    }
    
    override func viewWillAppear(animated: Bool) {
        YahooApi.requestAndLoadYahooNewsfeed({ () -> () in
            //
        }, failure: { () -> () in
            //
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        for (key, downloader) in imageDownloadsInProgress {
            downloader.cancelDownload({
                println("DEBUG: Cancelled download successfully")
            })
        }
        self.imageDownloadsInProgress.removeAll(keepCapacity: false)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        self.collectionView?.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let location = self.locationOnDisplay as YahooNewsItem? {
//            return location.recentPhotos.count
//        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var screenSize = UIScreen.mainScreen().bounds.size
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as YahooNewsItemCollectionViewCell
        
//        Load the photo for this cell
//        if let location = self.locationOnDisplay {
//            if location.recentPhotos.count >= indexPath.row {
//                var photo : YahooNewsItem = location.recentPhotos[indexPath.row]
//                if let likesCount : Int = photo.likeCount {
//                    cell.likesCountLabel.text = String(likesCount) + " likes"
//                } else {
//                    cell.likesCountLabel.text = ""
//                }
//                if let id : String = photo.id {
//                    cell.mediaID = id
//                } else {
//                    println("ERROR: cell without mediaID")
//                }
//                if let username : String = photo.user?.username {
//                    cell.usernameLabel.text = username
//                } else {
//                    cell.usernameLabel.text = ""
//                }
//                if let createdAt : NSDate = photo.createdAt {
//                    var formatter : NSDateFormatter = NSDateFormatter()
//                    formatter.dateFormat = "MM/dd/yyyy"
//                    cell.timeAgoLabel.text = formatter.stringFromDate(createdAt)
//                } else {
//                    cell.usernameLabel.text = ""
//                }
//                if (photo.image == nil) {
//                    // Dispatch operation to download the image
//                    if self.collectionView?.dragging == false && self.collectionView?.decelerating == false
//                    {
//                        startPhotoDownload(photo, indexPath: indexPath)
//                    }
//                    if let imageView = cell.viewWithTag(kImageViewTag) as? UIImageView {
//                        imageView.image = UIImage(named: "placeholder")
//                    }
//                } else {
//                    if let imageView = cell.viewWithTag(kImageViewTag) as? UIImageView {
//                        imageView.image = photo.image
//                    }
//                }
//
//            }
//        }
        return cell
    }
    
    // Starts PhotoDownload for Photo at index
    func startPhotoDownload(newsItem : YahooNewsItem, indexPath : NSIndexPath) {
        var downloader = self.imageDownloadsInProgress[indexPath]
        
        if (downloader == nil) {
            downloader = PhotoDownloader()
            downloader?.newsItem = newsItem
            self.imageDownloadsInProgress[indexPath] = downloader
            downloader!.completion = {
                if let cell : YahooNewsItemCollectionViewCell = self.collectionView?.cellForItemAtIndexPath(indexPath) as? YahooNewsItemCollectionViewCell {
                    cell.imageView.image = newsItem.thumbnailImage
                    self.imageDownloadsInProgress.removeValueForKey(indexPath)
                }
            }
            downloader?.startDownload()
        }
    }
    
    // This method is used in case the user scrolled into a set of cells that don't
    //  have their app icons yet.
    func loadImagesForOnscreenRows() {
//        if self.locationOnDisplay?.recentPhotos.count > 0  {
//            var visiblePaths = self.collectionView!.indexPathsForVisibleItems() as [NSIndexPath]
//            for path in visiblePaths {
//                if let photo = self.locationOnDisplay?.recentPhotos[path.row] {
//                    if (photo.image == nil) {
//                        startPhotoDownload(photo, indexPath: path)
//                    }
//                }
//            }
//        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.loadImagesForOnscreenRows()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.loadImagesForOnscreenRows()
    }
    
    //    MARK: Utilities
    func addobservers() {
        self.addObserver(api, forKeyPath: "accessToken", options: NSKeyValueObservingOptions.New, context: nil)
        self.addObserver(api, forKeyPath: "bestEffortAtLocation", options: NSKeyValueObservingOptions.New, context: nil)
        self.addObserver(self, forKeyPath: "currentLocation", options: NSKeyValueObservingOptions.New, context: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "yahooNewsItemsLoaded:", name: "loadedYahooNewsItems", object: nil)
    }
    
    func removeObservers() {
        self.removeObserver(api, forKeyPath: "accessToken")
        self.removeObserver(api, forKeyPath: "bestEffortAtLocation")
        self.removeObserver(self, forKeyPath: "currentLocation")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "loadedYahooNewsItems", object: nil)
    }
    
//    Incoming NSNotification that informs the view that the Yahoo API found locations with our given CLLocation
    func yahooNewsItemsLoaded(notification: NSNotification){
        println("DEBUG: Downloaded YahooNewsItem objects")
        loadYahooNewsItemsToView(api.yahooNewsItems)
    }
    
//    Loads the given Yahoo Location to the view
    func loadYahooNewsItemsToView(newsItems : [YahooNewsItem]) {
        // Set the current location
//        self.locationOnDisplay = location
//
//        // Dispatch a thread to download & parse metadata for photos at given location
//        location.downloadAndSaveRecentPhotos({ () -> () in
//            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                // On the main queue, reload the UICollectionView
//                if self.locationOnDisplay?.recentPhotos.count < 1 {
//                    self.navSingleTap()
//                } else {
//                    self.navBar.topItem?.title = self.locationOnDisplay?.name
//                    self.collectionView?.reloadData()
//                }
//            })
//        }, failure: { () -> () in
//            
//        })
    }
    
//    Toggles stateStatusView
    func toggleStateStatusView(enabled : Bool, text : String?) {
        if enabled{
            var screenBounds = UIScreen.mainScreen().bounds
            stateStatusView = UIView(frame: CGRect(x: 0, y: 20, width: screenBounds.size.width, height: screenBounds.size.height - 20))
            var messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 180, height: 100))
            messageLabel.text = text
            messageLabel.center = stateStatusView.center
            messageLabel.font = UIFont(name: "Helvetica Neue", size: 25)
            messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = NSTextAlignment.Center
            messageLabel.sizeToFit()
            messageLabel.textColor = UIColor.darkGrayColor()
            stateStatusView.addSubview(messageLabel)
            self.view.addSubview(stateStatusView)
        } else {
            if self.stateStatusView != nil {
                self.stateStatusView.removeFromSuperview()
                self.stateStatusView = nil
            }
        }
    }
    
//    UINavigationBar Delegates
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
