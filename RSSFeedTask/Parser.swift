//
//  Parser.swift
//  RSSFeedTask
//
//  Created by Gennady on 7/20/16.
//  Copyright © 2016 Gennady. All rights reserved.
//

import Foundation

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
            guard (record?.link != nil) else {
                return
            }
            imageLinkFromLink((record?.link)!){ (data, response, error) in
                
                guard (data != nil) else {return}
                let pageString = String(data: data!, encoding: NSUTF8StringEncoding)
                let pageNSString = NSString(data: data!, encoding: NSUTF8StringEncoding)

                let regex = try! NSRegularExpression(pattern:"<img.*?src=\"https://([^\"]*)\"", options: .CaseInsensitive)
                
                let results = regex.matchesInString(pageString! as String, options: NSMatchingOptions.WithTransparentBounds, range: NSMakeRange(0,(pageString?.characters.count)!))

                let range = results.first?.range
                guard range != nil else {return}
                let res = pageNSString?.substringWithRange(range!)
                
                print(res)
                
            }
            return
        }
        
        if (elementName == "encoded") {
            record!.content = content! as String
            return
        }
        
        if ( elementName == "item") {
            self.delegate?.recordHasBeenParsed(record!)
        }
    }
    
    func imageLinkFromLink(link : String, completionHandler: (NSData?, NSURLResponse?, NSError?) -> Void) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig)
        session.dataTaskWithURL(NSURL(string: link)!) {  (data, response, error) in
                    completionHandler(data, response, error)
            
            }.resume()
        return
    }
}
