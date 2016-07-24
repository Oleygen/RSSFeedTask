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
    
    dynamic var title : String = ""
    dynamic var newsDescription : String = ""
    dynamic var date : String = ""
    dynamic var link : String = ""
    dynamic var content : String = ""
}
