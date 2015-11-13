//
//  FeedArticleItem.swift
//  NewsFeed
//
//  Created by Etay Luz on 11/13/15.
//  Copyright © 2015 Etay Luz. All rights reserved.
//

import Foundation

struct FeedArticleItem  {
  
  var identifier : String?
  var webUrl : String?
  var thumbnailUrl : String?
  var date : String?
  var headline : String?
  var snippet : String?
  
  init(jsonArticleItem: [String: AnyObject]) {
    identifier = jsonArticleItem["_id"]! as? String
    webUrl = jsonArticleItem["web_url"] as? String
    if let multimediaArray = jsonArticleItem["multimedia"] as? NSArray {
      if let thumbnailMetadata = multimediaArray.lastObject {
        thumbnailUrl = thumbnailMetadata["url"] as? String
        
      }
    }
    date = jsonArticleItem["pub_date"]! as? String
    date = date!.substringToIndex(date!.startIndex.advancedBy(10))
    headline = jsonArticleItem["headline"]!["main"]! as? String
    snippet = jsonArticleItem["snippet"]! as? String
  }
}