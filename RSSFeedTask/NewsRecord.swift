//
//  NewsRecord.swift
//  RSSFeedTask
//
//  Created by Gennady on 7/20/16.
//  Copyright © 2016 Gennady. All rights reserved.
//

import RealmSwift
import Foundation

 class NewsRecord: Object {
    var title : String?
    var newsDescription: String?
    var date : String?
    var link : String?
    var content : String?
    var imageData : NSData?
    

    func saveRecord() -> Void {
        realm!.add(self)
    }
    
    
    
}
