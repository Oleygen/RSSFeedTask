//
//  MainViewController.swift
//  RSSFeedTask
//
//  Created by Gennady on 7/20/16.
//  Copyright © 2016 Gennady. All rights reserved.
//

import UIKit
import RealmSwift
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ParserDelegate {

    @IBOutlet private weak var tableView: UITableView!
    private  let mainToDetailsSegueIdentifier = "mainToDetails"
    private let cellIdentifier = "cell"
    var feeds = try! Realm().objects(NewsRecord)
    let realm = try! Realm()

    // MARK: ViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
//        let parser = Parser()
//        parser.setupParser()
//        parser.delegate = self
//        parser.parse()

        tableView.reloadData()
               // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsRecord = feeds[indexPath.row]
        performSegueWithIdentifier(mainToDetailsSegueIdentifier, sender: newsRecord.link)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == mainToDetailsSegueIdentifier {
            let detailsViewController = segue.destinationViewController as! DetailsViewController
            detailsViewController.link = sender as? String
        }
    }
    
    // MARK: UITableViewDataSource

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! RecordTableViewCell
        let newsRecord = feeds[indexPath.row]
        cell.titleLabel.text = newsRecord.title
        cell.detailsLabel.text = newsRecord.newsDescription
        cell.dateLabel.text = newsRecord.date
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return feeds.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: ParserDelegate
    
    func recordHasBeenParsed(record:NewsRecord) {
//        feeds.append(record)
//        tableView .reloadData()
    }

    
    
}
