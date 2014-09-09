//
//  NewsItemDetailViewController.swift
//  newsPlus
//
//  Created by Giancarlo Daniele on 9/9/14.
//  Copyright (c) 2014 Giancarlo Daniele. All rights reserved.
//

import UIKit

class NewsItemDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originalImageView: UIImageView!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
