//
//  DetailsViewController.swift
//  RSSFeedTask
//
//  Created by Gennady on 7/20/16.
//  Copyright © 2016 Gennady. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var link : String?
    
    override func viewDidLoad() {
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        session.dataTaskWithURL(NSURL(string: link!)!) { (data, response, error) in
        
            var str = String(data: data!, encoding: NSUTF8StringEncoding)
            	print(str)

        }.resume()
        
        
    }
}
