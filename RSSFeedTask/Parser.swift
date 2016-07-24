//
//  Parser.swift
//  RSSFeedTask
//
//  Created by Gennady on 7/20/16.
//  Copyright © 2016 Gennady. All rights reserved.
//

import Foundation
import RealmSwift


protocol ParserDelegate {
    func recordHasBeenParsed(record:NewsRecord)
}

 class Parser: NSObject, NSXMLParserDelegate {
    
    var delegate : ParserDelegate?
    
    private static let url = "https://developer.apple.com/news/rss/news.rss"

    private let parser = NSXMLParser(contentsOfURL: NSURL(string: url)!)

    private var record : NewsRecord?

    private var title : NSMutableString?
    private var link : NSMutableString?
    private var newsDescription : NSMutableString?
    private var date : NSMutableString?
    private var content : NSMutableString?

    private var currentProperty : NSMutableString?
    
    let realm = try! Realm()

    
    //MARK: interface methods
    
    func setupParser() -> Void {
        parser?.delegate = self
        parser?.shouldProcessNamespaces = true
    }
    
    func parse() -> Void {
        parser?.parse()
    }

    
    // MARK: NSXMLParserDelegate
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        if (elementName == "item") {
            record = NewsRecord()
            return
        }

        if ( elementName == "title") {
            
            title = NSMutableString()
            currentProperty = title
            return
        }
        if ( elementName == "link") {
            
            link = NSMutableString()
            currentProperty = link
            return
        }
        if ( elementName == "description") {
            
            newsDescription = NSMutableString()
            currentProperty = newsDescription
            return
        }
        if ( elementName == "pubDate") {
            
            date = NSMutableString()
            currentProperty = date
            return
        }
        
        if (elementName == "encoded") {
            
            content = NSMutableString()
            currentProperty = content
            return
        }

        currentProperty = nil
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {

        guard (currentProperty != nil) else {
            return
        }
        currentProperty!.appendString(string)
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if ( elementName == "title") {
            record?.title = title! as String
            return
        }
        
        if ( elementName == "description") {
            record?.newsDescription = newsDescription! as String
            return
        }
        
        if ( elementName == "pubDate") {
            record?.date = date! as String
            return
        }
    
        if ( elementName == "link") {
            record?.link = link! as String
            return
        }
        
        if (elementName == "encoded") {
            record!.content = content! as String
            return
        }
        
        if ( elementName == "item") {
            try! realm.write() {
                realm.add(record!)
            }
            self.delegate?.recordHasBeenParsed(record!)
        }
    }
}
